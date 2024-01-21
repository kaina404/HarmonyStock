/**
 * 日K线组件
 */
import { KLineData } from '../../bean/KLineData'
import { DrawRect } from '../DrawRect'
import { greenColor, redColor } from '../../common/Constants'

@Component
export struct DayKLineComponent {
  @Prop kLineSourceData: KLineData[] = [] //源数据
  private kLineArrayStartIndex: number = 0 //可以显示的数据
  private kLineArrayEndIndex: number = 0 //可以显示的数据
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private drawRect: DrawRect //可绘制内容的Rect
  private canvasW: number //整个画布的宽度
  private canvasH: number //整个画布的高度
  private canvasDrawMargin = 20 //画布的边距
  private candlestickMargin = 2 //蜡烛图之间的间距
  private defaultCandlestickWidth = 5 //蜡烛默认的宽度
  private defaultMinCandlestickCount = 0 //默认计算出的最少显示的数量
  private candlestickRect: DrawRect = new DrawRect(0, 0, 0, 0) //蜡烛图外围矩形
  private candlestickInnerRect: DrawRect = new DrawRect(0, 0, 0, 0) //蜡烛图外围矩形
  private crossCursorX = -1 //十字光标应该显示的的X轴
  private crossCursorY = -1 //十字光标应该显示的的Y轴
  private longTouchX = -1 //长按下的X
  private longTouchY = -1 //长按下的Y
  private crossCursorCandlestick: KLineData //十字光标的数据

  build() {
    Column() {
      if (this.kLineSourceData.length <= 0) {
        LoadingProgress()
      } else {
        Canvas(this.context)
          .onReady(() => {
            this.canvasW = this.context.width
            this.canvasH = this.context.height
            this.context.translate(this.canvasDrawMargin, 0) //坐标轴水平移动对应的边距
            this.drawRect = new DrawRect(
              0, this.canvasDrawMargin,
              this.canvasW - this.canvasDrawMargin * 2, this.canvasH - this.canvasDrawMargin * 2)
            this._calculateInitData()
            this._drawUI()
          })
          .gesture(
            GestureGroup(GestureMode.Exclusive,
              // PanGesture().onActionUpdate((event: GestureEvent) => {
              //   this._handlerPanGesture(event)
              // }),
              PinchGesture().onActionUpdate((event: GestureEvent) => {
                this._handlerPinchGesture(event)
              }))
          ).gesture(// 声明该组合手势的类型为Sequence类型
          GestureGroup(GestureMode.Sequence,
            // 该组合手势第一个触发的手势为长按手势，且长按手势可多次响应
            LongPressGesture({ repeat: true })// 当长按手势识别成功，绘制十字的X、Y
              .onAction((event: GestureEvent) => {
                if (this.crossCursorX < 0 && this.crossCursorY < 0) {
                  //长按手势可多次响应，这里做个判定，只有无数据时才能刷新
                  let clickFinger = event.fingerList[0]
                  if (clickFinger != undefined && clickFinger != null) {
                    this.longTouchX = clickFinger.globalX
                    this.longTouchY = clickFinger.globalY
                  }
                  //计算出离this.longTouchX最近的蜡烛
                  this.crossCursorCandlestick = this.kLineSourceData[0]
                  var minDiffDistance = this.drawRect.width //最小的计算的差值先填充一个最大值
                  this.kLineSourceData.forEach((item) => {
                    if ((Math.abs(item.centerX - this.longTouchX)) < minDiffDistance) {
                      minDiffDistance = Math.abs(item.centerX - this.longTouchX)
                      this.crossCursorCandlestick = item
                    }
                  })
                  this.crossCursorX = this.crossCursorCandlestick.centerX
                  this.crossCursorY = this.longTouchY
                  this._drawUI()
                }
              }),
            // 当长按之后进行拖动，PanGesture手势被触发
            PanGesture()
              .onActionEnd(() => {
                this.crossCursorX = -1
                this.crossCursorY = -1
              })
              .onActionUpdate((event: GestureEvent) => {
                this.crossCursorX = event.offsetX + this.longTouchX
                this.crossCursorY = event.offsetY + this.longTouchY
                //计算出离this.longTouchX最近的蜡烛
                this.crossCursorCandlestick = this.kLineSourceData[0]
                var minDiffDistance = this.drawRect.width //最小的计算的差值先填充一个最大值
                this.kLineSourceData.forEach((item) => {
                  if ((Math.abs(item.centerX - this.crossCursorX)) < minDiffDistance) {
                    minDiffDistance = Math.abs(item.centerX - this.crossCursorX)
                    this.crossCursorCandlestick = item
                  }
                })
                this.crossCursorX = this.crossCursorCandlestick.centerX
                this._drawUI()
              })
          ))
      }
    }.backgroundColor('#ffffff')
    .width('100%')
    .height('100%')
  }

  private lastOffsetX = 0 //上次拖动的距离
  private lastScaleX = 0 //上次缩放的比例

  //处理捏合缩放手势
  _handlerPinchGesture(event: GestureEvent) {
    this.lastOffsetX = 0
    if (this.lastScaleX == 0) {
      this.lastScaleX = event.scale
    }
    //缩放比例发生变化，超过一定阈值
    if (Math.abs(event.scale - this.lastScaleX) > 0.01) {
      if (this.kLineArrayStartIndex >= 0 && this.kLineArrayStartIndex < this.kLineArrayEndIndex) {
        if (event.scale > this.lastScaleX) {
          if (this.kLineArrayStartIndex < this.kLineArrayEndIndex - 1) {
            this.kLineArrayStartIndex++
          }
        } else {
          if (this.kLineArrayStartIndex >= 1) {
            this.kLineArrayStartIndex--
          }
        }
        this.lastScaleX = event.scale
        if (Math.abs(this.kLineArrayStartIndex - this.kLineArrayEndIndex) < this.defaultMinCandlestickCount) {
          //缩放后，显示的最小蜡烛数量，不能少于初始的默认值。
          return
        }
        //根据显示的数量重新计算宽度
        this.defaultCandlestickWidth = this.drawRect.width / (this.kLineArrayEndIndex - this.kLineArrayStartIndex) - this.candlestickMargin * 2
        this._drawUI()
      }
    }

  }

  //处理拖动手势
  _handlerPanGesture(event: GestureEvent) {
    this.lastScaleX = 0
    //在Canvas上拖动距离超过一定阈值后，才开始刷新UI。
    if (event.offsetX - this.lastOffsetX >= this.defaultCandlestickWidth * 3) {
      if (this.kLineArrayStartIndex >= 1 && this.kLineArrayEndIndex <= this.kLineSourceData.length) {
        //手指从左向右滑动，显示左侧的数据。
        this.kLineArrayStartIndex--
        this.kLineArrayEndIndex--
        this._drawUI()
        this.lastOffsetX = event.offsetX
      }
    } else if (this.lastOffsetX - event.offsetX >= this.defaultCandlestickWidth * 3) {
      if (this.kLineArrayStartIndex >= 0 && this.kLineArrayEndIndex < this.kLineSourceData.length) {
        //手指从右向左滑动，显示右侧的数据。
        this.kLineArrayStartIndex++
        this.kLineArrayEndIndex++
        this._drawUI()
        this.lastOffsetX = event.offsetX
      }
    }
  }

  _calculateInitData() {
    if (this.kLineArrayStartIndex <= 0 && this.kLineArrayEndIndex <= 0) {
      //只有默认进来的第一次才进行计算。后期缩放后，这个计算逻辑会变更

      //根据所有数据的数量计算出一个宽度
      let tmpW = this.drawRect.width / this.kLineSourceData.length - this.candlestickMargin * 2
      var showCount = 0
      if (tmpW < this.defaultCandlestickWidth) {
        //比默认的宽度小，则当前一屏幕显示的数据量少
        showCount = Math.floor(this.drawRect.width / (this.candlestickMargin * 2 + this.defaultCandlestickWidth))
      } else {
        showCount = this.kLineSourceData.length
      }
      this.defaultMinCandlestickCount = Math.floor(this.drawRect.width / (this.defaultCandlestickWidth + this.candlestickMargin * 2))
      this.kLineArrayStartIndex = this.kLineSourceData.length - showCount
      this.kLineArrayEndIndex = this.kLineSourceData.length
    }
  }

  _drawUI() {
    if (this.kLineArrayEndIndex - this.kLineArrayStartIndex < this.defaultMinCandlestickCount) {
      //未知原因可能导致kLineArrayStartIndex很接近kLineArrayEndIndex，这里做一下数据冗余保护。（暂未确定具体什么原因，只能先这样打补丁）
      this.kLineArrayStartIndex = Math.max(0, this.kLineArrayEndIndex - this.defaultMinCandlestickCount)
    }
    this._clearCanvas()
    this._drawBackgroundLine()
    this._drawLine()
    this._drawCrossCursor()
  }

  /**
   * 绘制十字光标
   */
  _drawCrossCursor() {
    if (this.crossCursorX >= this.drawRect.startX && this.crossCursorY >= this.drawRect.startY && this.crossCursorCandlestick != null) {
      this.context.strokeStyle = '#666666'
      this.context.lineWidth = 0.8600009
      //绘制垂直十字轴线
      this.context.beginPath()
      this.context.moveTo(this.crossCursorX, this.drawRect.startY)
      this.context.lineTo(this.crossCursorX, this.drawRect.getEndY())
      this.context.stroke()
      //绘制水平十字轴线
      this.context.beginPath()
      this.context.moveTo(this.drawRect.startX, this.crossCursorY)
      this.context.lineTo(this.drawRect.getEndX(), this.crossCursorY)
      this.context.stroke()
    }
  }

  _drawLine() {
    //找到最高价和最低价，来确定每单位价格的高度
    let allDataMaxPrice = this.kLineSourceData[this.kLineArrayStartIndex].high
    let allDataMinPrice = this.kLineSourceData[this.kLineArrayStartIndex].low
    var kLineMaxEndIndex = this.kLineArrayEndIndex
    const selectedData = this.kLineSourceData.slice(this.kLineArrayStartIndex, kLineMaxEndIndex); // 获取选定的部分数组
    const highs = selectedData.map(data => data.high)
    const lows = selectedData.map(data => data.low)
    allDataMaxPrice = Math.max(Math.max(...highs), Math.max(...lows))
    allDataMinPrice = Math.min(Math.min(...highs), Math.min(...lows))

    var percentPriceUnitHeight = this.drawRect.height / (allDataMaxPrice * 1.0 - allDataMinPrice * 1.0)

    //要考虑特殊情况，当数据很多时，可能出现 itemCandlestickWidth <= 0,这个时候就不能绘制蜡烛图内部的矩形了，使用纯粹竖直线段代替
    var needDrawRect = this.defaultCandlestickWidth >= this.candlestickMargin
    if (needDrawRect) {
      //可绘制蜡烛图的矩形图
      this.candlestickRect.startX = this.drawRect.startX + this.candlestickMargin
      this.candlestickRect.startY = 0
      this.candlestickRect.width = this.defaultCandlestickWidth
      this.candlestickRect.height = 0
      //蜡烛图内部的矩形
      this.candlestickInnerRect.startX = this.drawRect.startX
      this.candlestickInnerRect.startY = 0
      this.candlestickInnerRect.width = this.defaultCandlestickWidth
      this.candlestickInnerRect.height = 0
      //循环绘制每一个蜡烛图数据
      for (let i = this.kLineArrayStartIndex; i < kLineMaxEndIndex; i++) {
        let value = this.kLineSourceData[i]
        //确定蜡烛图 candlestickRect 的实际位置
        this.candlestickRect.startY = this.drawRect.startY + (allDataMaxPrice * 1.0 - value.high * 1.0) * percentPriceUnitHeight
        this.candlestickRect.height = (value.high * 1.0 - value.low) * 1.0 * percentPriceUnitHeight
        //给蜡烛的X核心位置赋值，标记出当前数据所在的X轴位置
        this.kLineSourceData[i].centerX = this.candlestickRect.startX + this.candlestickRect.width / 2
        //绘制蜡烛内部的矩形---------start----------
        this.candlestickInnerRect.startX = this.candlestickRect.startX
        this.candlestickInnerRect.width = this.candlestickRect.width
        this.candlestickInnerRect.height = Math.abs(value.open - value.close) * percentPriceUnitHeight
        if (value.open > value.close) {
          //开盘价大于收盘价,绿跌
          this.candlestickInnerRect.startY = this.candlestickRect.startY + (value.high - value.open) * percentPriceUnitHeight
          this.candlestickInnerRect.fillRect(this.context, greenColor)
        } else {
          //开盘价小于收盘价，红涨
          this.candlestickInnerRect.startY = this.candlestickRect.startY + (value.high - value.close) * percentPriceUnitHeight
          this.candlestickInnerRect.strokeRect(this.context, redColor)
        }
        //绘制蜡烛内部的矩形---------end----------
        //绘制蜡烛图中的竖线
        if (value.open > value.close) {
          //开盘价大于收盘价,绿跌
          this.context.beginPath()
          this.context.strokeStyle = greenColor
          this.context.moveTo(value.centerX, this.candlestickRect.startY)
          this.context.lineTo(value.centerX, this.candlestickRect.getEndY())
          this.context.stroke()
        } else {
          //开盘价小于收盘价，红涨。红涨的中间红色区域是空白的，所以要画两个线段。
          //红框上面的一段红线
          this.context.beginPath()
          this.context.strokeStyle = redColor
          this.context.moveTo(value.centerX, this.candlestickRect.startY)
          this.context.lineTo(value.centerX, this.candlestickInnerRect.startY)
          this.context.stroke()
          //红框下面的一段红线
          this.context.beginPath()
          this.context.strokeStyle = redColor
          this.context.moveTo(value.centerX, this.candlestickInnerRect.getEndY())
          this.context.lineTo(value.centerX, this.candlestickRect.getEndY())
          this.context.stroke()
        }
        //下一个蜡烛图的startX等于当前蜡烛图的endX 加上两个蜡烛之间的间距
        this.candlestickRect.startX = this.candlestickRect.getEndX() + this.candlestickMargin * 2
      }
    } else {
      //不用绘制矩形，直接绘制竖线即可
      this.candlestickRect.startX = this.drawRect.startX
      this.candlestickRect.startY = this.drawRect.startY
      this.candlestickRect.width = this.drawRect.width / (kLineMaxEndIndex - this.kLineArrayStartIndex)
      this.candlestickRect.height = 0
      for (let i = this.kLineArrayStartIndex; i < kLineMaxEndIndex; i++) {
        let value = this.kLineSourceData[i]
        this.candlestickRect.startY = this.drawRect.startY + (allDataMaxPrice * 1.0 - value.high * 1.0) * percentPriceUnitHeight
        this.candlestickRect.height = (value.high * 1.0 - value.low) * 1.0 * percentPriceUnitHeight
        //给蜡烛的X核心位置赋值，标记出当前数据所在的X轴位置
        this.kLineSourceData[i].centerX = this.candlestickRect.startX + this.candlestickRect.width / 2
        //绘制蜡烛图中的竖线
        this.context.beginPath()
        if (value.open > value.close) {
          //开盘价大于收盘价,绿跌
          this.context.strokeStyle = greenColor
          this.candlestickRect.startY = this.candlestickRect.startY + (value.high - value.open) * percentPriceUnitHeight
        } else {
          //开盘价小于收盘价，红涨。
          this.context.strokeStyle = redColor
          this.candlestickRect.startY = this.candlestickRect.startY + (value.high - value.close) * percentPriceUnitHeight
        }
        this.context.moveTo(value.centerX, this.candlestickRect.startY)
        this.context.lineTo(value.centerX, this.candlestickRect.getEndY())
        this.context.stroke()
        //下一个蜡烛图的startX等于当前蜡烛图的endX 加上两个蜡烛之间的间距
        this.candlestickRect.startX = this.candlestickRect.getEndX()
      }

    }
  }

  //绘制背景的方格线
  _drawBackgroundLine() {
    let w = this.drawRect.width
    //-------------绘制背景的分时方格线-------start---------
    let h = this.drawRect.height
    //绘制4x4方格背景矩形
    this.drawRect.strokeRect(this.context, '#E7E7E7')

    this.context.strokeStyle = '#E7E7E7'
    let itemDistanceY = h / 4
    //3条水平线
    let startY = this.drawRect.startY + itemDistanceY
    for (let i = 0; i < 3; i++) {
      this.context.beginPath();
      this.context.moveTo(this.drawRect.startX, startY)
      this.context.lineTo(this.drawRect.getEndX(), startY)
      startY = startY + itemDistanceY
      this.context.stroke()
    }
  }

  //清空画布的所有内容
  _clearCanvas() {
    this.context.clearRect(0, 0, this.canvasW, this.canvasH)
  }

  _log(msg: string) {
    console.log("StockLog:" + msg)
  }
}
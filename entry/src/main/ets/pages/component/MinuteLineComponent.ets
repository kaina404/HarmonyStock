/*
 * Copyright (c) 2024 Kaina404 Device Co., Ltd.
 *
 *  https://github.com/kaina404/
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { RequestStockApi } from '../../network/RequestStockApi'
import { DrawRect } from '../DrawRect'
import { MinuteData } from '../../bean/MinuteData'
import { MinuteItemData } from '../../bean/MinuteItemData'

/**
 * 分时线组件
 */
@Component
export struct MinuteLineComponent {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private canvasDrawMargin: number = 20 //画布的边距
  @Prop stockData: MinuteData = new MinuteData()
  private canvasW: number //整个画布的宽度
  private canvasH: number //整个画布的高度
  private maxPriceTxtWidth: number = 0 //当日的最高价格文本的宽度
  private singleTxtWidth: number = 0 //普通文本的宽度
  private singleTxtHeight: number = 0 //普通文本的高度
  private minuteRect: DrawRect //分时的区域
  private chengJiaoLiangRect: DrawRect //分时下面量比的区域
  private lineRect: DrawRect //分时+量比的所有绘制内容的区域
  private stockApi: RequestStockApi = new RequestStockApi()

  build() {
    Column() {
      if (this.stockData.code != undefined) {
        Canvas(this.context)
          .onReady(() => {
            this.canvasW = this.context.width
            this.canvasH = this.context.height
            this.lineRect = new DrawRect(this.canvasDrawMargin, this.canvasDrawMargin, this.canvasW - this.canvasDrawMargin * 2, this.canvasH - this.canvasDrawMargin * 2)
            this.minuteRect = new DrawRect(this.canvasDrawMargin, this.canvasDrawMargin, this.lineRect.width, this.lineRect.height * 0.7)

            this.context.font = '40px'
            this.maxPriceTxtWidth = this.context.measureText(this.stockData.maxDistancePrice + '').width
            this.singleTxtWidth = this.context.measureText("价").width
            this.singleTxtHeight = this.context.measureText("价").height
            // this.singleTxtHeight * 2 留给分时跟量比中间的区域
            let liangBiStartY = this.minuteRect.getEndY() + this.singleTxtHeight
            this.chengJiaoLiangRect = new DrawRect(this.lineRect.startX, liangBiStartY, this.lineRect.width, this.lineRect.height - this.minuteRect.height - this.singleTxtHeight * 2)
            this.reDrawAllCanvas()
          })
          .onTouch((event) => {
            this._handlerCanvasTouchEvent(event)
          })
          .width('100%')
          .height('100%')
      } else {
        LoadingProgress()
      }
    }
    .width('100%')
    .height('100%')
  }

  _handlerCanvasTouchEvent(event?: TouchEvent) {
    if (event.type == TouchType.Move) {
      let touchedY = event.touches[0].y
      if (touchedY < this.canvasDrawMargin || touchedY > this.context.height - this.canvasDrawMargin) {
        return
      }
      var x = event.touches[0].x
      //遍历离自己最新的X轴位置的数据索引
      var minDistanceIndex = 0
      //上次计算到的最靠近的X位置
      var lastXData = 0
      //上次计算的差距
      var lastDistance = this.stockData.line[minDistanceIndex].lineX
      this.stockData.line.forEach((item, index) => {
        if (Math.abs(item.lineX - x) < lastDistance) {
          lastXData = item.lineX
          minDistanceIndex = index
          lastDistance = Math.abs(item.lineX - x)
        }
      })
      //当前触摸位置的分时数据
      x = lastXData
      this._clearCanvas()
      this._drawMinuteLine()
      this._drawChengJiaoLiang()
      let touchStockData = this.stockData.line[minDistanceIndex]
      this._drawJiaFuJunLiang(touchStockData)
      if (touchedY >= this.minuteRect.startY && touchedY <= this.minuteRect.getEndY()) {
        //绘制分时区域价格

        //绘制水平十字轴线
        this.context.strokeStyle = '#666666'
        this.context.lineWidth = 0.8600009
        this.context.beginPath()
        this.context.moveTo(this.minuteRect.startX, touchedY)
        this.context.lineTo(this.minuteRect.getEndX(), touchedY)
        this.context.stroke()
        //绘制水平十字轴线左侧的分时价格
        let txtYValue = this.stockApi.roundUpToTwoDecimalPlaces(this.stockData.lineHighest - (touchedY - this.minuteRect.startY) / this.minuteRect.height * (this.stockData.lineHighest - this.stockData.lineLowest))
        let textMetrics2 = this.context.measureText(txtYValue)
        let txtW2 = textMetrics2.width
        let txtH2 = textMetrics2.height
        this.context.fillStyle = '#364d92'
        this.context.fillRect(this.minuteRect.startX, touchedY - txtH2 / 2, txtW2, txtH2)
        this.context.font = '40px'
        this.context.fillStyle = '#ffffff'
        this.context.textAlign = 'center'
        this.context.textBaseline = 'middle'
        this.context.fillText(txtYValue, this.minuteRect.startX + txtW2 / 2, touchedY)
      } else if (touchedY >= this.chengJiaoLiangRect.startY && touchedY <= this.chengJiaoLiangRect.getEndY()) {
        //绘制成交量

        //绘制水平十字轴线
        this.context.strokeStyle = '#666666'
        this.context.lineWidth = 0.8600009
        this.context.beginPath()
        this.context.moveTo(this.minuteRect.startX, touchedY)
        this.context.lineTo(this.minuteRect.getEndX(), touchedY)
        this.context.stroke()
        //绘制水平十字轴线左侧的成交量
        let txtYValue = parseInt((((this.stockData.maxChengJiaoLiang - (touchedY - this.chengJiaoLiangRect.startY) / this.chengJiaoLiangRect.height * (this.stockData.maxChengJiaoLiang - this.stockData.minChengJiaoLiang))) / 100).toString())
          .toString()
        let textMetrics2 = this.context.measureText(txtYValue)
        let txtW2 = textMetrics2.width
        let txtH2 = textMetrics2.height
        this.context.fillStyle = '#364d92'
        this.context.fillRect(this.minuteRect.startX, touchedY - txtH2 / 2, txtW2, txtH2)
        this.context.font = '40px'
        this.context.fillStyle = '#ffffff'
        this.context.textAlign = 'center'
        this.context.textBaseline = 'middle'
        this.context.fillText(txtYValue, this.minuteRect.startX + txtW2 / 2, touchedY)
      }
      //绘制垂直十字轴线
      this.context.beginPath()
      this.context.moveTo(x, this.minuteRect.startY)
      this.context.lineTo(x, this.chengJiaoLiangRect.getEndY())
      this.context.stroke()
      //计算底部时间文本香瓜数据
      this.context.font = '40px'
      let txt = '' + touchStockData.time
      if (txt.length <= 0) {
        return
      }
      if (txt.length == 5) {
        txt = '0' + txt
      }
      if (txt.length < 6) {
        return
      }
      txt = txt.substring(0, 2) + ":" + txt.substring(2, 4)
      let textMetrics = this.context.measureText(txt)
      let txtW = textMetrics.width
      let txtH = textMetrics.height
      this.context.fillStyle = '#364d92'
      //绘制底部时间文本框
      this.context.fillRect(x - txtW / 2, this.minuteRect.getEndY(), txtW, txtH)
      // 绘制底部时间文本
      this.context.fillStyle = '#ffffff'
      this.context.textAlign = 'center'
      this.context.textBaseline = 'middle'
      this.context.fillText(txt, x, this.minuteRect.getEndY() + txtH / 2)
    }
  }

  //重新绘制
  reDrawAllCanvas() {
    this._clearCanvas()
    let lastMinJiaFujunLiang = this.stockData.line[this.stockData.line.length-1]
    if (lastMinJiaFujunLiang != null && lastMinJiaFujunLiang != undefined) {
      this._drawJiaFuJunLiang(lastMinJiaFujunLiang)
    }
    this._drawMinuteLine()
    this._drawChengJiaoLiang()
  }

  //清空画布的所有内容
  _clearCanvas() {
    this.context.clearRect(0, 0, this.canvasW, this.canvasH)
  }

  _drawJiaFuJunLiang(stockData: MinuteItemData) {
    //---------绘制触摸时刻分钟线对应的时刻的 价格/涨跌幅/均价-----start------
    this.context.font = '40px'
    let price = stockData.price
    let priceColor = ''
    if (price > this.stockData.prev_close) {
      priceColor = '#e2233e'
    } else if (price == this.stockData.prev_close) {
      priceColor = '#fcfcfc'
    } else {
      priceColor = '#228B22'
    }
    //这里文本left-align
    this.context.textAlign = 'left'
    this.context.textBaseline = 'middle'
    let txtColor = '#666666'
    let valueY = this.canvasDrawMargin - this.singleTxtHeight / 2
    let jia_fu_jun_liang_data: Array<Array<string>> = [
      ['价', '' + price],
      ['幅', '' + this.stockApi.roundUpToTwoDecimalPlaces((price - this.stockData.prev_close) * 100 / this.stockData.prev_close) + "%"],
      ['均', '' + this.stockApi.roundUpToTwoDecimalPlaces(stockData.junjia)],
      ['量', '' + stockData.chengJiaoLiang / 100 + '']
    ]
    jia_fu_jun_liang_data.forEach((item, index) => {
      this.context.fillStyle = txtColor
      this.context.fillText(item[0], this.minuteRect.startX + (20 + this.singleTxtWidth + this.maxPriceTxtWidth) * index, valueY)
      this.context.fillStyle = priceColor
      this.context.fillText(item[1], this.minuteRect.startX + (20 + this.singleTxtWidth + this.maxPriceTxtWidth) * index + this.singleTxtWidth, valueY)
    })
    //---------绘制触摸时刻分钟线对应的时刻的 价格/涨跌幅/均价-----end------
  }

  //绘制背景的方格线
  drawBackgroundLine() {
    //-------------绘制背景的分时方格线-------start---------
    let w = this.minuteRect.width
    let h = this.minuteRect.height
    //绘制4x4方格背景矩形
    this.minuteRect.strokeRect(this.context, '#E7E7E7')

    this.context.strokeStyle = '#E7E7E7'
    let itemDistanceY = h / 4
    //3条水平线
    let startY = this.minuteRect.startY + itemDistanceY
    for (let i = 0; i < 3; i++) {
      this.context.beginPath();
      this.context.moveTo(this.minuteRect.startX, startY)
      this.context.lineTo(this.minuteRect.getEndX(), startY)
      startY = startY + itemDistanceY
      this.context.stroke()
    }
    let itemDistanceX = w / 4
    //3条垂直线
    this.context.beginPath()
    let startX = this.minuteRect.startX + itemDistanceX
    for (let i = 0; i < 3; i++) {
      this.context.beginPath()
      this.context.moveTo(startX, this.minuteRect.startX)
      this.context.lineTo(startX, this.minuteRect.getEndY())
      startX = startX + itemDistanceX
      this.context.stroke()
    }
    //-------------绘制背景的分时方格线-------end---------

    //-------------绘制背景的量比方格线-------start---------
    //矩形
    this.chengJiaoLiangRect.strokeRect(this.context, '#ececec')
    //水平
    startY = this.chengJiaoLiangRect.startY + this.chengJiaoLiangRect.height / 2
    this.context.beginPath();
    this.context.moveTo(this.chengJiaoLiangRect.startX, startY)
    this.context.lineTo(this.chengJiaoLiangRect.getEndX(), startY)
    this.context.stroke()
    //-------------绘制背景的量比方格线-------end---------
  }

  //绘制分钟线
  _drawMinuteLine() {
    this.drawBackgroundLine()
    this.drawMinuteLine()
    this.drawAveragePriceLine()
    this.context.font = '40px'
    this.context.textAlign = 'center'
    this.context.textBaseline = 'middle'
    //绘制左侧最高价格
    if (this.stockData.lineHighest != null) {
      this.context.fillStyle = '#e2233e'
      let txtH = this.stockApi.roundUpToTwoDecimalPlaces(this.stockData.lineHighest)
      this.context.fillText(txtH, this.minuteRect.startX + this.maxPriceTxtWidth / 2, this.minuteRect.startY + this.singleTxtHeight)
    }
    //绘制昨收价格
    if (this.stockData.prev_close != null) {
      this.context.fillStyle = '#6c6c6c'
      let txtH = this.stockApi.roundUpToTwoDecimalPlaces(this.stockData.prev_close)
      this.context.fillText(txtH, this.minuteRect.startX + this.maxPriceTxtWidth / 2, this.minuteRect.height / 2 + this.singleTxtHeight)
    }
    //绘制左侧最低价格
    if (this.stockData.lineLowest != null) {
      this.context.fillStyle = '#228B22'
      let txtH = this.stockApi.roundUpToTwoDecimalPlaces(this.stockData.lineLowest)
      this.context.fillText(txtH, this.minuteRect.startX + this.maxPriceTxtWidth / 2, this.minuteRect.getEndY() - this.singleTxtHeight / 2)
    }
  }

  //绘制均价
  drawAveragePriceLine() {
    this.context.strokeStyle = '#e99a4c'
    this.context.lineWidth = 0.8600009
    this.context.beginPath()
    let itemCount = Math.max(this.stockData.line.length, 240)
    //按照分时数据量平分两个分时数据之间的间距
    let itemDistance = this.minuteRect.width / itemCount
    let path = new Path2D()
    this.stockData.line.forEach((value, index) => {
      if (index >= itemCount) {
        return
      }
      let x = this.minuteRect.startX + index * itemDistance
      let y = this.minuteRect.height / 2 - (value.junjia - this.stockData.prev_close) / this.stockData.maxDistancePrice * (this.minuteRect.height / 2) + this.minuteRect.startY
      if (index == 0) {
        path.moveTo(x, y)
      } else {
        path.lineTo(x, y)
      }
    })
    this.context.stroke(path)
  }

  //绘制分时线
  drawMinuteLine() {
    this.context.strokeStyle = '#364d92'
    this.context.lineWidth = 0.8600009
    this.context.beginPath()
    let itemCount = Math.max(this.stockData.line.length, 240)
    let itemDistance = this.minuteRect.width / itemCount
    let path = new Path2D()
    this.stockData.line.forEach((value, index) => {
      if (index >= itemCount) {
        return
      }
      let x = this.minuteRect.startX + index * itemDistance
      value.lineX = x
      let y = this.minuteRect.height / 2 - (value.price - this.stockData.prev_close) / this.stockData.maxDistancePrice * (this.minuteRect.height / 2) + this.minuteRect.startY
      if (index == 0) {
        path.moveTo(x, y)
      } else {
        path.lineTo(x, y)
      }

    })
    this.context.stroke(path)
  }

  //绘制成交量
  _drawChengJiaoLiang() {
    this.context.strokeStyle = '#e99a4c'
    this.context.lineWidth = 0.8600009
    this.stockData.line.forEach((value, index) => {
      if (value.price)
        this.context.beginPath()
      this.context.moveTo(value.lineX, ((this.stockData.maxChengJiaoLiang - value.chengJiaoLiang) / this.stockData.maxChengJiaoLiang) * this.chengJiaoLiangRect.height + this.chengJiaoLiangRect.startY)
      this.context.lineTo(value.lineX, this.chengJiaoLiangRect.getEndY())
      this.context.stroke()
    })
  }
}

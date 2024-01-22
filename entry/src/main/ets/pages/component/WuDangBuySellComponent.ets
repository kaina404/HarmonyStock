import { WuDangData, WuDangPrice } from '../../bean/StockBasicInfoBean'
import { getTextMaxFontSize } from '../../common/CommonUtils'
import { DrawRect } from '../DrawRect'

/**
 * 买卖五档的基础组件
 */
@Component
export struct WuDangBuySellComponent {
  @Prop wuDangData: WuDangData
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private drawRect: DrawRect //可绘制内容的Rect
  private canvasW: number //整个画布的宽度
  private canvasH: number //整个画布的高度
  private canvasDrawMargin = 10 //画布的边距

  build() {
    Column() {
      if (this.wuDangData == undefined || this.wuDangData.buy == undefined || this.wuDangData.sell == undefined || this.wuDangData.buy.length <= 0 && this.wuDangData.sell.length <= 0) {
        LoadingProgress()
      } else {
        Canvas(this.context)
          .onReady(() => {
            this.canvasW = this.context.width
            this.canvasH = this.context.height
            this.drawRect = new DrawRect(this.canvasDrawMargin, this.canvasDrawMargin, this.canvasW - this.canvasDrawMargin * 2, this.canvasH - this.canvasDrawMargin * 2)
            this._drawUI()
          })
      }
    }
  }

  //清空画布的所有内容
  _clearCanvas() {
    this.context.clearRect(0, 0, this.canvasW, this.canvasH)
  }

  //绘制UI
  _drawUI() {
    this._clearCanvas()
    this._drawWuDangUI()
  }

  _drawWuDangUI() {
    //根据drawRect的高度+买卖总计多少条数据 进行
    // 反推计算出字体的大小,然后再绘制列表数据
    //每个文字的高度
    const itemTextHeight = this.drawRect.height / (this.wuDangData.sell.length + this.wuDangData.buy.length + 1)
    const priceRect = new DrawRect(this.drawRect.startX, this.drawRect.startY, this.drawRect.width, itemTextHeight)
    //反推计算每个文字的大小
    //计算出最大的价格
    var maxPrice = this.wuDangData.sell[0].price
    var maxAmount = this.wuDangData.sell[0].amount
    var allBuyAmount = 0
    var allSellAmount = 0
    this.wuDangData.sell.forEach((item) => {
      if (item.price > maxPrice) {
        maxPrice = item.price
      }
      if (item.amount > maxAmount) {
        maxAmount = item.amount
      }
      allSellAmount += item.amount
    })
    this.wuDangData.buy.forEach((item) => {
      if (item.price > maxPrice) {
        maxPrice = item.price
      }
      if (item.amount > maxAmount) {
        maxAmount = item.amount
      }
      allBuyAmount += item.amount
    })
    this.context.font = getTextMaxFontSize(this.context, priceRect, '25px', '卖1' + " " + maxPrice + " " + maxAmount)
    this.wuDangData.sell.forEach((value: WuDangPrice, index) => {
      //卖1
      this.context.textAlign = 'left'
      this.context.textBaseline = 'top'
      this.context.fillStyle = '#737F8A'
      this.context.fillText('卖' + (5 - index), 0, index * itemTextHeight)
      //价格
      this.context.textAlign = 'center'
      this.context.textBaseline = 'top'
      this.context.fillStyle = '#e2233e'
      this.context.fillText(value.price.toString(), this.drawRect.width / 2, index * itemTextHeight)
      //量
      this.context.textAlign = 'right'
      this.context.textBaseline = 'top'
      this.context.fillStyle = '#000000'
      this.context.fillText(value.amount.toString(), this.drawRect.getEndX(), index * itemTextHeight)
    })

    //绘制买卖力量对比量横线
    const buyLength = (allBuyAmount / allBuyAmount + allSellAmount) * this.drawRect.width
    //买横线
    this.context.fillStyle = "#e2233e"
    this.context.fillRect(this.drawRect.startX, this.drawRect.height / 2, buyLength, 2)
    //卖横线
    this.context.fillStyle = "#228B22"
    this.context.fillRect(this.drawRect.width / 2, this.drawRect.height / 2, this.drawRect.width - buyLength, 2)

    this.wuDangData.buy.forEach((value: WuDangPrice, index) => {
      //买1
      this.context.textAlign = 'left'
      this.context.textBaseline = 'top'
      this.context.fillStyle = '#737F8A'
      this.context.fillText('买' + index, 0, (index + 1 + this.wuDangData.sell.length) * itemTextHeight)
      //价格
      this.context.textAlign = 'center'
      this.context.textBaseline = 'top'
      this.context.fillStyle = '#e2233e'
      this.context.fillText(value.price.toString(), this.drawRect.width / 2, (index + 1 + this.wuDangData.sell.length) * itemTextHeight)
      //量
      this.context.textAlign = 'right'
      this.context.textBaseline = 'top'
      this.context.fillStyle = '#000000'
      this.context.fillText(value.amount.toString(), this.drawRect.getEndX(), (index + 1 + this.wuDangData.sell.length) * itemTextHeight)
    })
  }
}
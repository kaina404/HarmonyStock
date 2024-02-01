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
/**
 * 个股详情页，盘口组件
 */
import { getTextMaxFontSize } from '../../common/CommonUtils'
import { DrawRect } from '../DrawRect'
import { MinuteData } from '../../bean/MinuteData'
import { StockBasicInfoBean } from '../../bean/StockBasicInfoBean'

@Component
export struct PanKouComponent {
  @Prop stockBasicInfoBean: StockBasicInfoBean = new StockBasicInfoBean()
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private drawRect: DrawRect //可绘制内容的Rect
  private priceRect: DrawRect //最新价的Rect
  private priceBottomRect: DrawRect //最新价下面的涨跌的Rect
  private panKouDetail: DrawRect //盘口的详情区域
  private canvasW: number //整个画布的宽度
  private canvasH: number //整个画布的高度
  private canvasDrawMargin = 10 //画布的边距
  private stockPriceFontSize = '40px' //股票价格字体大小
  private smallFontSize = '20px' //普通文字大小
  private defaultTxtColor = '#5a5a5a'

  build() {
    Column() {
      if (this.stockBasicInfoBean != null && this.stockBasicInfoBean.code != undefined) {
        Canvas(this.context)
          .onReady(() => {
            this.canvasW = this.context.width
            this.canvasH = this.context.height
            this.drawRect = new DrawRect(this.canvasDrawMargin, this.canvasDrawMargin, this.canvasW - this.canvasDrawMargin * 2, this.canvasH - this.canvasDrawMargin * 2)
            this.priceRect = new DrawRect(this.drawRect.startX, this.drawRect.startY, this.drawRect.width / 4 * 1.1, this.drawRect.height * 1.0 / 3 * 2)
            this.priceBottomRect = new DrawRect(this.drawRect.startX, this.priceRect.getEndY(), this.priceRect.width, this.drawRect.height - this.priceRect.height)
            this.panKouDetail = new DrawRect(this.priceBottomRect.getEndX(), this.drawRect.startY, this.drawRect.width - this.priceRect.width, this.drawRect.height)
            this._drawUI()
          })
      } else {
        LoadingProgress()
      }
    }.backgroundColor('#ffffff')
    .width('100%')
    .height('100%')
  }

  //绘制UI
  _drawUI() {
    this._clearCanvas()
    this._drawNewPrice()
    this._drawPanKouDetail()
    // this.panKouDetail.strokeRect(this.context, "#e2233e")
  }


  //盘口头部的数据
  getCube(): Array<Array<Array<string>>> {
    var cube: Array<Array<Array<string>>> =
      [
        [
          ['高', this.stockBasicInfoBean.snap.high.toString()],
          ['市值', (this.stockBasicInfoBean.snap.amount / 100000 / 100).toFixed(2).toString()],
          ['量', (this.stockBasicInfoBean.snap.volume / 100000 / 100).toFixed(2) + "万"],
        ],
        [
          ['低', this.stockBasicInfoBean.snap.low.toString()],
          ['流通', '488.0亿'],
          ['换', '3.02%'],
        ],
        [
          ['开', this.stockBasicInfoBean.snap.open.toString()],
          ['市盈', '37.00'],
          ['额', '14.72亿'],
        ]
      ]
    return cube
  }

  //绘制盘口的3x3布局数据
  _drawPanKouDetail() {
    this.context.font = this.stockPriceFontSize
    this.context.textBaseline = 'top'
    let itemW = this.panKouDetail.width / 3
    let itemH = this.panKouDetail.height / 3
    var textY = this.panKouDetail.startY
    for (let i = 0; i < this.getCube().length; i++) {
      var textX = this.panKouDetail.startX
      let lineData: Array<Array<string>> = this.getCube()[i]
      for (let j = 0; j < lineData.length; j++) {
        let lineItemData: Array<string> = lineData[j]
        this.context.textAlign = 'start'
        this.context.fillStyle = this.defaultTxtColor
        this.context.fillText('' + lineItemData[0], textX + 10, textY) //10是边距
        this.context.textAlign = 'end'
        this.context.fillStyle = this._getNewPriceColor()
        this.context.fillText('' + lineItemData[1], textX + itemW, textY)
        textX += itemW
      }
      textY += itemH
    }
  }

  _getNewPriceColor(): string {
    let price = this.stockBasicInfoBean.snap.last
    let priceColor = ''
    if (price > this.stockBasicInfoBean.snap.prev_close) {
      priceColor = '#e2233e'
    } else if (price == this.stockBasicInfoBean.snap.prev_close) {
      priceColor = '#fcfcfc'
    } else {
      priceColor = '#228B22'
    }
    return priceColor
  }

  _drawNewPrice() {
    //绘制最新价格
    this.context.font = this.stockPriceFontSize
    let price = this.stockBasicInfoBean.snap.last
    let priceColor = this._getNewPriceColor()
    var formatPrice: string
    if (price > 0) {
      formatPrice = '+' + price
    } else {
      formatPrice = '-' + price
    }

    //------根据字体大小开始绘制最新价------start------
    this.context.textAlign = 'left'
    this.context.textBaseline = 'top'
    this.context.font = getTextMaxFontSize(this.context, this.priceRect, this.stockPriceFontSize, formatPrice)
    this.context.fillStyle = priceColor
    this.context.fillText('' + price, this.drawRect.startX, this.drawRect.startY)
    //------根据字体大小开始绘制最新价------end------
    //开始计算底部的涨跌额、涨跌幅的高度。逻辑同上面
    if (this.stockBasicInfoBean.snap.last != undefined) {
      this.context.textAlign = 'left'
      this.context.textBaseline = 'top'
      var priceBottomTxt = ''
      if (this.stockBasicInfoBean.snap.ampRate > 0) {
        priceBottomTxt = '+' + this.stockBasicInfoBean.snap.ampRate + " " + this.stockBasicInfoBean.snap.riseFall + "%"
      } else {
        priceBottomTxt = this.stockBasicInfoBean.snap.ampRate + " " + this.stockBasicInfoBean.snap.riseFall + "%"
      }
      let font = getTextMaxFontSize(this.context, this.priceBottomRect, this.smallFontSize, priceBottomTxt)
      this.context.font = font
      this.context.fillStyle = priceColor
      this.context.fillText(priceBottomTxt, this.priceBottomRect.startX, this.priceBottomRect.startY)
    }
  }

  //清空画布的所有内容
  _clearCanvas() {
    this.context.clearRect(0, 0, this.canvasW, this.canvasH)
  }
}
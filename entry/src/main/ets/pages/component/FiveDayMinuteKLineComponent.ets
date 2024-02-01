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
import { FiveDayData, FiveDayMinuteDataWrapper } from '../../bean/FiveDayMinuteData'
import { DrawRect } from '../DrawRect'

/**
 * 五日分钟线
 * 五日分钟线，一共有五列。每一列，都是当天的所有数据。（有的股票软
 * 件是以五分钟为一组，我们这里显示当天的所有数据）
 * 每一列画出的当天的分时图，跟 MinuteLineComponent 组件的绘制逻辑
 * 大致相同。
 */
@Component
export struct FiveDayMinuteKLineComponent {
  @Prop fiveDayData: FiveDayData = new FiveDayData() //五日分钟线的数据
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private canvasDrawMargin: number = 20 //画布的边距
  private canvasW: number //整个画布的宽度
  private canvasH: number //整个画布的高度
  private minuteRect: DrawRect //分钟的所有绘制内容的区域

  build() {
    if (this.fiveDayData.allDataMaxPrice == undefined) {
      LoadingProgress()
    } else {
      Canvas(this.context)
        .onReady(() => {
          this.canvasW = this.context.width
          this.canvasH = this.context.height
          this.minuteRect = new DrawRect(this.canvasDrawMargin, this.canvasDrawMargin, this.canvasW - this.canvasDrawMargin * 2, this.canvasH - this.canvasDrawMargin * 2)
          this.context.font = '40px'
          this._reDrawAllCanvas()
        })
        .width('100%')
        .height('100%')
        .onTouch((event) => {
          this._handlerCanvasTouchEvent(event)
        })
    }
  }

  //清空画布的所有内容
  _clearCanvas() {
    this.context.clearRect(0, 0, this.canvasW, this.canvasH)
  }

  //重新绘制
  _reDrawAllCanvas() {
    this._clearCanvas()
    this.drawBackgroundLine()
    this.drawMinuteLine()
  }

  /**
   * 绘制分钟线
   * 拿出五条数据，循环绘制。
   * 如何计算价格（Price）的Y轴坐标（PricePositionY）呢？
   * (MaxPrice - Price)/(MaxPrice-MinPrice) = (PricePositionY - RectStartY) / (RectEndY - RectStartY)  【等比例原理】
   * 所以，(MaxPrice - Price)/(MaxPrice-MinPrice) = (PricePositionY - RectStartY) / RectHeight
   * PricePositionY =  (MaxPrice - Price)/(MaxPrice-MinPrice) * RectHeight + RectStartY
   *
   * 如何计算价格（Price）的X轴坐标（PricePositionX）呢？
   * PricePositionX = RectStartX + PriceIndex * (RectWidth / AllDataCount)
   */
  drawMinuteLine() {
    //----------绘制分钟线----------start---------
    this.context.strokeStyle = '#364d92'
    this.context.lineWidth = 0.8600009
    //循环遍历每一天
    if(this.fiveDayData == undefined || this.fiveDayData.fiveDayMinuteDataWrapper == undefined || this.fiveDayData.fiveDayMinuteDataWrapper.length <= 0) {
      return
    }
    this.fiveDayData.fiveDayMinuteDataWrapper.forEach((currentDayData, allDatIndex) => {
      //遍历当前的所有数据
      let path = new Path2D()
      currentDayData.fiveDayMinuteDataAry.forEach((itemDayData, index) => {
        //循环绘制出每个格子中的所有数据。PricePositionY =  (MaxPrice - Price)/(MaxPrice-MinPrice) * RectHeight + RectStartY
        const pricePositionY = (this.fiveDayData.allDataMaxPrice - itemDayData.close)
          / (this.fiveDayData.allDataMaxPrice - this.fiveDayData.allDataMinPrice)
          * this.minuteRect.height
          + this.minuteRect.startY
        //PricePositionX = RectStartX + PriceIndex * (RectWidth / AllDataCount)
        const pricePositionX = (((this.minuteRect.width) / 5 ) * allDatIndex) + this.minuteRect.startX + index * ((this.minuteRect.width) / 5 / currentDayData.fiveDayMinuteDataAry.length)
        if (index == 0) {
          path.moveTo(pricePositionX, pricePositionY)
        } else {
          path.lineTo(pricePositionX, pricePositionY)
        }
      })
      this.context.stroke(path)
    })
    //----------绘制分钟线----------END---------
    //
    this.context.strokeStyle = '#e99a4c'
    this.context.lineWidth = 0.8600009
    this.fiveDayData.fiveDayMinuteDataWrapper.forEach((currentDayData, allDatIndex) => {
      //遍历当前的所有数据
      let path = new Path2D()
      currentDayData.fiveDayMinuteDataAry.forEach((itemDayData, index) => {
        //循环绘制出每个格子中的所有数据。PricePositionY =  (MaxPrice - Price)/(MaxPrice-MinPrice) * RectHeight + RectStartY
        const pricePositionY = (this.fiveDayData.allDataMaxPrice - itemDayData.ma_price5)
          / (this.fiveDayData.allDataMaxPrice - this.fiveDayData.allDataMinPrice)
          * this.minuteRect.height
          + this.minuteRect.startY
        //PricePositionX = RectStartX + PriceIndex * (RectWidth / AllDataCount)
        const pricePositionX = (((this.minuteRect.width) / 5 ) * allDatIndex) + this.minuteRect.startX + index * ((this.minuteRect.width) / 5 / currentDayData.fiveDayMinuteDataAry.length)
        if (index == 0) {
          path.moveTo(pricePositionX, pricePositionY)
        } else {
          path.lineTo(pricePositionX, pricePositionY)
        }
      })
      this.context.stroke(path)
    })
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
    let itemDistanceX = w / 5
    //4条垂直线
    this.context.beginPath()
    let startX = this.minuteRect.startX + itemDistanceX
    for (let i = 0; i < 4; i++) {
      this.context.beginPath()
      this.context.moveTo(startX, this.minuteRect.startX)
      this.context.lineTo(startX, this.minuteRect.getEndY())
      startX = startX + itemDistanceX
      this.context.stroke()
    }
    //-------------绘制背景的分时方格线-------end---------
  }

  //处理触摸事件
  _handlerCanvasTouchEvent(event?: TouchEvent) {

  }
}
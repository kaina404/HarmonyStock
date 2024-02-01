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
import router from '@ohos.router';
import { RequestKLineApi } from '../network/RequestKLineApi';
import { RequestStockApi } from '../network/RequestStockApi';
import { FiveDayMinuteKLineComponent } from './component/FiveDayMinuteKLineComponent';
import { KLineData } from '../bean/KLineData';
import { MinuteData } from '../bean/MinuteData';
import { RequestFiveDayMinuteApi } from '../network/RequestFiveDayMinuteApi';
import { FiveDayData } from '../bean/FiveDayMinuteData';
import { PanKouComponent } from './component/PanKouComponent';
import { MinuteLineComponent } from './component/MinuteLineComponent';
import { DayKLineComponent } from './component/DayKLineComponent';
import { redColor, redColorRGB } from '../common/Constants';
import { RequestStockBasicInfoApi } from '../network/RequestStockBasicInfoApi';
import { StockBasicInfoBean } from '../bean/StockBasicInfoBean';
import { WuDangBuySellComponent } from './component/WuDangBuySellComponent';
import { openPage, Path_SearchStockPage } from '../router/RouterManager';

@Entry
@Component
struct StockDetailPage {
  private stockCode: string = router.getParams()?.['stockCode']
  private stockName: string = router.getParams()?.['stockName']
  private stockRequestApi = new RequestStockApi()
  private requestFiveDayMinuteApi = new RequestFiveDayMinuteApi()
  private stockRequestKLineApi = new RequestKLineApi()
  private requestStockBasicInfoApi = new RequestStockBasicInfoApi()
  @State stockData: MinuteData = new MinuteData()
  @State stockBasicInfoBean: StockBasicInfoBean = new StockBasicInfoBean() //股票的基本数据
  @State stockKLineData: KLineData[] = [] //日K数据
  @State stockWKLineData: KLineData[] = [] //周K数据
  @State stockMKLineData: KLineData[] = [] //月K数据
  @State fiveDayData: FiveDayData = null //五日分钟数据
  private controller: TabsController = new TabsController()

  aboutToAppear() {
    if (this.stockCode == null) {
      this.stockCode = '600089'
    }
    console.log('LOG222 StockDetail aboutToAppear' + this.stockCode)
    this.stockRequestApi.requestData(this.stockCode, (value) => {
      if (value != null) {
        this.stockData = value
      }
    })
    this.requestStockBasicInfoApi.requestData(this.stockCode, (value) => {
      if (value == null) {
        return
      }
      this.stockBasicInfoBean = value
      this.stockName = this.stockBasicInfoBean.snap.name
    })
    this.stockRequestKLineApi.getKLineData(this.stockCode, { count: 300, frequency: '1d' }, (value) => {
      this.stockKLineData = value
    })
    this.stockRequestKLineApi.getKLineData(this.stockCode, { count: 48, frequency: '1w' }, (value) => {
      this.stockWKLineData = value
    })
    this.stockRequestKLineApi.getKLineData(this.stockCode, { count: 48, frequency: '1M' }, (value) => {
      this.stockMKLineData = value
    })

    this.requestFiveDayMinuteApi.requestData(this.stockCode, {}, (value) => {
      this.fiveDayData = value
    })
  }

  @State currentIndex: number = 0

  @Builder
  TabBuilder(title: string, index: number) {
    Column() {
      Text(title)
        .fontSize(index == this.currentIndex ? '44px' : '40px')
        .fontColor(index == this.currentIndex ? "#000000" : "#666666")
    }
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = index
      this.controller.changeIndex(index)
    })
  }

  build() {
    Column() {
      RelativeContainer() {
        Image($r('app.media.back'))
          .width(30)
          .height(30)
          .margin(10)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            left: { anchor: '__container__', align: HorizontalAlign.Start }
          })
          .onClick(() => {
            this._finishCurrentPage()
          })
          .id('back')

        Column() {
          if (this.stockBasicInfoBean.snap != undefined) {
            Blank()
            Text(this.stockBasicInfoBean.snap.name)
              .fontColor('#ffffff')
              .textAlign(TextAlign.Center)
              .fontSize(20)
            Text(this.stockBasicInfoBean.code)
              .fontColor('#ffffff')
              .textAlign(TextAlign.Center)
              .fontSize(16)
            Blank()
          }
        }.alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center },
        })
        .id('title1')

        Image($r('app.media.search'))
          .width(20)
          .height(20)
          .margin(20)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            right: { anchor: '__container__', align: HorizontalAlign.End }
          })
          .onClick(() => {
            this._goToSearchStockPage()
          })
          .id('search1')
      }
      .height(60)
      .width('100%')
      .backgroundColor(redColorRGB)

      PanKouComponent({ stockBasicInfoBean: this.stockBasicInfoBean })
        .width('100%')
        .height('11%')
      Tabs({ barPosition: BarPosition.Start, controller: this.controller }) {
        TabContent() {
          Row() {
            MinuteLineComponent({ stockData: this.stockData })
              .width('70%')
              .height('100%')

            if (this.stockBasicInfoBean != undefined
              && this.stockBasicInfoBean.snap != undefined
              && this.stockBasicInfoBean.snap.wuDangData != undefined) {
              WuDangBuySellComponent({ wuDangData: this.stockBasicInfoBean.snap.wuDangData })
                .width('30%')
                .height('100%')
            }

          }.width('100%')
          .height('100%')
        }
        .tabBar(this.TabBuilder("分时", 0))

        TabContent() {
          DayKLineComponent({ kLineSourceData: this.stockKLineData })
            .width('100%')
            .height('100%')
        }
        .tabBar(this.TabBuilder("日K", 1))

        TabContent() {
          DayKLineComponent({ kLineSourceData: this.stockWKLineData })
            .width('100%')
            .height('100%')
        }
        .tabBar(this.TabBuilder("周K", 2))

        TabContent() {
          DayKLineComponent({ kLineSourceData: this.stockMKLineData })
            .width('100%')
            .height('100%')
        }
        .tabBar(this.TabBuilder("月K", 3))

        TabContent() {
          FiveDayMinuteKLineComponent({ fiveDayData: this.fiveDayData })
            .width('100%')
            .height('100%')
        }
        .tabBar(this.TabBuilder("五日", 4))
      }
      .scrollable(false) //先禁掉左右滑动切换TAB
      .barHeight(20)
      .vertical(false)
      .barWidth('100%')
      .barMode(BarMode.Fixed)
      .onChange((index: number) => {
        this.currentIndex = index
      })
      .height("40%")

      Text(this.stockCode)
      Text(this.stockName)
      Button("Back")
        .onClick(() => {
          router.back()
        })
    }
    .align(Alignment.Center)
    .width('100%')
    .height('100%')
    .onAppear(() => {
      console.log('LOG222 StockDetail onAppear')
    }

    )
    .onDisAppear(() => {
      console.log('LOG222 StockDetail onDisAppear')
    })
  }

  _goToSearchStockPage() {
    openPage({ url: Path_SearchStockPage, params: {
      'stockCode': this.stockCode,
      'stockName': this.stockName
    } })
  }

  _finishCurrentPage() {
    router.back()
  }

  onPageShow() {
    console.log('LOG222 StockDetail onPageShow')
  }

  onPageHide() {
    console.log('LOG222 StockDetail onPageHide')
  }

  aboutToDisappear() {
    console.log('LOG222 StockDetail aboutToDisappear')
  }
}
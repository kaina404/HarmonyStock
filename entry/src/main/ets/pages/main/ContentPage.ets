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
import { FinancialComponent } from '../financial/FinancialPage'
import { HomeComponent } from '../home/HomeComponent'
import { NewsComponent } from '../news/NewsPage'
import { QuotesComponent } from '../quotes/QuotesPage'
import { SelfStockComponent } from '../SelfStockComponent'
import { TradeComponent } from '../trade/TradePage'

/**
 * 整个App的容器页面，包含了各个TAB的详细页面。
 * 把所有的Tab内容的Page都放到这里统一管理，
 * 也是App的入口Page显示App内容的Page。
 */
@Entry
@Component
struct ContentPage {
  private controller: TabsController = new TabsController()
  @State message: string = 'Hello World'
  @State currentIndex: number = 0

  /**
   * 使用Builder装饰器创建可复用的组件。
   * https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/arkts-builder-0000001524176981-V3
   * @param title
   * @param index
   */
  @Builder
  TabBuilder(title: string, selectImg: string | PixelMap | Resource, unSelectImg: string | PixelMap | Resource, index: number) {
    Column() {
      Image(index == this.currentIndex ? selectImg : unSelectImg)
        .width('24vp')
        .width('24vp')
      Text(title)
        .fontSize(index == this.currentIndex ? '28px' : '26px')
        .fontColor(index == this.currentIndex ? $r('app.color.main_color') : $r('app.color.default_txt_color'))
    }
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = index
      this.controller.changeIndex(index)
    })
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End, controller: this.controller }) {
        TabContent() {
          HomeComponent()
            .width('100%')
            .height('100%')
        }
        .tabBar(this.TabBuilder("首页", $r('app.media.ic_tab_home_select'), $r('app.media.ic_tab_home_unselect'), 0))

        TabContent() {
          QuotesComponent()
            .width('100%')
            .height('100%')
        }
        .tabBar(this.TabBuilder("行情", $r("app.media.ic_tab_quote_selected"), $r("app.media.ic_tab_quote_unselect"), 1))

        TabContent() {
          SelfStockComponent()
            .width('100%')
            .height('100%')
        }
        .tabBar(this.TabBuilder("自选", $r('app.media.ic_tab_self_selected'), $r('app.media.ic_tab_self_unselect'), 2))

        TabContent() {
          TradeComponent()
            .width('100%')
            .height('100%')
        }
        .tabBar(this.TabBuilder("交易", $r('app.media.ic_tab_trade_select'), $r("app.media.ic_tab_trade_unselect"), 3))

        TabContent() {
          NewsComponent()
            .width('100%')
            .height('100%')
        }
        .tabBar(this.TabBuilder("资讯", $r('app.media.ic_tab_news_select'), $r('app.media.ic_tab_news_unselect'), 4))

        TabContent() {
          FinancialComponent()
            .width('100%')
            .height('100%')
        }
        .tabBar(this.TabBuilder("理财", $r('app.media.ic_tab_fund_select'), $r('app.media.ic_tab_fund_unselect'), 5))
      }
      .onChange((index) => {
        this.currentIndex = index
      })
    }.width('100%')
    .height('100%')
  }
}

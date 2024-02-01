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
 * 首页信息流卡片组件
 * 使用这个卡片的时候，
 * 宽度 -> 屏幕宽度的45%
 *
 * 高度 -> 屏幕高度的20% or 40%
 *
 */
import { Card } from '../HomeFeedBean'
import { CardItemListWidget } from './CardItemListWidget'
import { CardContentBottomTypeWidget } from './CardContentBottomTypeWidget'
import { CardType, CardViewModel } from './CardViewModel'

@Component
export struct FeedCardWidget {
  @Prop card: Card
  private viewModel: CardViewModel = new CardViewModel(this.card)

  build() {
    RelativeContainer() {
      if (this.viewModel.checkData(this.card)) {
        Text(this.card.card_title.value)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            left: { anchor: '__container__', align: HorizontalAlign.Start },
          })
          .fontSize(14)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.black_text'))
          .padding({ top: 10 })
          .margin({ left: 16, right: 16 })
          .id("card_card_title_value")
        if (this.viewModel.getCardType(this.card) === CardType.List) {
          CardItemListWidget({ list: this.viewModel.getCardList() })
            .width('100%')
            .height('100%')
            .alignRules({
              top: { anchor: 'card_card_title_value', align: VerticalAlign.Bottom },
              left: { anchor: '__container__', align: HorizontalAlign.Start },
            })
            .padding({ left: 16, right: 16 })
            .id("CardNormalItemListWidget")
        } else if (this.viewModel.getCardType(this.card) === CardType.CONTENT_FOR_TXT_AND_BOTTOM) {
          CardContentBottomTypeWidget({ modData: this.viewModel.getModData(this.card) })
            .width('100%')
            .height('100%')
            .alignRules({
              top: { anchor: 'card_card_title_value', align: VerticalAlign.Bottom },
              left: { anchor: '__container__', align: HorizontalAlign.Start },
            })
            .padding({ left: 16, right: 16 })
            .id("CardNormalItemListWidget")
        }
      }
    }
    .borderRadius(10)
    .margin(8)
    .backgroundColor(Color.White)
    .width('100%')
    .height('100%')
  }
}
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
import { CardStockTypeWidget } from './CardStockTypeWidget'
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
        } else if (this.viewModel.getCardType(this.card) === CardType.BOTTOM_SHOW_STOCK) {
          CardStockTypeWidget({ modData: this.viewModel.getModData(this.card) })
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
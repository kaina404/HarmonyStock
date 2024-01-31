/**
 * 首页信息流卡片组件
 * 使用这个卡片的时候，
 * 宽度 -> 屏幕宽度的45%
 *
 * 高度 -> 屏幕高度的20%
 *
 */
import { Card, Floor } from '../HomeFeedBean'
import { CardNormalItemListWidget } from './CardNormalItemList'
import { CardType, CardViewModel } from './CardViewModel'

@Component
export struct FeedCardNormalWidget {
  @Prop card: Card
  private viewModel: CardViewModel = new CardViewModel(this.card)

  build() {
    Row() {
      if (this.viewModel.checkData(this.card)) {
        Text(this.card.card_title.value)
          .alignRules({
            top: { anchor: '__container__', align: VerticalAlign.Top },
            left: { anchor: '__container__', align: HorizontalAlign.Start },
          })
          .fontSize(14)
          .fontColor($r('app.color.black_text'))
          .fontWeight(FontWeight.Bold)
          .padding({ top: 10 })
          .margin({ left: 16, right: 16 })
        if (this.viewModel.getCardType(this.card) === CardType.List) {
          CardNormalItemListWidget({ list: this.viewModel.getCardList() })
            .width('100%')
            .height('100%')
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
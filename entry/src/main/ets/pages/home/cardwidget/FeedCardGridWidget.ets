/**
 * https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/arkts-layout-development-create-grid-0000001504486057-V2
 * 用来将卡片的子组件进行排版的容器
 */
import { Card, Floor } from '../HomeFeedBean'

@Component
export struct FeedCardGridWidget {
  @Prop floor: Floor

  build() {
    Column() {
      if (this.floor && this.floor.card_show_list) {
        Grid() {
          ForEach(this.floor.card_show_list, (card: Card, index) => {
            if (card.card_size === 2) {
              GridItem() {
                Column()
                  .backgroundColor(Color.Brown)
                  .borderRadius(10)
                  .width('100%')
                  .height('100%')
              }
              .width('45%')
              .rowStart(1)
              .rowEnd(2)
            } else {
              GridItem() {
                Column()
                  .backgroundColor(Color.Orange)
                  .borderRadius(10)
                  .width('100%')
                  .height('100%')

              }
              .width('45%')
            }
          })
        }
        .rowsTemplate('1fr 1fr')
      }
    }
    .margin(16)
    .width('100%')
    .height('100%')
  }
}
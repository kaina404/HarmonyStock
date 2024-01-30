/**
 * 首页横向滑动的信息流组件
 * 可以横向滑动的多个信息的组件
 */
import { Card, Floor } from './HomeFeedBean';

@Component
export struct HomeHorizontalFeedWidget {
  /**
   * 首页信息流数据源
   */
  @Prop floor: Floor

  build() {
    List() { //https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/arkts-layout-development-create-list-0000001451074018-V2
      //这里水平方向的组件个数不是很多，所以这里会考虑到直接用ForEach，并没有用
      //LazyForEach ，LazyForEach ==》SearchStockPage
      ForEach(this.floor.card_show_list, (item: Card, index) => {
        ListItem() {
          RelativeContainer() { //https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/arkts-layout-development-relative-layout-0000001455042516-V2
            Text(item.card_title.value)
              .alignRules({
                top: { anchor: '__container__', align: VerticalAlign.Top },
                left: { anchor: '__container__', align: HorizontalAlign.Start },
              })
              .fontSize(14)
              .fontColor($r('app.color.black_text'))
              .fontWeight(FontWeight.Bold)
              .padding({ left: 8, top: 10 })
              .id('card_title_text')
          }
          .margin(8)
          .width('45%')
          .height('100%')
          .backgroundColor(Color.White)
          .borderRadius(10)
        }
      })
    }
    .listDirection(Axis.Horizontal)
    .width('100%')
    .height('100%')
  }
}
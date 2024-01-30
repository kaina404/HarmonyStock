/**
 * 首页横向滑动的信息流组件
 * 可以横向滑动的多个信息的组件
 */
import { openPage, openWebViewPage, Path_WebPage } from '../../router/RouterManager';
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
              .padding({ top: 10, left: 10 })
              .id('card_title_text')

            Image($r('app.media.ic_home_right_arrow'))
              .alignRules({
                top: { anchor: '__container__', align: VerticalAlign.Top },
                right: { anchor: '__container__', align: HorizontalAlign.End },
              })
              .width(13)
              .height(13)
              .margin({ right: 10, top: 10 })
              .id('ic_home_right_arrow')

            if (item.cardHttpBean && item.cardHttpBean.content) {
              Text(item.cardHttpBean.content)
                .alignRules({
                  top: { anchor: 'card_title_text', align: VerticalAlign.Bottom },
                  left: { anchor: 'card_title_text', align: HorizontalAlign.Start },
                })
                .margin({ left: 10, top: 15 })
                .fontSize(16)
                .fontColor($r('app.color.black_text'))
                .id('cardHttpBeanContent')
            } else if (item.mod_data && item.mod_data[0] && item.mod_data[0].content) {
              Text(item.mod_data[0].content)
                .alignRules({
                  top: { anchor: 'card_title_text', align: VerticalAlign.Bottom },
                  left: { anchor: 'card_title_text', align: HorizontalAlign.Start },
                })
                .margin({ left: 10, top: 15 })
                .fontSize(16)
                .fontColor($r('app.color.black_text'))
                .id('cardHttpBeanContent')
            }
          }
          .margin(8)
          .width('45%')
          .height('90%')
          .backgroundColor(Color.White)
          .borderRadius(10)
          .onClick((event) => {
            if (item.card_url.android) {
              openWebViewPage(item.card_url.android, item.card_title.value)
            }
          })
        }
      })
    }
    .listDirection(Axis.Horizontal)
    .width('100%')
    .height('100%')
  }
}
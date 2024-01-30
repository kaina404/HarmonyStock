/**
 * 首页横向滑动的信息流组件
 * 可以横向滑动的多个信息的组件
 */
import { defaultColor, greenColor, redColor } from '../../common/Constants';
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
              .padding({ top: 10 })
              .margin({ left: 16, right: 16 })
              .id('card_title_text')

            Image($r('app.media.ic_home_right_arrow'))
              .alignRules({
                top: { anchor: '__container__', align: VerticalAlign.Top },
                right: { anchor: '__container__', align: HorizontalAlign.End },
              })
              .width(13)
              .height(13)
              .margin({ right: 10, top: 10, left: 16 })
              .id('ic_home_right_arrow')
            if (item.stockDataInfo()) {
              Row() {
                if (item.stockDataInfo().stock_name) {
                  Text(item.stockDataInfo().stock_name)
                    .fontSize(15)
                    .margin({ right: 5 })
                    .fontColor($r('app.color.default_txt_color'))
                }
                if (item.stockDataInfo().value) {
                  if (item.stockDataInfo().value.startsWith("-")) {
                    Text(item.stockDataInfo().value)
                      .fontSize(15)
                      .fontColor(greenColor)

                  } else {
                    Text(item.stockDataInfo().value)
                      .fontSize(15)
                      .fontColor(redColor)
                  }
                }

              }
              .alignRules({
                bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
                left: { anchor: '__container__', align: HorizontalAlign.Start },
              })
              .width('100%')
              .height(33)
              .margin({ right: 10, top: 10, left: 16 })
              .id('stockDataInfo')
            }
            if (item.cardHttpBean && item.cardHttpBean.content) {
              Text(item.cardHttpBean.content)
                .alignRules({
                  top: { anchor: 'card_title_text', align: VerticalAlign.Bottom },
                  left: { anchor: 'card_title_text', align: HorizontalAlign.Start },
                })
                .margin({ left: 16, right: 16, top: 10 })
                .fontSize(16)
                .maxLines(3)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .fontColor($r('app.color.black_text'))
                .id('cardHttpBeanContent')
            } else if (item.modDataContentCheck()) {
              Text(item.mod_data[0].content)
                .alignRules({
                  top: { anchor: 'card_title_text', align: VerticalAlign.Bottom },
                  left: { anchor: 'card_title_text', align: HorizontalAlign.Start },
                })
                .maxLines(3)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .margin({ left: 16, right: 16, top: 10 })
                .fontSize(16)
                .fontColor($r('app.color.black_text'))
                .id('cardHttpBeanContent')
            }
            if (item.isModDataTagsCheck()) {
              List() {
                ForEach(item.mod_data[0].tags[0], (itemTag, index) => {
                  ListItem() {
                    if (itemTag.type === "text" && itemTag.value) {
                      Text(itemTag.value)
                        .fontSize(15)
                        .fontColor($r('app.color.default_txt_color'))
                        .margin({ left: 2, right: 2, bottom: 5 })
                    } else if (itemTag.type === "image" && itemTag.value) {
                      Image(itemTag.value)
                        .width(15)
                        .height(15)
                        .margin({ left: 2, right: 2, bottom: 5 })
                    }
                  }
                })
              }
              .margin({ left: 16, right: 16, })
              .alignRules({
                bottom: { anchor: '__container__', align: VerticalAlign.Bottom },
                left: { anchor: '__container__', align: HorizontalAlign.Start },
              })
              .id('tagList')
              .listDirection(Axis.Horizontal)
              .width('100%')
              .height(30)
            }
          }
          .margin(8)
          .width('45%')
          .height('90%')
          .backgroundColor(Color.White)
          .borderRadius(10)
          .onClick((event) => {
            if (item.card_url.android && item.card_url.android.startsWith("http")) {
              openWebViewPage(item.card_url.android, item.card_title.value)
            } else if (item.mod_data && item.mod_data[0] && item.mod_data[0].jump && item.mod_data[0].jump.android) {
              openWebViewPage(item.mod_data[0].jump.android)
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
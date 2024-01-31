import { openPage, Path_WebPage } from '../../router/RouterManager'
import { FeedCardNormalWidget } from './cardwidget/FeedCardNormalWidget'
import { Floor, HomeFeedBean } from './HomeFeedBean'
import { HomeHorizontalFeedWidget } from './HomeHorizontalFeedWidget'
import { HomeTitleSearchWidget } from './HomeTitleSearchWidget'
import { HomeBannerBean, HomeViewModel } from './HomeViewModel'

/**
 * 首页页面的内容
 * Grid ： https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/arkts-layout-development-create-grid-0000001504486057-V3
 */
@Component
export struct HomeComponent {
  @State message: string = 'HomePage'
  @State floorList: Floor[] = []
  @State bannerBeanList: HomeBannerBean[] = []
  private viewModel = new HomeViewModel()

  build() {
    Column() {
      HomeTitleSearchWidget()
        .width('100%')
        .margin({ bottom: 20 })
      Grid() {
        ForEach(this.bannerBeanList, (item: HomeBannerBean, index) => {
          GridItem() {
            Column({ space: 6 }) {
              Image(item.gray_imgurl)
                .width(45)
                .height(45)
              Text(item.title)
                .fontSize(12)
            }
            .onClick((event) => {
              if (item.newjumpurl) {
                if (item.newjumpurl.startsWith("http")) {
                  openPage({
                    url: Path_WebPage,
                    params: {
                      "url": item.newjumpurl
                    }
                  })
                } else {

                }
              }
            })
          }
        })
      }
      .width('100%')
      .height('10%')
      .margin({ left: 16, right: 16 })
      .rowsGap(15)
      .columnsGap(30)
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr')

      if (this.floorList[0] && this.floorList[0].floor_name && this.floorList[0].card_show_list) {
        HomeHorizontalFeedWidget({ floor: this.floorList[0] })
          .width('100%')
          .height('20%')
        FeedCardNormalWidget({ card: this.floorList[1].card_show_list[0] })
          .width('45%')
          .height(this.viewModel.getCardHeight(this.floorList[1].card_show_list[0].card_size))
      }
    }
    .backgroundColor($r('app.color.page_default_color'))
    .height('100%')
  }

  aboutToAppear() {
    this.viewModel.requestHomeBannerConfig((responseList) => {
      this.bannerBeanList = responseList
    })
    this.viewModel.requestFeedData((value: HomeFeedBean) => {
      // const horizontalList = value.data.floor_list.filter((floorData: Floor) => {
      //   return floorData.floor_id === 2186
      // })
      // if (horizontalList) {
      //   this.floorList = value.data.floor_list
      // }
      this.floorList = value.data.floor_list
    })
  }
}
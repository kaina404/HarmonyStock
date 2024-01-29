import { openPage, Path_WebPage } from '../../router/RouterManager'
import { FeedBean, HomeViewModel } from './HomeViewModel'

/**
 * 首页页面的内容
 * Grid ： https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/arkts-layout-development-create-grid-0000001504486057-V3
 */
@Component
export struct HomeComponent {
  @State message: string = 'HomePage'
  @State bannerBeanList: FeedBean[] = []
  private viewModel = new HomeViewModel()

  build() {
    Column({ space: 16 }) {
      Grid() {
        ForEach(this.bannerBeanList, (item: FeedBean, index) => {
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
                openPage({
                  url: Path_WebPage,
                  params: {
                    "url": item.newjumpurl
                  }
                })
              }
            })
          }
        })
      }
      .rowsGap(15)
      .columnsGap(30)
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
    }
    .height('100%')
  }

  aboutToAppear() {
    this.viewModel.requestHomeBannerConfig((responseList) => {
      this.bannerBeanList = responseList
    })
  }
}
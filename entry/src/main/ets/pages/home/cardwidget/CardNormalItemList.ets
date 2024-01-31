import { redColorRGB } from '../../../common/Constants'
import { Card, DataDesc, ModDataListItem } from '../HomeFeedBean'

@Component
export struct CardNormalItemListWidget {
  @Prop list: ModDataListItem[]

  build() {
    Column() {
      if (this.list) {
        List() {
          ForEach(this.list, (item: ModDataListItem, index) => {
            ListItem() {
              Row() {
                if (item.name) {
                  Text(item.name)
                }
                if (item.title) {
                  Row() {
                    Text((index + 1).toString())
                      .fontSize(13)
                      .margin({ right: 7 })
                      .fontColor(redColorRGB)

                    Text(item.title)
                      .maxLines(2)
                      .fontSize(15)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                  }
                  .alignItems(VerticalAlign.Top)
                }
                if (item.data && item.data.stock_code) {
                  Text(item.data.stock_code)
                }
                if (item.data_desc) {
                  List() {
                    ForEach(item.data_desc, (dataDescItem: DataDesc, index) => {
                      ListItem() {
                        if (dataDescItem.value) {
                          Text(dataDescItem.value)
                        }
                      }
                      .width("50")
                      .height('100%')
                    })
                  }
                  .listDirection(Axis.Horizontal)
                  .width('100%')
                  .height(30)
                }
              }
              .width('100%')
              .height('100%')
            }
            .width('100%')
            .height(getHeight(this.list))
          })
        }
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}

function getHeight(data: ModDataListItem[]): Length {
  var height = 100 / data.length * 0.8
  return height.toString() + '%'
}
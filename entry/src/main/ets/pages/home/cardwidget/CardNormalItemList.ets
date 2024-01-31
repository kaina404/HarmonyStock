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
                  Text(item.title)
                }
                if (item.data && item.data.stock_code) {
                  Text(item.data.stock_code)
                }
                // if (item.data_desc) {
                //   List() {
                //     ForEach(item.data_desc, (dataDescItem: DataDesc, index) => {
                //       ListItem() {
                //         if (dataDescItem.value) {
                //           Text(dataDescItem.value)
                //         }
                //       }
                //       .width("50")
                //       .height('100%')
                //     })
                //   }
                //   .listDirection(Axis.Horizontal)
                //   .width('100%')
                //   .height(30)
                // }
              }
              .width('100%')
              .height('100%')
            }
            .width('100%')
            .height(30)
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
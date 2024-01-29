import router from '@ohos.router';
import { openPage, Path_StockDetailPage } from '../router/RouterManager';

//状态驱动UI更新
@Entry
@Component
struct UIUpdateDemo {
  @State isEditModel: boolean = false
  @State clickIndex: number = 0

  aboutToAppear() {
    console.log('LOG222 SelfStockPage aboutToAppear')
  }

  build() {
    Column() {
      Blank(100)
      Row() {
        Text("状态监听与绑定")
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
        Button(this.isEditModel ? "进入编辑模式" : "非编辑模式")
          .onClick(() => {
            // this.isEditModel = !this.isEditModel
            // openPage({ url: Path_HttpPage, params: {
            //   'stockCode': 'https://www.baidu.com'
            // } })
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

      Blank(10)
      ChildWidget({ parentIsEditModel: this.isEditModel, clickIndex: $clickIndex, defaultIndex: 0 })
      ChildWidget({ parentIsEditModel: this.isEditModel, clickIndex: $clickIndex, defaultIndex: 1 })
      ChildWidget({ parentIsEditModel: this.isEditModel, clickIndex: $clickIndex, defaultIndex: 2 })
      Blank(10)
    }.padding(16)
    .onAppear(() => {
      console.log('LOG222 SelfStockPage onAppear')
    })
    .onDisAppear(() => {
      console.log('LOG222 SelfStockPage onDisAppear')
    })
  }

  onPageShow() {
    console.log('LOG222 SelfStockPage onPageShow')
  }

  onPageHide() {
    console.log('LOG222 SelfStockPage onPageHide')
  }

  aboutToDisappear() {
    console.log('LOG222 SelfStockPage aboutToDisappear')
  }
}

@Component
struct ChildWidget {
  @Prop parentIsEditModel: boolean = false
  @Link @Watch('watchIndexChanged') clickIndex: number
  defaultIndex: number = 0
  @State clickIndexTag: number = 0

  watchIndexChanged() {
    this.clickIndexTag = this.clickIndex
  }

  build() {
    Row() {
      Text(this.parentIsEditModel ? "父编辑模式" : "父默认模式")
      Text("ClickIndexTag" + this.clickIndexTag)
      Text(this.defaultIndex == this.clickIndex ? "当前被点击" : "自己没有被点击")
      Checkbox().select(this.parentIsEditModel)
    }.width('100%').justifyContent(FlexAlign.SpaceBetween).onClick(() => {
      this.clickIndex = this.defaultIndex
    })
  }
}
import router from '@ohos.router';

//状态驱动UI更新
@Entry
@Component
struct StateManagerDemo {
  @State isEditModel: boolean = false
  @State clickIndex: number = 0

  build() {
    Column() {
      Blank(100)
      Row() {
        Text("状态监听与绑定")
          .fontSize(20)
          .fontWeight(FontWeight.Medium)
        Button(this.isEditModel ? "进入编辑模式" : "非编辑模式")
          .onClick(() => {
            this.isEditModel = !this.isEditModel
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
import media from '@ohos.multimedia.media'

/**
 * 整个App的容器页面，包含了各个TAB的详细页面。
 * 把所有的Tab内容的Page都放到这里统一管理，
 * 也是App的入口Page显示App内容的Page。
 */
@Entry
@Component
struct ContentPage {
  private controller: TabsController = new TabsController()
  @State message: string = 'Hello World'
  @State currentIndex: number = 0

  /**
   * 使用Builder装饰器创建可复用的组件。
   * https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/arkts-builder-0000001524176981-V3
   * @param title
   * @param index
   */
  @Builder
  TabBuilder(title: string, index: number) {
    Column() {
      Text(title)
        .fontSize(index == this.currentIndex ? '18px' : '16px')
        .fontColor(index == this.currentIndex ? $r('app.color.main_color') : $r('app.color.default_txt_color'))
    }
    .justifyContent(FlexAlign.Center)
    .onClick(() => {
      this.currentIndex = index
      this.controller.changeIndex(index)
    })
  }

  dialogController: CustomDialogController =
    new CustomDialogController({
      builder: DialogTest(),
      alignment: DialogAlignment.Bottom,
    })

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .onClick(() => {
        if (this.dialogController != undefined) {
          this.dialogController.open()
        }
      })
      .width('100%')
    }
    .height('100%')
  }

  aboutToDisappear() {
    this.dialogController = undefined // 将dialogController置空
  }
}


@CustomDialog
struct DialogTest {
  controller: CustomDialogController

  build() {
    Column() {
      TextInput().margin('16vp')
      Column().backgroundColor('#66666').height('90%').width('100%')
    }.width('100%')
    .height('100%')
  }
}

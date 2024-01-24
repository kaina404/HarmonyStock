
/**
 * 整个App的容器页面，包含了各个TAB的详细页面。
 * 把所有的Tab内容的Page都放到这里统一管理，
 * 也是App的入口Page显示App内容的Page。
 */
@Entry
@Component
struct ContentPage {
  @State message: string = 'Hello World'

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .width('100%')
    }
    .height('100%')
  }
}
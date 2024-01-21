import router from '@ohos.router'
import web_webview from '@ohos.web.webview'

@Entry
@Component
struct WebPage {
  @State message: string = 'Hello World'
  controller: web_webview.WebviewController = new web_webview.WebviewController();

  aboutToAppear() {
    console.log("LOG222 build之前 aboutToAppear")
  }

  build() {
    Column() {
      Web({ src: router.getParams()?.['url'], controller: this.controller })
        .fileAccess(false)
        .javaScriptAccess(true)
        .onConfirm((event) => {
          console.log("url:" + event.url + event.message + event.result?.handleConfirm())
          return true
        })
        .width('100%')
      Button("RunJS").onClick(() => {
        this.controller.refresh()
        this.controller.runJavaScript("{ script: 'hello'}")
      })
    }
    .justifyContent(FlexAlign.SpaceBetween)
    .width('100%')
    .height('100%')
    .onAppear(() => {
      console.log('LOG222 组件 onAppear')
    })
    .onDisAppear(() => {
      console.log('LOG222 组件 onDisAppear')
    })
  }

  aboutToDisappear() {
    console.log("LOG222 aboutToDisappear")
  }
}
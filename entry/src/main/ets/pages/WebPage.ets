import router from '@ohos.router'
import web_webview from '@ohos.web.webview'
import { closePage } from '../router/RouterManager';

/**
 * WebView容器： https://developer.harmonyos.com/cn/docs/documentation/doc-references-V3/ts-basic-components-web-0000001477981205-V3
 *
 */
@Entry
@Component
struct WebPage {
  @State title: string = "Title"
  controller: web_webview.WebviewController = new web_webview.WebviewController();

  aboutToAppear() {
    console.log("LOG222 build之前 aboutToAppear")
  }

  build() {
    Column() {
      RelativeContainer() {
        Image($r('app.media.back'))
          .width(20)
          .height(20)
          .margin(20)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            left: { anchor: '__container__', align: HorizontalAlign.Start }
          })
          .onClick(() => {
            if (this.controller.accessBackward()) {
              //点击返回：如果能返回就返回
              this.controller.backward()
            } else {
              //点击返回：如果不能返回就退出页面
              closePage()
            }
          })
          .id('search2')
        Text(this.title)
          .margin(16)
          .maxLines(1)
          .fontWeight(FontWeight.Bold)
          .fontColor(Color.White)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center },
          })
          .id('--webPage--title')
      }
      .backgroundColor($r('app.color.main_color'))
      .width('100%')
      .height(60)
      .flexBasis('auto')

      Web({ src: router.getParams()?.['url'], controller: this.controller })
        .fileAccess(false)
        .javaScriptAccess(true)
        .domStorageAccess(true)
        .onlineImageAccess(true)
        .mixedMode(MixedMode.All)
        .userAgent(generateUserAgent())
        .onConfirm((event) => {
          console.log("url:" + event.url + event.message + event.result?.handleConfirm())
          return true
        })
        .onTitleReceive((event) => {
          this.title = event.title
        })
        .width('100%')
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

export function generateUserAgent(): string {
  return "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.71 Safari/537.36 Edg/94.0.992.38";
}

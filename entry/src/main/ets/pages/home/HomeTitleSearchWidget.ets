/*
 * Copyright (c) 2024 Kaina404 Device Co., Ltd.
 *
 *  https://github.com/kaina404/
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * 首页头部的搜索框组件
 */
@Entry
@Preview
@Component
export struct HomeTitleSearchWidget {
  build() {
    RelativeContainer() {
      //头像按钮
      Image($r('app.media.ic_home_avator'))
        .width(25)
        .height(25)
        .margin(8)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          left: { anchor: '__container__', align: HorizontalAlign.Start }
        })
        .id("--ic_home_avator--")

      //输入框内部文本
      Column() {
        Text("相约韭吧")
          .fontColor(Color.White)
          .fontSize(13)
      }
      .justifyContent(FlexAlign.Center)
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        left: { anchor: '--home_title_scan--', align: HorizontalAlign.Start },
        right: { anchor: '--home_title_robot--', align: HorizontalAlign.Start }
      })
      .height(25)
      .borderRadius(5)
      .backgroundColor($r('app.color.half_translate'))
      .id("--home_title_search_bg--")

      //搜索文本
      Text("搜索")
        .fontColor(Color.White)
        .fontSize(13)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          right: { anchor: '--home_title_search_bg--', align: HorizontalAlign.End },
        })
        .margin({ right: 10 })
        .id("--home_title_search_text--")
      //右侧竖直分割线
      Column()
        .justifyContent(FlexAlign.Center)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          right: { anchor: '--home_title_search_text--', align: HorizontalAlign.Start },
        })
        .height(20)
        .width(1)
        .margin({ right: 5 })
        .backgroundColor($r('app.color.half_translate'))
        .id("--home_title_splint_right--")

      //扫描icon
      Image($r('app.media.ic_scanner'))
        .width(18)
        .height(18)
        .margin(8)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          left: { anchor: '--ic_home_avator--', align: HorizontalAlign.End }
        })
        .id("--home_title_scan--")
      //左侧竖直分割线
      Column()
        .justifyContent(FlexAlign.Center)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          left: { anchor: '--home_title_scan--', align: HorizontalAlign.End },
        })
        .height(20)
        .width(1)
        .backgroundColor($r('app.color.half_translate'))
        .id("--home_title_splint_left--")

      //机器人头像
      Image($r('app.media.robot'))
        .width(20)
        .height(20)
        .margin(8)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          right: { anchor: '--home_title_email--', align: HorizontalAlign.Start }
        })
        .id("--home_title_robot--")
      //消息图片
      Image($r('app.media.email'))
        .width(22)
        .height(22)
        .margin(8)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          right: { anchor: '__container__', align: HorizontalAlign.End }
        })
        .id("--home_title_email--")
    }
    .height('100%')
    .backgroundColor($r('app.color.main_color'))
    .width('100%')
  }
}
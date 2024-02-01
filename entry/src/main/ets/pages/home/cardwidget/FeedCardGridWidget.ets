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
 * https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/arkts-layout-development-create-grid-0000001504486057-V2
 * 用来将卡片的子组件进行排版的容器
 */
import { Card, Floor } from '../HomeFeedBean'
import { FeedCardWidget } from './FeedCardWidget'
/**
 * 根据单个Floor的数据渲染一整个模块UI
 * （模块由3张或者4张小卡片拼接而成）
 * 小卡片的实现为：FeedCardNormalWidget
 */
@Component
export struct FeedCardGridWidget {
  @Prop floor: Floor

  build() {
    Column() {
      if (this.floor) {
        Row() {
          if (this.floor.icon && this.floor.icon.day_pic) {
            Image(this.floor.icon.day_pic)
              .width(13)
              .height(13)
              .margin({ left: 16 })
          }
          if (this.floor.floor_name) {
            Text(this.floor.floor_name)
              .fontSize(14)
              .fontColor($r('app.color.black_text'))
              .fontWeight(FontWeight.Bold)
              .margin({ left: 8, right: 16 })
          }

        }
        .padding({ top: 10 })
        .alignItems(VerticalAlign.Center)
        .height('8%')
        .width('100%')
      }
      if (this.floor && this.floor.card_show_list) {
        Grid() {
          ForEach(this.floor.card_show_list, (card: Card, index) => {
            if (card.card_size === 2) { //纵置,占用两列
              GridItem() {
                FeedCardWidget({ card: card })
                  .width('100%')
                  .height('100%')
              }
              .width('45%')
              .rowStart(1)
              .rowEnd(2)
              .margin(5)
            } else { //纵置单列
              GridItem() {
                FeedCardWidget({ card: card })
                  .width('100%')
                  .height('100%')

              }
              .margin(5)
              .width('45%')
            }
          })
        }
        .height('92%')
        .rowsTemplate('1fr 1fr')
      }
    }
    .justifyContent(FlexAlign.SpaceEvenly)
    .width('100%')
    .height('100%')
  }
}
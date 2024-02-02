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
import { defaultBlackColor, grayColor, redColor } from '../../../common/Constants'
import { KeyValueData } from '../CardResponse'

/**
 * @ProjectName : HarmonyStock
 * @FileName : CardHotPlateWidget
 * @Author : Kaina404
 * @Time : 2024/2/2
 * @Description :热门板块对应的组件
 */
@Component
export struct CardHotPlateWidget {
  @Prop cardUrl: string
  @Prop dataList: KeyValueData[]

  build() {
    Column() {
      if (this.dataList && Array.isArray(this.dataList) && this.dataList.length > 0) {
        Grid() {
          ForEach(this.dataList, (data: KeyValueData, index) => {
            if (index === 5) { //纵置,占用两列
              GridItem() {
                Column() {
                  Text(data.name)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .fontColor(data.color)
                    .fontSize(14)
                  if (data.value) {
                    Text(data.value)
                      .fontColor(data.color)
                      .fontSize(13)
                  }
                }
              }
              .width('50%')
              .height('50%')
              .backgroundColor(getAlphaColor(data.value))
              .rowStart(7)
              .rowEnd(8)
              .margin(0.5)
            } else if (index === 0) { //纵置,占用两列
              GridItem() {
                Column() {
                  Text(data.name)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .fontColor(data.color)
                    .fontSize(14)
                  if (data.value) {
                    Text(data.value)
                      .fontColor(data.color)
                      .fontSize(13)
                  }
                }
              }
              .backgroundColor(getAlphaColor(data.value))
              .rowStart(1)
              .width('50%')
              .height('50%')
              .rowEnd(2)
              .margin(0.5)
            } else { //纵置单列
              GridItem() {
                Column() {
                  Text(data.name)
                    .maxLines(1)
                    .textOverflow({ overflow: TextOverflow.Ellipsis })
                    .fontColor(data.color)
                    .fontSize(14)
                  if (data.value) {
                    Text(data.value)
                      .fontColor(data.color)
                      .fontSize(13)
                  }
                }
              }
              .width('50%')
              .height('25%')
              .margin(0.5)
              .backgroundColor(getAlphaColor(data.value))
            }
          })
        }
        .height('100%')
        .width('100%')
        .borderRadius(10)
        .rowsTemplate('1fr 1fr 1fr 1fr')
      }
    }
    .width('100%')
    .height('100%')
  }
}


function getAlphaColor(value: string | undefined): string {
  if (value) {
    if (value.startsWith("-")) {
      return "#33228B22"
    } else {
      return "#33e2233e"
    }
  }
  return "#ffffff"
}
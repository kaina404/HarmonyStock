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
import { defaultBlackColor, grayColor } from '../../../common/Constants'
import Logger from '../../../common/Logger'
import { openPage, openWebViewPage } from '../../../router/RouterManager'
import { ModDataBean } from '../CardResponse'
import { CardViewModel } from './CardViewModel'

/**
 * @ProjectName : HarmonyStock
 * @FileName : CardContentBottomTypeWidget
 * @Author : Kaina404
 * @Time : 2024/2/1
 * @Description :中间显示内容，底部显示子标题
 */

/**
 * 中间显示内容，底部显示子标题
 */
@Component
export struct CardContentBottomTypeWidget {
  @Prop modData: ModDataBean
  private viewModel = new CardViewModel(null)

  build() {
    Column() {
      if (this.modData) {
        if (typeof this.modData.content === 'string') {
          Text(this.modData.content)
            .maxLines(2)
            .fontSize(16)
            .fontColor(defaultBlackColor)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }
        if (this.viewModel.hasTagsContentValue(this.modData)) {
          Text(this.viewModel.hasTagsContentValue(this.modData))
            .maxLines(2)
            .fontSize(14)
            .fontColor(grayColor)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
        }

      }
    }
    .onClick(() => {
      try {
        if (this.modData && this.modData.jump) {
          if (this.modData.jump.android.startsWith("http")) {
            openWebViewPage(this.modData.jump.android)
          }
        } else if (this.modData && this.viewModel.getShowTags(this.modData)) {
          const keyValue = this.viewModel.getShowTags(this.modData)
          if (keyValue.jump && keyValue.jump.android.startsWith("http")) {
            const url = keyValue.jump.android
            if (url.startsWith("http")) {
              openWebViewPage(url)
            } else {
              const match = url.match(/url=([^&]+)/)
              if (match && match.length > 1) {
                const url = match[1];
                openWebViewPage(url)
              }
            }
          }
        }
      } catch (e) {
        Logger.error(e.message)
      }
    })
    .margin({ top: 5 })
    .alignItems(HorizontalAlign.Start)
    .width('100%')
    .height('100%')
  }
}
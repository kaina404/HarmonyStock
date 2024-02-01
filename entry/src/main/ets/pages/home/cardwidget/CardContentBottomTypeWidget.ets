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
import { ModDataBean } from '../CardResponse'

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

  build() {
    Column() {
      if (this.modData) {
        if (typeof this.modData.content === 'string') {
          Text(this.modData.content)
        }

      }
    }
    .width('100%')
    .height('100%')
  }
}
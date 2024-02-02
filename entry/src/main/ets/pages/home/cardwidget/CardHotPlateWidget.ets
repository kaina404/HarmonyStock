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
    if (this.dataList && Array.isArray(this.dataList) && this.dataList.length > 0) {

    }
  }
}
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
 * @ProjectName : HarmonyStock
 * @FileName : CardResponse
 * @Author : Kaina404
 * @Time : 2024/2/1
 * @Description :
 */
export class CardResponse {
  code: number
  msg: string
  trace_id: string
  data: CardData
}

export class CardData {
  strategy_id: number
  version: number
  channel: string
  floor_list: FloorData[]
}

export class FloorData {
  floor_id: number
  version: string
  floor_name: string
  floor_key: string
  show_title: boolean
  icon: IconData
  card_show_list: CardItemData[]
  card_hidden_list: CardItemData[]
}

export class IconData {
  day_pic: string
  night_pic: string
}

export class CardItemData {
  card_id: number
  card_version: number
  card_key: string
  function_id: string
  render_key: string
  card_template: string
  card_size: number
  card_title: KeyValueData
  card_url: JumpData
  mod_data: ModDataBean[]
  data_completed: boolean
  card_polling: boolean

  hasKeyValueData(): KeyValueData | null {
    try {
      if (this.mod_data[0].list[0].stock_name) {
        return this.mod_data[0].list[0]
      }
    } catch (e) {
    }
    return null;
  }

  hasTags(): KeyValueData[] | null {
    try {
      return this.mod_data[0].tags[0]
    } catch (e) {
    }
    return null;
  }
}

export class ModDataBean {
  image: ImageDataBean
  url: string
  type: string
  jump: JumpData
  param_list: string[]
  url_v2: string
  param_desc: string
  req_desc: string
  biz_name: string
  num_content: number
  title: ColorTxtBean[]
  header: ColorTxtBean[]
  sub_content: ColorTxtBean[]
  content: string | ColorTxtBean
  tags: KeyValueData[][]
  list: KeyValueData[]
  prefix: KeyValueData
}

export class ImageDataBean {
  night_image: string
  day_image: string
  position: string
  type: string
}

export class KeyValueData {
  title: string
  has_hot: boolean
  jump: JumpData
  value: string
  type: string
  market: string
  name: string
  fund: string
  stock_code: string
  stock_name: string
  prefix: KeyValueData
  data: KeyValueData
  data_desc: ColorTxtBean[]
}

export class JumpData {
  ios: string
  android: string
}

export class ColorTxtBean {
  color: string
  background: string
  type: string
  value: string
}

export class MobDataApiResponse {
  status_code: number
  status_msg: string
  data: ModDataResponseBean
}

export class ModDataResponseBean {
  list: ModDataBean[]
}

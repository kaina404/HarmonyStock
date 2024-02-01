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
import { MinuteItemData } from './MinuteItemData'

export class MinuteData {
  code: string
  lineLowest: number = null
  lineHighest: number = null
  prev_close: number
  highest: number
  lowest: number
  date: number
  time: number
  total: number
  begin: number
  end: number
  lastNewPrice: number//昨收价格
  line: Array<MinuteItemData> = []//存储分时信息
  maxDistancePrice: number//最高价格
  maxChengJiaoLiang: number = 0
  minChengJiaoLiang: number = 0

  public parseJson(data: string): MinuteData {
    let obj = JSON.parse(data)
    let bean = new MinuteData()
    this.begin = obj.begin
    this.code = obj.code
    this.date = obj.date
    this.end = obj.end
    this.highest = obj.highest
    return bean
  }
}



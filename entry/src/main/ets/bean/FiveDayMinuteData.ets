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
//五日某一个天的某一分钟线的数据
export class FiveDayItemMinuteData {
  day: Date//五日的年月日时分
  open: number
  high: number
  low: number
  close: number
  volume: number
  ma_price5: number
  ma_volume5: number

  constructor(day: Date,
              open: number,
              high: number,
              low: number,
              close: number,
              volume: number,
              ma_price5: number,
              ma_volume5: number) {
    this.day = day
    this.open = open
    this.high = high
    this.low = low
    this.close = close
    this.volume = volume
    this.ma_price5 = ma_price5
    this.ma_volume5 = ma_volume5
  }
}

//五日的莫一天的所有数据的集合
export class FiveDayMinuteDataWrapper {
  date: Date//五日的年月日
  fiveDayMinuteDataAry: FiveDayItemMinuteData[]
  maxPrice: number //该天的所有价格的最大值（fiveDayMinuteDataAry的价格最大值）
  minPrice: number //该天的所有价格的最小值（fiveDayMinuteDataAry的价格最小值）
  openPrice: number //该天的第一个价格（fiveDayMinuteDataAry的第一分钟的价格）
}

export class FiveDayData {
  fiveDayMinuteDataWrapper: FiveDayMinuteDataWrapper[] //五日分钟线的数据
  allDataMaxPrice:number
  allDataMinPrice:number
}
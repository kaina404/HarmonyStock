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
export class KLineData {
  time: number
  open: number
  close: number
  high: number
  low: number
  volume: number
  centerX: number = 0//当前数据所在的X轴位置


  constructor(time?: number, open?: number, close?: number, high?: number, low?: number, volume?: number) {
    this.time = time
    this.open = open
    this.close = close
    this.high = high
    this.low = low
    this.volume = volume
  }
}

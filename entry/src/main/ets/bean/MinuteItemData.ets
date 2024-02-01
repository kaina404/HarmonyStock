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
export class MinuteItemData {
  time: number
  price: number
  chengJiaoLiang: number
  junjia: number
  chengjiaoe: number
  undefine1: number
  undefine2: number
  lineX: number = null //所处绘制的X轴位置
  zhangFuValue:number//涨幅对应的值，相对昨收
  zhangFuPercent:string//涨幅对应的百分比例
}
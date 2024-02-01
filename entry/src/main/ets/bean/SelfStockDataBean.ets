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
import { StockBasicInfoBean } from './StockBasicInfoBean';
import StockDBData from './StockDBData';

/**
 * 自选股页面所用的Bean
 */
export class SelfStockDataBean extends StockDBData {
  isAddToDB: boolean = false
  baseInfo: StockBasicInfoBean = new StockBasicInfoBean()

  uniqueListKey(): string {
    return this.code + this.name + this.market + this.isAddToDB + this.sortIndex.toString() + this.baseInfo.time.toString()
  }
}
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
export const redColor = '#e2233e'

export const redColorRGB = 'rgb(206,79,70)'

export const defaultColor = '#fcfcfc'

export const defaultBlackColor = '#000000'

export const greenColor = '#228B22'

import relationalStore from '@ohos.data.relationalStore';

export default class CommonConstants {
  /**
   * Rdb database config.
   */
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'database.db',
    securityLevel: relationalStore.SecurityLevel.S1
  };
  /**
   * SelfStock table config.
   */
  static readonly SELF_STOCK_TABLE = {
    tableName: 'selfStockTable',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS selfStockTable(id INTEGER PRIMARY KEY AUTOINCREMENT, code TEXT, name TEXT, market TEXT, date TEXT, last TEXT, sortIndex TEXT)',
    columns: ['id', 'code', 'name', 'market', 'date','last', 'sortIndex']
  };
  /**
   * Log tag.
   */
  static readonly RDB_TAG = '[Debug.Rdb]';
  static readonly TABLE_TAG = '[Debug.AccountTable]';
  static readonly INDEX_TAG = '[Debug.Index]';
}
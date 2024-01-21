export const redColor = '#e2233e'

export const redColorRGB = 'rgb(206,79,70)'

export const defaultColor = '#fcfcfc'

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
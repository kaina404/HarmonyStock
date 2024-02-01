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
import relationalStore from '@ohos.data.relationalStore';
import StockDBData from '../../bean/StockDBData';
import CommonConstants from '../../common/Constants';
import { Rdb } from '../AppRdb';

export default class SelfStockTable {
  private selfStockTable = new Rdb(CommonConstants.SELF_STOCK_TABLE.tableName, CommonConstants.SELF_STOCK_TABLE.sqlCreate,
    CommonConstants.SELF_STOCK_TABLE.columns);

  constructor(callback: Function = () => {
  }) {
    this.selfStockTable.getRdbStore(callback);
  }

  getRdbStore(callback: Function = () => {
  }) {
    this.selfStockTable.getRdbStore(callback);
  }

  insertData(stockDBData: StockDBData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(stockDBData);
    this.selfStockTable.insertData(valueBucket, callback);
  }

  // deleteDataByID(id: number, callback: Function) {
  //   if (id === undefined || id < 0) {
  //     return
  //   }
  //   let predicates = new relationalStore.RdbPredicates(CommonConstants.SELF_STOCK_TABLE.tableName);
  //   predicates.equalTo('id', id);
  //   this.selfStockTable.deleteData(predicates, callback);
  // }

  deleteDataByCode(code: string, callback: Function) {
    if (code === undefined || code.length <= 0) {
      return
    }
    let predicates = new relationalStore.RdbPredicates(CommonConstants.SELF_STOCK_TABLE.tableName);
    predicates.equalTo('code', code);
    this.selfStockTable.deleteData(predicates, callback);
  }

  updateData(stockDBData: StockDBData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = generateBucket(stockDBData);
    let predicates = new relationalStore.RdbPredicates(CommonConstants.SELF_STOCK_TABLE.tableName);
    predicates.equalTo('code', stockDBData.code);
    this.selfStockTable.updateData(predicates, valueBucket, callback);
  }

  query(code: string, callback: Function, isAll: boolean = true) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.SELF_STOCK_TABLE.tableName);
    if (!isAll) {
      predicates.equalTo('code', code);
    }
    this.selfStockTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0 || typeof count === 'string') {
        console.log(`${CommonConstants.TABLE_TAG}` + 'Query no results!');
        callback([]);
      } else {
        resultSet.goToFirstRow();
        const result: StockDBData[] = [];
        for (let i = 0; i < count; i++) {
          let tmp: StockDBData = {
            id: 0,
            code: '',
            name: '',
            market: '',
            date: '',
            last: '',
            sortIndex: 0
          };
          tmp.id = resultSet.getDouble(resultSet.getColumnIndex('id'));
          tmp.code = resultSet.getString(resultSet.getColumnIndex('code'));
          tmp.name = resultSet.getString(resultSet.getColumnIndex('name'));
          tmp.market = resultSet.getString(resultSet.getColumnIndex('market'));
          tmp.date = resultSet.getString(resultSet.getColumnIndex('date'));
          tmp.last = resultSet.getString(resultSet.getColumnIndex('last'));
          tmp.sortIndex = resultSet.getDouble(resultSet.getColumnIndex('sortIndex'));
          result[i] = tmp;
          resultSet.goToNextRow();
        }
        callback(result);
      }
    });
  }
}

function generateBucket(stockDBData: StockDBData): relationalStore.ValuesBucket {
  let obj: relationalStore.ValuesBucket = {};
  obj.code = stockDBData.code;
  obj.name = stockDBData.name;
  obj.market = stockDBData.market;
  obj.date = stockDBData.date;
  obj.last = stockDBData.last;
  obj.sortIndex = stockDBData.sortIndex;
  return obj;
}
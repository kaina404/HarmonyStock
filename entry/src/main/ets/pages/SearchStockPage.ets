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
import common from '@ohos.app.ability.common'
import StockDBData from '../bean/StockDBData'
import { Rdb } from '../db/AppRdb'
import SelfStockTable from '../db/tables/SelfStockTable'

import { SearchStockDataSource } from '../idatasource/SearchStockDataSource'
import { SearchStockApi, SearchStockBean, SearchStockResponse } from '../network/SearchStockApi'
import { closePage, openPage, Path_StockDetailPage } from '../router/RouterManager'
import { Event_Refresh_SelfStockList } from '../viewmodel/EventHubConstant'

/**
 * 搜索股票页面
 * 核心组件-> LazyForEach ：
 * [LazyForEach](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/arkts-rendering-control-lazyforeach-0000001524417213-V2)
 */
@Entry
@Component
struct SearchStockPage {
  private controller: SearchController = new SearchController()
  private searchStockApi = new SearchStockApi()
  private dataSource = new SearchStockDataSource()
  private needRefreshSelfList = false //用来标记是否需要刷新自选股页面的列表
  /**
   * 自选股数据库
   */
  private selfStockTable = new SelfStockTable(() => {
  });
  /**
   数据库中存在的股票
   */
  @State dbStockList: Array<StockDBData> = [];

  aboutToAppear() {
    //初始化数据库
    this.selfStockTable.getRdbStore(() => {
      this.selfStockTable.query('', (result: StockDBData[]) => {
        this.dbStockList = result;
      }, true);
    });
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
        Image($r('app.media.ic_gray_back'))
          .width(30)
          .height(30)
          .flexBasis('auto')
          .margin(10)
          .onClick(() => {
            closePage()
          })
        Search({ placeholder: '搜索股票', controller: this.controller })
          .searchButton('搜索')
          .onSubmit((value: string) => {
            this._searchStock(value)
          })
      }
      .flexBasis('auto')

      List({ space: 10 }) {
        LazyForEach(this.dataSource, (item: SearchStockBean) => {
          ListItem() {
            Row() {
              Column() {
                Text(item.name).fontSize(16)
                Text(item.code).fontSize(14)
              }

              if (item.isAddToDB) {
                Image($r('app.media.ic_stock_remove'))
                  .width(30)
                  .height(30)
                  .onClick(() => {
                    this._removeSelfStock(item)
                  })
              } else {
                Image($r('app.media.ic_red_add'))
                  .width(30)
                  .height(30)
                  .onClick(() => {
                    this._addItem2SelfStock(item)
                  })
              }
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .onClick(() => {
              this._go2StockDetail(item)
            })
            .width('100%')
          }
        }, (item: SearchStockBean) => item.uniqueListKey()) //这里需要定制唯一的key
      }
      .cachedCount(5)
      .divider({
        strokeWidth: 1,
        startMargin: 0,
        endMargin: 10,
        color: '#ffe9f0f0'
      })
      .padding('16vp')
      .width('100%')
      .height('100%')
    }
  }

  /**
   * 点击搜索的个股条目跳转到股票详情页面
   * @param bean
   */
  _go2StockDetail(bean: SearchStockBean) {
    openPage({ url: Path_StockDetailPage, params: {
      'stockCode': bean.code,
      'stockName': bean.name
    } })
  }

  /**
   * 从自选股数据库中删除自选股
   * @param bean
   */
  _removeSelfStock(bean: SearchStockBean) {
    this.needRefreshSelfList = true
    this.selfStockTable.deleteDataByCode(bean.code, (result) => {
      console.log("删除自选股结果:" + result)
      if (result > 0) {
        this.dataSource.getAllData().forEach((item: SearchStockBean, index) => {
          if (item.code == bean.code) {
            item.isAddToDB = false
            this.dataSource.changeData(index, item)
          }
        })
        this.selfStockTable.query('', (result: StockDBData[]) => {
          this.dbStockList = result;
        }, true);
      }
    })
  }

  /**
   * 添加股票到自选股数据库
   * @param bean
   */
  _addItem2SelfStock(bean: SearchStockBean) {
    this.needRefreshSelfList = true
    let dbData: StockDBData = {
      id: 0,
      code: bean.code,
      name: bean.name,
      market: '',
      date: new Date().toUTCString(),
      last: bean.last.toString(),
      sortIndex: new Date().valueOf()
    }
    this.selfStockTable.insertData(dbData, (result) => {
      console.log("添加数据到自选股结果:" + result)
      if (result > 0) {
        this.dataSource.getAllData().forEach((item: SearchStockBean, index) => {
          if (item.code == dbData.code) {
            item.isAddToDB = true
            this.dataSource.changeData(index, item)
          }
        })
        this.selfStockTable.query('', (result: StockDBData[]) => {
          this.dbStockList = result;
        }, true);
      }
    })
  }

  _searchStock(value: string) {
    this.searchStockApi.requestData(value, (value: SearchStockResponse) => {
      let list: SearchStockBean[] = value.top50StockList
      list.forEach((item: SearchStockBean) => {
        this.dbStockList.forEach((dbStockItem: StockDBData) => {
          if (dbStockItem.code == item.code) {
            item.isAddToDB = true
            return
          }
        })
      })
      this.dataSource.notifyData(list)
    })
  }

  private context = getContext(this) as common.UIAbilityContext;

  aboutToDisappear() {
    if (this.needRefreshSelfList) {
      this.context.eventHub.emit(Event_Refresh_SelfStockList);
    }
  }
}
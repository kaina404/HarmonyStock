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
import common from '@ohos.app.ability.common';
import { SelfStockDataBean } from '../bean/SelfStockDataBean';
import { StockBasicInfoBean } from '../bean/StockBasicInfoBean';
import StockDBData from '../bean/StockDBData';
import { getPriceColor } from '../common/CommonUtils';
import { greenColor, redColorRGB } from '../common/Constants';
import SelfStockTable from '../db/tables/SelfStockTable';
import { SelfStockDataSource } from '../idatasource/SelfStockDataSource';
import { RequestStockBasicInfoApi } from '../network/RequestStockBasicInfoApi';
import { openPage, Path_SearchStockPage, Path_StockDetailPage } from '../router/RouterManager';
import { Event_Refresh_SelfStockList } from '../viewmodel/EventHubConstant';

/**
 * LazyForEach:数据懒加载
 * https://developer.harmonyos.com/cn/docs/documentation/doc-guides-V3/arkts-rendering-control-lazyforeach-0000001524417213-V3
 * 自选股列表页面
 * 添加到自选股数据库中的页面均在这里显示
 * 支持：置顶股票、置底股票、删除股票。
 */
@Component
export struct SelfStockComponent {
  private context = getContext(this) as common.UIAbilityContext;
  /**
   * 自选股数据库
   */
  private selfStockTable = new SelfStockTable(() => {
  });
  private dataSource = new SelfStockDataSource()
  private requestStockBasicInfoApi = new RequestStockBasicInfoApi()
  // https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/arkts-popup-and-menu-components-popup-0000001500753909-V2
  /**
   * 长按弹出操作自选股 删除、置顶、置底等逻辑
   */
  @State showSelfStockPopupCode: string = ''

  // popup构造器定义弹框内容
  @Builder
  popupBuilder() {
    Row({ space: 2 }) {
      Text('删除').fontSize(14).fontWeight(900).fontColor(Color.White).onClick((event) => {
        this._deleteStockFromDB(this.showSelfStockPopupCode)
        this.showSelfStockPopupCode = ''
      })
      Divider().vertical(true).color($r('app.color.split_line_color'))
      Text('置顶').fontSize(14).fontWeight(900).fontColor(Color.White).onClick((event) => {
        this._moveTopStockFromDB(this.showSelfStockPopupCode)
        this.showSelfStockPopupCode = ''
      })
      Divider().vertical(true).color($r('app.color.split_line_color'))
      Text('置底').fontSize(14).fontWeight(900).fontColor(Color.White).onClick((event) => {
        this._moveBottomStockFromDB(this.showSelfStockPopupCode)
        this.showSelfStockPopupCode = ''
      })
    }.width(230).height(40).padding(5).justifyContent(FlexAlign.SpaceAround)
  }

  aboutToAppear() {
    //注册监听刷新自选列表事件
    let eventhub = this.context.eventHub
    eventhub.on(Event_Refresh_SelfStockList, (...data) => {
      this.refresh()
    })
    this.refresh()
  }

  aboutToDisappear() {
    this.context.eventHub.off(Event_Refresh_SelfStockList)
  }

  refresh() {
    //初始化数据库
    this.selfStockTable.getRdbStore(() => {
      this.selfStockTable.query('', (result: StockDBData[]) => {
        const tmpBeanList: SelfStockDataBean[] = [];

        for (const item of result) {
          const bean = new SelfStockDataBean();
          bean.isAddToDB = true;
          bean.code = item.code;
          bean.name = item.name;
          bean.market = item.market;
          bean.date = item.date;
          bean.last = item.last;
          bean.sortIndex = item.sortIndex;
          tmpBeanList.push(bean);
        }
        const beanList = tmpBeanList.sort(selfStockSort)
        this.dataSource.notifyData(beanList);
        const codeList = beanList.map(item => item.code);
        //查询一组股票的基础行情信息
        this.requestStockBasicInfoApi.queryStockListBaseInfo(codeList, (valueMap: Map<string, StockBasicInfoBean>) => {
          if (valueMap && valueMap.size > 0) {
            this.dataSource.getAllData().forEach((item) => {
              const baseInfo = valueMap.get(item.code);
              if (baseInfo) {
                item.baseInfo = baseInfo;
                this.dataSource.notifyItemData(item)
              }
            });
          }
        });
      });

    })
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      RelativeContainer() {
        Text('HarmonyStock')
          .fontColor('#ffffff')
          .textAlign(TextAlign.Center)
          .fontSize(22)
          .fontWeight(600)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center },
          })
          .id('title2')

        Image($r('app.media.search'))
          .width(20)
          .height(20)
          .margin(20)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            right: { anchor: '__container__', align: HorizontalAlign.End }
          })
          .onClick(() => {
            openPage({ url: Path_SearchStockPage })
          })
          .id('search2')
      }
      .height(60)
      .width('100%')
      .backgroundColor(redColorRGB)
      .flexBasis('auto')

      Row() {
        Text('股票名称')
          .fontColor($r('app.color.default_txt_color'))
          .fontSize(16)
        Text('最新价')
          .fontColor($r('app.color.default_txt_color'))
          .fontSize(16)
        Text('涨幅')
          .fontColor($r('app.color.default_txt_color'))
          .fontSize(16)
        Text('涨跌')
          .fontColor($r('app.color.default_txt_color'))
          .fontSize(16)
      }
      .width('100%')
      .padding({ right: 16, left: 16 })
      .height(40)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

      List({ space: 10 }) {
        LazyForEach(this.dataSource, (item: SelfStockDataBean) => {
          ListItem() {
            Row() {
              Column() {
                Text(item.name).fontSize(18)
                Text(item.code).fontSize(12)
              }

              if (item.baseInfo && item.baseInfo.snap) {
                //最新价
                Text(item.baseInfo.snap.last.toString())
                  .fontColor(getPriceColor(item.baseInfo.snap.last, item.baseInfo.snap.open))
                  .fontWeight(600)
                  .fontSize(18)
                //涨幅
                Text(item.baseInfo.snap.chg_rate.toFixed(2) + '%')
                  .fontColor(getPriceColor(item.baseInfo.snap.last, item.baseInfo.snap.open))
                  .fontWeight(600)
                  .fontSize(18)
                //涨跌
                Text(item.baseInfo.snap.change.toString())
                  .fontColor(getPriceColor(item.baseInfo.snap.last, item.baseInfo.snap.open))
                  .fontWeight(600)
                  .fontSize(18)
              }
            }
            .justifyContent(FlexAlign.SpaceBetween)
            .gesture(GestureGroup(
              GestureMode.Exclusive,
              //监听点击手势识别
              TapGesture().onAction((event) => {
                openPage({ url: Path_StockDetailPage, params: {
                  'stockCode': item.code,
                  'stockName': item.name
                } })
              }),
              //监听长按手势识别,长按后弹出气泡让用户来支持删除自选股。
              //https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V2/arkts-popup-and-menu-components-popup-0000001500753909-V2
              LongPressGesture().onAction((event) => {
                this.showSelfStockPopupCode = item.code
              })
            ))
            .bindPopup(this.showSelfStockPopupCode == item.code, {
              builder: this.popupBuilder,
            })
            .width('100%')
          }
        }, (item: SelfStockDataBean) => item.uniqueListKey()) //△****这里需要定制唯一的key△****
      }
      .cachedCount(5)
      .divider({
        strokeWidth: 1,
        startMargin: 0,
        endMargin: 10,
        color: '#ffe9f0f0'
      })
      .padding('16vp')
      .height('100%')
      .width('100%')

    }
    .width('100%')
    .height('100%')
  }

  /**
   * 从自选列表中删除自选股票
   * @param code
   */
  _deleteStockFromDB(code: string) {
    this.selfStockTable.deleteDataByCode(code, (result) => {
      if (result > 0) {
        console.log("删除自选成功")
        this.dataSource.notifyItemDataDelete(code)
      }
    })
  }

  /**
   * 将股票移动到自选股的顶部
   * @param code
   */
  _moveTopStockFromDB(code: string) {
    this.selfStockTable.query(code, (value: StockDBData[]) => {
      value.forEach((valueItem) => {
        this.dataSource.getAllData().forEach((item: SelfStockDataBean, index) => {
          if (item.code == valueItem.code) {
            valueItem.sortIndex = new Date().valueOf()
            this.dataSource.notifyDataMove(index, 0)
            this.selfStockTable.updateData(valueItem, (result) => {
              console.log("将股票移动到自选股的顶部更新数据结果：" + result)
            })
          }
        })
      })
    }, false)
  }

  /**
   * 将股票移动到自选股的底部
   * @param code
   */
  _moveBottomStockFromDB(code: string) {
    this.selfStockTable.query(code, (value: StockDBData[]) => {
      value.forEach((valueItem) => {
        this.dataSource.getAllData().forEach((item: SelfStockDataBean, index) => {
          if (item.code == valueItem.code) {
            valueItem.sortIndex = new Date().valueOf() * -1
            this.dataSource.notifyDataMove(index, this.dataSource.getAllData().length - 1)
            this.selfStockTable.updateData(valueItem, (result) => {
              console.log("将股票移动到自选股的底部更新数据结果：" + result)
            })
          }
        })
      })
    }, false)
  }
}

const selfStockSort = (a: SelfStockDataBean, b: SelfStockDataBean) => b.sortIndex - a.sortIndex
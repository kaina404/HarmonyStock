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
import { StockBasicInfoBean } from '../../bean/StockBasicInfoBean';
import { getRawFileJSON, getRawFileJSONString } from '../../common/CommonUtils';
import { greenColor, redColor, redColorRGB } from '../../common/Constants';
import Logger from '../../common/Logger';
import { sendHttpRequest } from '../../network/BaseHttpApi';
import { Callback } from '../../network/RequestStockApi';
import { RequestStockBasicInfoApi } from '../../network/RequestStockBasicInfoApi';
import {
  CardData,
  CardItemData,
  CardResponse,
  FloorData,
  KeyValueData,
  MobDataApiResponse,
  ModDataBean
} from './CardResponse';

export class HomeViewModel {
  getCardHeight(cardSize: number): Length {
    if (cardSize === 2) {
      return '40%'
    } else if (cardSize === 3) {
      return '20%'
    }
    return '20%'
  }

  //查询首页配置的信息流数据
  requestFeedData(callBack: Callback<CardResponse>) {
    //加载首页的信息流数据，从HTTP
    // const url = "https://eq.10jqka.com.cn/eqadmin/tmp/indexFeed/iphone2.txt"
    const url = "https://eq.10jqka.com.cn/eq/open/api/homepage_v2/v3/old_user?platform=iphone&version=I037.08.488&is_reflow=0"
    // sendHttpRequest(url).then((data => {
    //   // const jsonData = JSON.parse(data.result as string)
    //   this.parseJSONString((data.result as string), callBack)
    // }))
    //加载首页的信息流，从本地json文件
    getRawFileJSONString("home_config.json", (((jsonDataString: string) => {
      this.parseJSONString(jsonDataString, callBack)
    })), this)
  }

  parseJSONString(jsonDataString, callBack) {
    let jsonResult: CardResponse = JSON.parse(jsonDataString)
    // 过滤 floor_list 中 floor_name 或 version 为 null 的数据
    const filteredFloorList = jsonResult.data.floor_list.filter((floorData: FloorData) => {
      return floorData.floor_name !== null && floorData.version !== null;
    });
    jsonResult.data.floor_list = filteredFloorList
    callBack(jsonResult)
    this.processAsyncRequests(callBack, jsonResult)
  }

  /**
   * 部分数据的填充，如果  modData.req_desc == "HTTP_GET"  ，则需要填充内部的httpResponse数据。
   * @param callBack
   * @param jsonBean
   */
  async processAsyncRequests(callBack, jsonBean) {
    const floorListFor: FloorData[] = jsonBean.data.floor_list
    for (const floor of floorListFor) {
      for (const tmpCard of floor.card_show_list) {
        const card: CardItemData = tmpCard
        for (const tmpModData of card.mod_data) {
          const modData: ModDataBean = tmpModData
          if (modData.url_v2 && modData.req_desc === "HTTP_GET") {
            const response = await sendHttpRequest(modData.url_v2)
            const parsedData: MobDataApiResponse = JSON.parse(response.result as string);
            if (parsedData && parsedData.data) {
              try {
                card.mod_data = parsedData.data.list
              } catch (e) {
                Logger.error("Error")
              }
              try {
                if (Array.isArray(card.mod_data)
                  && Array.isArray(card.mod_data[0].tags)
                  && Array.isArray(card.mod_data[0].tags[0])) {
                  const tags: KeyValueData[] = card.mod_data[0].tags[0]
                  const newTags = await this.requestStockDetailByTags(tags)
                  // const filterTags = newTags.filter((item) => item.type !== 'flag')
                  if (newTags) {
                    modData.tags = [newTags]
                  }
                }
              } catch (e) {
                Logger.error(e.message)
              }
            }
          } else {
            try {
              if (modData.tags && Array.isArray(modData.tags) && Array.isArray(modData.tags[0])) {
                const newTags = await this.requestStockDetailByTags(modData.tags[0])
                if (newTags) {
                  modData.tags = [newTags]
                }
              } else if (modData.list && Array.isArray(modData.list)) {
                const newTags = await this.requestStockDetailByList(modData.list)
                if (newTags) {
                  modData.tags = [newTags]
                }
              }
            } catch (e) {
              Logger.error(e.message)
            }
          }
        }
      }
    }
    callBack(jsonBean)
  }

  async requestStockDetailByList(list: KeyValueData[]): Promise<KeyValueData[]> {
    let tags: KeyValueData[] = []
    let index = 0
    for (const item of list) {
      if (item) {
        if (item.data) {
          if (item.data.type === "stock" && item.data.market && item.data.stock_code) {
            //stock类型的,需要请求行情数据
            const stockResponse = await new RequestStockBasicInfoApi().asyncRequestData(item.data.stock_code)
            if (stockResponse) {
              const stockInfo: StockBasicInfoBean = stockResponse
              if (stockInfo.snap && stockInfo.snap.last && stockInfo.snap.prev_close && stockInfo.snap.prev_close > 0) {
                const value = ((stockInfo.snap.last - stockInfo.snap.prev_close) / stockInfo.snap.prev_close * 100).toFixed(2) + "%"
                if (!value.startsWith("-")) {
                  item.data.value = "+" + value
                  item.data.color = redColor
                } else {
                  item.data.value = value
                  item.data.color = greenColor
                }
              }
              item.data.stock_name = stockInfo.snap.name
            }
          }
          tags[index] = item.data
          index += 1
        } else if (item.type === "stock" && item.market && item.stock_code) {
          //stock类型的,需要请求行情数据
          const stockResponse = await new RequestStockBasicInfoApi().asyncRequestData(item.stock_code)
          if (stockResponse) {
            const stockInfo: StockBasicInfoBean = stockResponse
            if (stockInfo.snap && stockInfo.snap.last && stockInfo.snap.prev_close && stockInfo.snap.prev_close > 0) {
              const value = ((stockInfo.snap.last - stockInfo.snap.prev_close) / stockInfo.snap.prev_close * 100).toFixed(2) + "%"
              if (!value.startsWith("-")) {
                item.value = "+" + value
                item.color = redColor
              } else {
                item.value = value
                item.color = greenColor
              }
            }
            item.stock_name = stockInfo.snap.name
          }
          tags[index] = item.data
          index += 1
        }

      }
    }
    if (index > 0) {
      return tags
    }
  }

  async requestStockDetailByTags(tags: KeyValueData[]) {
    try {
      for (const tag of tags) {
        if (tag) {
          if (tag.type === "stock" && tag.market && tag.stock_code) {
            //stock类型的,需要请求行情数据
            const stockResponse = await new RequestStockBasicInfoApi().asyncRequestData(tag.stock_code)
            if (stockResponse) {
              const stockInfo: StockBasicInfoBean = stockResponse
              if (stockInfo.snap && stockInfo.snap.last && stockInfo.snap.prev_close && stockInfo.snap.prev_close > 0) {
                const value = ((stockInfo.snap.last - stockInfo.snap.prev_close) / stockInfo.snap.prev_close * 100).toFixed(2) + "%"
                if (!value.startsWith("-")) {
                  tag.value = "+" + value
                  tag.color = redColor
                } else {
                  tag.value = value
                  tag.color = greenColor
                }
              }
              tag.stock_name = stockInfo.snap.name
            }
          }
        }
      }
      return tags
    } catch (e) {
      Logger.error(e.message)
    }
  }

  requestHomeBannerConfig(callBack: Callback<HomeBannerBean[]>) {
    //加载首页的金刚区的本地json文件
    // const url = "https://eq.10jqka.com.cn/eqadmin/tmp/indexFeed/iphone2.txt"
    getRawFileJSON("home_banner_config.json", ((response => {
      if (response) {
        const feedBeanList: HomeBannerBean[] = response.indexApp.map((item: any) => {
          return new HomeBannerBean(item)
        })
        callBack(feedBeanList)
      }
    })), this)
  }
}

export class HomeBannerBean {
  id: string;
  logid: string;
  title: string;
  imgurl: string;
  gray_imgurl: string;
  pic: string;
  icon: string;
  jumpurl: string;
  newjumpurl: string;
  sversion: string;
  is_support_fast: string; // 根据实际情况调整类型
  eversion: string;
  tjid: string;
  webrsid: string; // 根据实际情况调整类型
  search_score: string; // 根据实际情况调整类型
  search_word: string; // 根据实际情况调整类型
  subtitle: string; // 根据实际情况调整类型
  describe: string; // 根据实际情况调整类型

  constructor(data: any) {
    this.id = data.id;
    this.logid = data.logid;
    this.title = data.title;
    this.imgurl = data.imgurl;
    this.gray_imgurl = data.gray_imgurl;
    this.pic = data.pic;
    this.icon = data.icon;
    this.jumpurl = data.jumpurl;
    this.newjumpurl = data.newjumpurl;
    this.sversion = data.sversion;
    this.is_support_fast = data.is_support_fast;
    this.eversion = data.eversion;
    this.tjid = data.tjid;
    this.webrsid = data.webrsid;
    this.search_score = data.search_score;
    this.search_word = data.search_word;
    this.subtitle = data.subtitle;
    this.describe = data.describe;
  }
}
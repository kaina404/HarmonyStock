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
import http from '@ohos.net.http';
import { MinuteData} from '../bean/MinuteData';
import { MinuteItemData } from '../bean/MinuteItemData';
import { sendHttpRequest } from './BaseHttpApi';

/**
 * 请求指定股票的分时价格
 */
export class RequestStockApi {
  public requestData(stockCode: string, callback: Callback<MinuteData>) {
    var market = stockCode.startsWith('0') ? 'sz' : 'sh'
    let url = "http://yunhq.sse.com.cn:32041/v1/" + market + "1/line/" + stockCode + "?select=time,price,volume,avg_price,amount,highest,lowest&_=" + new Date().getTime()
    console.log("请求的URL：" + url);
    sendHttpRequest(url).then((data) => {
      if (data.responseCode == http.ResponseCode.OK) {
        let response = data.result
        let obj = JSON.parse(response as string)
        let bean = new MinuteData()
        bean.code = obj.code
        bean.prev_close = obj.prev_close
        bean.highest = obj.highest
        bean.lowest = obj.lowest
        bean.time = obj.time
        bean.total = obj.total
        bean.begin = obj.begin
        bean.date = obj.date
        bean.end = obj.end

        let lineList: Array<Array<number>> = obj.line
        var lineHighest = bean.highest
        var lineLowest = bean.lowest
        var currentTimePrice = bean.prev_close
        lineList.forEach((value: Array<number>, index) => {
          let item = new MinuteItemData()
          item.time = value[0]
          item.price = value[1]
          item.chengJiaoLiang = value[2]
          item.junjia = value[3]
          item.chengjiaoe = value[4]
          currentTimePrice = item.price
          if (item.price > lineHighest) {
            lineHighest = item.price
          }
          if (item.price < lineLowest) {
            lineLowest = item.price
          }
          if (item.chengJiaoLiang > bean.maxChengJiaoLiang) {
            bean.maxChengJiaoLiang = item.chengJiaoLiang
          }
          if (item.chengJiaoLiang < bean.minChengJiaoLiang) {
            bean.minChengJiaoLiang = item.chengJiaoLiang
          }
          item.zhangFuValue = parseFloat((item.price - bean.prev_close).toFixed(3))
          item.zhangFuPercent = (item.zhangFuValue * 1.0 / bean.lastNewPrice * 100).toFixed(3) + '%'
          bean.lastNewPrice = item.price
          bean.line.push(item)
        })
        if (Math.abs(lineHighest - bean.prev_close) > Math.abs(lineLowest - bean.prev_close)) {
          lineLowest = bean.prev_close - Math.abs(lineHighest - bean.prev_close)
          //获取
          bean.maxDistancePrice = Math.abs(lineHighest - bean.prev_close)
        } else {
          bean.maxDistancePrice = Math.abs(lineLowest - bean.prev_close)
          lineHighest = bean.prev_close + Math.abs(lineLowest - bean.prev_close)
        }
        bean.lastNewPrice = currentTimePrice
        bean.lineLowest = lineLowest
        bean.lineHighest = lineHighest
        bean.maxDistancePrice = this.roundUpToTwoDecimal(bean.maxDistancePrice)
        callback(bean)
      } else {
        callback(null)
      }
    }).catch((error) => {
      callback(null)
      console.log('error:' + JSON.stringify(error));
    })


  }

  public roundUpToTwoDecimalPlaces(num: number): string {
    const roundedNumber = Math.ceil(num * 100) / 100; // 先将数字乘以 100，然后向上取整，再除以 100
    return roundedNumber.toFixed(2); // 将结果保留两位小数并返回
  }

  public roundUpToTwoDecimal(num: number): number {
    const roundedNumber = Math.ceil(num * 100) / 100; // 先将数字乘以 100，然后向上取整，再除以 100
    return parseFloat(roundedNumber.toFixed(2)); // 将结果保留两位小数并返回
  }
}

export interface Callback<T> {
  (data: T): void;
}


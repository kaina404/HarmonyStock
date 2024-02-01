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
import { KLineData } from '../bean/KLineData';
import { sendHttpRequest } from './BaseHttpApi';
import { Callback } from './RequestStockApi';

/**
 * 请求K线数据
 */
export class RequestKLineApi {
  /**
   * 查询K线数据
   * @param code 代码
   * @param end_date 截止日期（时间戳）
   * @param count 截止日期向前推几天
   * @param frequency 日线(1d)，周线(1w)，月线(1M)
   * @returns
   */
  public getKLineData(code: string, {
    end_date = 0,
    count = 10,
    frequency  = '1d'
  }, callback?: Callback<KLineData[]>) {
    const unit: string = frequency.includes('1w') ? 'week' : frequency.includes('1M') ? 'month' : 'day'
    //发起请求
    var market = code.startsWith('0') ? 'sz' : 'sh'
    code = market + code
    var dateParams = ''
    if (end_date <= 0) {
      dateParams = ''
    } else {
      let date = new Date(end_date)
      dateParams = date.getUTCFullYear() + "-" + date.getUTCMonth() + "-" + date.getUTCDay()
    }
    const url: string = `http://web.ifzq.gtimg.cn/appstock/app/fqkline/get?param=${code},${unit},,${dateParams},${count},qfq`
    sendHttpRequest(url).then((data => {
      const st = JSON.parse(data.result as string)
      const ms = 'qfq' + unit
      const stk = st['data'][code]
      const buf = ms in stk ? stk[ms] : stk[unit]
      const stockData: KLineData[] = buf.map((item: number[]) => {
        const [time, open, close, high, low, volume] = item
        return new KLineData(time, open, close, high, low, volume)
      });
      console.log("拿到了K线数据")
      callback?.(stockData)
    }))
      .catch((error) => {
        console.error('Error fetching stock data:', error);
        callback?.([])
      });
  }
}

export interface StockData {
  time: string;
  open: number;
  close: number;
  high: number;
  low: number;
  volume: number;
}
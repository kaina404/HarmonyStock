import http from '@ohos.net.http'
import { sendHttpRequest } from './BaseHttpApi';

/**
 * 搜索上交所或者深交所的股票Api
 */
export class SearchStockApi {
  /**
   * 搜索股票Api
   * @param stockCode
   * @param callback
   */
  public requestData(stockCode: string, callback: Callback<SearchStockResponse>) {
    //发起请求
    var market = stockCode.startsWith('0') ? 'sz' : 'sh'
    let url = "http://yunhq.sse.com.cn:32041/v1/" + market + "1/list/exchange/equity?select=code,name,open,high,low,volume&_=" + new Date().getTime()
    console.log("请求的URL：" + url);
    sendHttpRequest(url).then((data) => {
      if (data.responseCode == http.ResponseCode.OK) {
        let response = data.result
        let jsonData = JSON.parse(response as string)
        const stockList = jsonData.list.map(item => new SearchStockBean(item[0], item[1], item[2], item[3], item[4], item[5], item[6]))
        const top50StockList = stockList
          .filter(stock => stock.code.includes(stockCode))
          .slice(0, 50);

        const searchStockResponse = new SearchStockResponse(jsonData.date, jsonData.time, jsonData.total, jsonData.begin, jsonData.end, stockList, top50StockList);
        callback(searchStockResponse)
      } else {
        callback(null)
      }
    }).catch((error) => {
      callback(null)
      console.log('error:' + JSON.stringify(error));
    })
  }
}

export interface Callback<T> {
  (data: T): void;
}

export class SearchStockResponse {
  date: number = 0;
  time: number = 0;
  total: number = 0;
  begin: number = 0;
  end: number = 0;
  list: SearchStockBean[] = [];
  top50StockList: SearchStockBean[] = [];

  constructor(date?: number, time?: number, total?: number, begin?: number, end?: number, list?: SearchStockBean[], top50StockList?: SearchStockBean[]) {
    this.date = date || 0;
    this.time = time || 0;
    this.total = total || 0;
    this.begin = begin || 0;
    this.end = end || 0;
    this.list = list || [];
    this.top50StockList = top50StockList || [];
  }
}

export class SearchStockBean {
  code: string = "";
  name: string = "";
  open: number = 0; //开盘价
  high: number = 0; //今日最高价
  low: number = 0; //今日最低价
  volume: number = 0;
  last: number = 0; //最新价
  isAddToDB: boolean = false

  constructor(code?: string, name?: string, open?: number, last?: number, high?: number, low?: number, volume?: number) {
    this.code = code || "";
    this.name = name || "";
    this.open = open || 0;
    this.high = high || 0;
    this.low = low || 0;
    this.volume = volume || 0;
    this.last = last || 0;
    this.isAddToDB = false
  }

  /**
   * 给List使用的唯一Key
   * @returns
   */
  uniqueListKey(): string {
    return this.code + SearchStockBean.name + this.isAddToDB
  }
}






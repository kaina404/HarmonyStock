import http from '@ohos.net.http'
import { StockBasicInfoBean, StockSnap, WuDangPrice } from '../bean/StockBasicInfoBean'
import { sendHttpRequest } from './BaseHttpApi'

/**
 * 从上交所或者深交所请求指定股票的基础信息
 * 最新价 最高 最低
 * 买卖五档价格等
 */
export class RequestStockBasicInfoApi {
  /**
   * 从上交所或者深交所请求【单支股票】的基础信息：最新价 最高 最低 ，买卖五档价格等
   * @param stockCode
   * @param callback
   */
  public requestData(stockCode: string, callback: Callback<StockBasicInfoBean>) {
    //发起请求
    var market = stockCode.startsWith('0') ? 'sz' : 'sh'
    //http://yunhq.sse.com.cn:32041/v1/sh1/snap/600089
    let url = "http://yunhq.sse.com.cn:32041/v1/" + market + "1/snap/" + stockCode + "?&_=" + new Date().getTime()
    sendHttpRequest(url).then((data) => {
      if (data.responseCode == http.ResponseCode.OK) {
        let response = data.result
        let stockInfoJSON = JSON.parse(response as string)
        //"特变电工", name
        // 14.26,open
        // 14.26,prev_close
        // 14.5,high
        // 14.23,low
        // 14.49,last
        // 0.23,riseFall
        // 1.61,ampRate
        // 44849128,volume
        // 646155832,amount
        // 6700, ??
        // 27782893, ??
        // 17066235,??
        const [
          name, open, prev_close, high, low, last, riseFall
          , ampRate, volume, amount, unknown, unknown2
          , unknown3, buyData, sellData] = stockInfoJSON.snap

        const stockBasicInfo: StockBasicInfoBean = {
          code: stockInfoJSON.code,
          date: stockInfoJSON.date,
          time: stockInfoJSON.time,
          snap: {
            name,
            open,
            last,
            prev_close,
            high,
            low,
            volume,
            riseFall,
            ampRate: ampRate,
            amount,
            change:0,
            chg_rate:0,
            wuDangData: {
              buy: this.parseWuDangData(buyData).sort(compareByPriceDesc),
              sell: this.parseWuDangData(sellData).sort(compareByPriceDesc),
            }
          }
        }
        callback(stockBasicInfo)
      } else {
        callback(null)
      }
    }).catch((error) => {
      callback(null)
      console.log('error:' + JSON.stringify(error));
    })
  }


  public parseWuDangData(data: number[]): WuDangPrice[] {
    const wuDangPrices: WuDangPrice[] = [];
    for (let i = 0; i < data.length; i += 2) {
      const price = data[i];
      const amount = data[i + 1] / 100.0;//除以100是将100股转为对应的1手
      wuDangPrices.push({ price, amount });
    }
    return wuDangPrices;
  }


  /**
   * 从上交所或者深交所请求【一组股票】的基础信息：最新价 昨开价 最高 最低等
   *
   * @param stockCodeAry stockCode List
   * @param callback stockCode:StockBasicInfoBean
   */
  public queryStockListBaseInfo(stockCodeAry: string[], callback: Callback<Map<string, StockBasicInfoBean>>) {
    if (stockCodeAry.length <= 0) {
      callback(new Map<string, StockBasicInfoBean>())
      return
    }
    // 合并两个网络请求的函数
    const time = new Date().getTime()
    //code,name,open,high,low,last,prev_close,chg_rate,volume,amount,tradephase,change,amp_rate,cpxxsubtype,cpxxprodusta
    const select = 'code,name,open,high,low,volume,last,date,time,prev_close,amount,chg_rate,change,amp_rate,cpxxsubtype'
    //上交所查询所有股票的基础信息
    const sh = 'http://yunhq.sse.com.cn:32041/v1/sh1/list/exchange/equity?select=' + select + '&_=' + time
    //深交所查询所有股票的基础信息
    const sz = 'http://yunhq.sse.com.cn:32041/v1/sz1/list/exchange/equity?select=' + select + '&_=' + (time + 10)
    // 使用Promise.all来并行执行两个网络请求,将请求到的数据进行解析，然后按照stockCode进行匹配解析，填充到Map<string, StockBasicInfoBean>中
    Promise.all([sendHttpRequest(sh), sendHttpRequest(sz)])
      .then(responses => {
        // responses 包含了两个请求的结果数组
        const [shData, szData] = responses;

        // 将请求到的数据进行解析，然后按照 stockCode 进行匹配解析
        const shMap = this.parseStockData(stockCodeAry, shData);
        const szMap = this.parseStockData(stockCodeAry, szData);

        // 合并两个 Map
        const combinedMap = new Map<string, StockBasicInfoBean>([...shMap, ...szMap]);

        // 调用回调函数，将结果传递给调用者
        callback(combinedMap);
      })
      .catch(error => {
        // 处理错误
        console.error('Error fetching stock data:', error);
        // 可以选择在这里调用 callback，传递错误信息给调用者
      });
  }

  // 解析股票数据的函数
  private parseStockData(stockCodeAry: string[], data: any): Map<string, StockBasicInfoBean> {
    const stockMap = new Map<string, StockBasicInfoBean>();
    let response = data.result
    let jsonData = JSON.parse(response as string)

    jsonData.list.map(item => {
      const [code, name, open, high, low, volume, last, date, time, prev_close, amount, chg_rate, change, amp_rate, cpxxsubtype] = item
      if (stockCodeAry.includes(code)) {
        const stockBasicInfo: StockBasicInfoBean = {
          code: name,
          date: date,
          time: time,
          snap: {
            name: name,
            open: open,
            last: last,
            prev_close: prev_close,
            high: high,
            low: low,
            volume: volume,
            riseFall: chg_rate,
            ampRate: amp_rate,
            amount: amount,
            change: change,
            chg_rate: chg_rate,
            cpxxsubtype: cpxxsubtype,
            wuDangData: null
          },
        };
        stockMap.set(code, stockBasicInfo);
      }
    })
    return stockMap;
  }
}


//按照价格降序排列
const compareByPriceDesc = (a: WuDangPrice, b: WuDangPrice) => b.price - a.price

export interface Callback<T> {
  (data: T): void;
}

import http from '@ohos.net.http'
import { FiveDayData, FiveDayItemMinuteData, FiveDayMinuteDataWrapper } from '../bean/FiveDayMinuteData'
import { sendHttpRequest } from './BaseHttpApi'
import { Callback } from './RequestStockApi'

/**
 * 请求五日分钟线数据。分钟里面，每个数据之间是间隔5分钟。例如第一条时间是10:00,下一条数据就是10:05
 * 返回的数据是前四个交易日的数据+今日的实时交易日的数据
 * 前四个交易日的数据可能足够，但是今日的实时交易日数据根据当前交易时长来确定。例如：
 * 1号 23条数据，2号 48条数据，3号48条数据，4号48条数据，5号25条数据。总计为count=240条数据。
 */
export class RequestFiveDayMinuteApi {
  /**
   * sina新浪全周期获取函数，分钟线 5m,15m,30m,60m  日线1d=240m   周线1w=1200m  1月=7200m
   * @param code
   * @param end_date
   * @param count
   * @param frequency
   * @param callback
   */
  public requestData(code: string, {
    end_date = null,
    count = 240,
    frequency = '5m'
  }, callback?: Callback<FiveDayData>) {

    var market = code.startsWith('0') ? 'sz' : 'sh'
    code = market + code
    frequency = frequency.replace('1d', '240m').replace('1w', '1200m').replace('1M', '7200m')
    const mcount = count
    const ts = parseInt(frequency.slice(0, -1)) || 1;

    if (end_date !== '' && ['240m', '1200m', '7200m'].includes(frequency)) {
      end_date = !end_date || !(end_date instanceof Date) ? new Date(end_date) : end_date
      let unit = 1
      if (frequency === '1200m') {
        unit = 4
      } else if (frequency === '7200m') {
        unit = 29
      }
      count += Math.floor((new Date().getTime() - end_date.getTime()) / (unit * 24 * 60 * 60 * 1000))
    }

    const url: string = `http://money.finance.sina.com.cn/quotes_service/api/json_v2.php/CN_MarketData.getKLineData?symbol=${code}&scale=${ts}&ma=5&datalen=${count}`
    console.log(url)
    sendHttpRequest(url).then((data => {
      const response = JSON.parse(data.result as string)
      var df: FiveDayItemMinuteData[] = response.map((item: any) => {
        return new FiveDayItemMinuteData(
          new Date(item.day),
          parseFloat(item.open),
          parseFloat(item.high),
          parseFloat(item.low),
          parseFloat(item.close),
          parseFloat(item.volume),
          parseFloat(item.ma_price5),
          parseFloat(item.ma_volume5),
        )
      });
      if (end_date !== '' && ['240m', '1200m', '7200m'].includes(frequency)) {
        const endDate = new Date(end_date)
        df = df.filter((item: any) => item.day <= endDate).slice(-mcount)
      }

      // 使用 reduce 方法按照日期进行分组
      const groupedData = df.reduce((acc, currentItem) => {
        // 获取当前项的年月日字符串，形如 'YYYY-MM-DD'
        const dateString = currentItem.day.toISOString().split('T')[0];

        // 如果已经有这个日期的数组，直接添加，否则创建一个新的数组
        if (acc[dateString]) {
          acc[dateString].push(currentItem);
        } else {
          acc[dateString] = [currentItem]
        }

        return acc;
      }, {} as Record<string, FiveDayItemMinuteData[]>)
      // 创建 FiveDayMinuteDataWrapper 数组
      const wrapperArray: FiveDayMinuteDataWrapper[] = []

      // 遍历 groupedData 中的每个日期
      for (const dateString in groupedData) {
        if (groupedData.hasOwnProperty(dateString)) {
          const date = new Date(dateString)
          const fiveDayMinuteDataAry = groupedData[dateString]

          // 计算 maxPrice、minPrice、openPrice
          const prices = fiveDayMinuteDataAry.map(data => data.close)
          const maxPrice = Math.max(...prices)
          const minPrice = Math.min(...prices)
          const openPrice = fiveDayMinuteDataAry[0].open

          // 创建 FiveDayMinuteDataWrapper 实例并添加到数组中
          const wrapper: FiveDayMinuteDataWrapper = {
            date: date,
            fiveDayMinuteDataAry: fiveDayMinuteDataAry,
            maxPrice: maxPrice,
            minPrice: minPrice,
            openPrice: openPrice
          }

          wrapperArray.push(wrapper)
        }
      }
      const lastFiveDay: FiveDayMinuteDataWrapper[] = wrapperArray.slice(-5);
      const fiveDayData = new FiveDayData()
      fiveDayData.fiveDayMinuteDataWrapper = lastFiveDay
      var maxPrice = Math.max(...lastFiveDay.map(data => data.maxPrice))
      var minPrice = Math.min(...lastFiveDay.map(data => data.minPrice))
      const firstPrice = wrapperArray[0].openPrice
      if (Math.abs(maxPrice - firstPrice) > Math.abs(minPrice - firstPrice)) {
        minPrice = firstPrice - (Math.abs(maxPrice - firstPrice))
      } else {
        maxPrice = firstPrice + Math.abs(minPrice - firstPrice)
      }
      fiveDayData.allDataMaxPrice = maxPrice
      fiveDayData.allDataMinPrice = minPrice
      callback?.(fiveDayData)
    }))
      .catch((error) => {
        console.error('Error fetching stock data:', error)
        callback?.(null)
      });
  }
}

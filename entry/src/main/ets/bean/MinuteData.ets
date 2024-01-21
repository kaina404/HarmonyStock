import { MinuteItemData } from './MinuteItemData'

export class MinuteData {
  code: string
  lineLowest: number = null
  lineHighest: number = null
  prev_close: number
  highest: number
  lowest: number
  date: number
  time: number
  total: number
  begin: number
  end: number
  lastNewPrice: number//昨收价格
  line: Array<MinuteItemData> = []//存储分时信息
  maxDistancePrice: number//最高价格
  maxChengJiaoLiang: number = 0
  minChengJiaoLiang: number = 0

  public parseJson(data: string): MinuteData {
    let obj = JSON.parse(data)
    let bean = new MinuteData()
    this.begin = obj.begin
    this.code = obj.code
    this.date = obj.date
    this.end = obj.end
    this.highest = obj.highest
    return bean
  }
}



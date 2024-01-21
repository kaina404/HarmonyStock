export default class StockDBData {
  id: number = -1;
  code: string = '';
  name: string = '';
  market: string = '';
  sortIndex:number = 0//new Date().valueOf()
  date: string = '';//加入自选的时间 new Date().toUTCString(),
  last: string = '';//加入自选时的股票价格
}
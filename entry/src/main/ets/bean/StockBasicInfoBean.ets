/**
 * {"code":"000002","date":20240116,"time":121111,"snap":["万  科Ａ",9.7100,9.6700,9.7000,9.5400,9.5500,
 * -0.1600,-1.65,33986076,327706400,1200,17410183,16575893,[9.5400,98700,9.5300,246700,9.5200,154500,9.5100,
 * 343100,9.5000,629400],[9.5500,10200,9.5600,92600,9.5700,53500,9.5800,198301,9.5900,49100]]}
 * 股票的基础信息
 */

export class StockBasicInfoBean {
  code: string
  date: number
  time: number = 0
  snap: StockSnap
}

export class StockSnap {
  name: string //股票名称
  open: number //开盘价
  last: number //最新价
  prev_close: number //昨收价
  high: number //最高价
  low: number //最低价
  volume: number //成交量(股)
  riseFall: number //涨跌
  ampRate: number //振幅百分比
  amount: number //金额
  change: number //涨跌
  chg_rate: number //涨跌百分比
  cpxxsubtype?: string //ASH ：A股上海，1：深交所
  wuDangData: WuDangData // 五档买卖数据
}

export class WuDangData {
  buy: WuDangPrice[]//五档买
  sell: WuDangPrice[]//五档买
}

export class WuDangPrice {
  price: number //五档买卖价格
  amount: number //五档成交量
}

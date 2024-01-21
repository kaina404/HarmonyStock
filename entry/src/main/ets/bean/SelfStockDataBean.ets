import { StockBasicInfoBean } from './StockBasicInfoBean';
import StockDBData from './StockDBData';

/**
 * 自选股页面所用的Bean
 */
export class SelfStockDataBean extends StockDBData {
  isAddToDB: boolean = false
  baseInfo: StockBasicInfoBean = new StockBasicInfoBean()

  uniqueListKey(): string {
    return this.code + this.name + this.market + this.isAddToDB + this.sortIndex.toString() + this.baseInfo.time.toString()
  }
}
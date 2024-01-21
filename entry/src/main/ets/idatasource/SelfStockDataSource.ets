import { SelfStockDataBean } from '../bean/SelfStockDataBean';
import { BasicDataSource } from './BasicDataSource';

export class SelfStockDataSource extends BasicDataSource<SelfStockDataBean> {
  public notifyItemData(data: SelfStockDataBean) {
    this.getAllData().forEach((item, index) => {
      if (item.code == data.code) {
        this.changeData(index, data)
      }
    })
  }

  notifyItemDataDelete(code: string): void {
    this.getAllData().forEach((item, index) => {
      if (item.code == code) {
        this.deleteData(index)
      }
    })
  }
}
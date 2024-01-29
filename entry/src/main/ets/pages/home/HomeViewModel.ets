/**
 * Demo配置：https://eq.10jqka.com.cn/eqadmin/tmp/indexFeed/iphone2.txt
 * 首页中间内容
 * https://eq.10jqka.com.cn/eq/open/api/homepage_v2/v3/old_user?platform=iphone&version=I037.08.488&is_reflow=0
 */
import util from '@ohos.util';
import { getRawFileJSON } from '../../common/CommonUtils';
import { sendHttpRequest } from '../../network/BaseHttpApi';
import { Callback } from '../../network/RequestStockApi';

export class HomeViewModel {
  //查询首页配置的信息流数据
  requestFeedData() {
    // const url = "https://eq.10jqka.com.cn/eq/open/api/homepage_v2/v3/old_user?platform=iphone&version=I037.08.488&is_reflow=0"
    // sendHttpRequest(url).then((data => {
    //   const response = JSON.parse(data.result as string)
    //   console.log("fmeow")
    //   JSON.stringify()
    // }))

  }

  requestHomeBannerConfig(callBack: Callback<FeedBean[]>) {
    //加载首页的金刚区的本地json文件
    // const url = "https://eq.10jqka.com.cn/eqadmin/tmp/indexFeed/iphone2.txt"
    getRawFileJSON("home_config.json", ((response => {
      if (response) {
        const feedBeanList: FeedBean[] = response.indexApp.map((item: any) => {
          return new FeedBean(item)
        })
        callBack(feedBeanList)
      }
    })), this)
  }
}

export class FeedBean {
  id: string;
  logid: string;
  title: string;
  imgurl: string;
  gray_imgurl: string;
  pic: string;
  icon: string;
  jumpurl: string;
  newjumpurl: string;
  sversion: string;
  is_support_fast: string; // 根据实际情况调整类型
  eversion: string;
  tjid: string;
  webrsid: string; // 根据实际情况调整类型
  search_score: string; // 根据实际情况调整类型
  search_word: string; // 根据实际情况调整类型
  subtitle: string; // 根据实际情况调整类型
  describe: string; // 根据实际情况调整类型

  constructor(data: any) {
    this.id = data.id;
    this.logid = data.logid;
    this.title = data.title;
    this.imgurl = data.imgurl;
    this.gray_imgurl = data.gray_imgurl;
    this.pic = data.pic;
    this.icon = data.icon;
    this.jumpurl = data.jumpurl;
    this.newjumpurl = data.newjumpurl;
    this.sversion = data.sversion;
    this.is_support_fast = data.is_support_fast;
    this.eversion = data.eversion;
    this.tjid = data.tjid;
    this.webrsid = data.webrsid;
    this.search_score = data.search_score;
    this.search_word = data.search_word;
    this.subtitle = data.subtitle;
    this.describe = data.describe;
  }
}
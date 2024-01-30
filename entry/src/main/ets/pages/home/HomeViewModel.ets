/**
 * Demo配置：https://eq.10jqka.com.cn/eqadmin/tmp/indexFeed/iphone2.txt
 * 首页中间内容
 * https://eq.10jqka.com.cn/eq/open/api/homepage_v2/v3/old_user?platform=iphone&version=I037.08.488&is_reflow=0
 */
import util from '@ohos.util';
import { getRawFileJSON } from '../../common/CommonUtils';
import Logger from '../../common/Logger';
import { sendHttpRequest } from '../../network/BaseHttpApi';
import { Callback } from '../../network/RequestStockApi';
import { Card, ModData, CardTitle, CardUrl, Data, Floor, HomeFeedBean, Icon, ApiResponse } from './HomeFeedBean';

export class HomeViewModel {
  //查询首页配置的信息流数据
  requestFeedData(callBack: Callback<HomeFeedBean>) {
    // const url = "https://eq.10jqka.com.cn/eq/open/api/homepage_v2/v3/old_user?platform=iphone&version=I037.08.488&is_reflow=0"
    // sendHttpRequest(url).then((data => {
    //   const response = JSON.parse(data.result as string)
    //   console.log("fmeow")
    //   JSON.stringify()
    // }))
    //加载首页的信息流的本地json文件
    // const url = "https://eq.10jqka.com.cn/eqadmin/tmp/indexFeed/iphone2.txt"
    getRawFileJSON("home_config.json", ((jsonData => {
      if (jsonData) {
        // 创建对应的 TypeScript 类实例并填充数据
        const jsonBean = new HomeFeedBean();
        jsonBean.code = jsonData.code;
        jsonBean.msg = jsonData.msg;

        const data = new Data();
        data.strategy_id = jsonData.data.strategy_id;
        data.version = jsonData.data.version;
        // 过滤 floor_list 中 floor_name 或 version 为 null 的数据
        const filteredFloorList = jsonData.data.floor_list.filter((floorData: any) => {
          return floorData.floor_name !== null && floorData.version !== null;
        });
        const floorList = filteredFloorList.map((floorData: any) => {
          const floor = new Floor();
          floor.floor_id = floorData.floor_id;
          floor.version = floorData.version;
          floor.floor_name = floorData.floor_name;
          floor.floor_key = floorData.floor_key;

          const icon = new Icon();
          icon.day_pic = floorData.icon.day_pic;
          icon.night_pic = floorData.icon.night_pic;
          floor.icon = icon;

          const cardShowList = floorData.card_show_list.map((cardData: any) => {
            const card = new Card();
            card.card_id = cardData.card_id;
            card.card_key = cardData.card_key;
            card.card_template = cardData.card_template;
            card.card_size = cardData.card_size;

            const cardTitle = new CardTitle();
            cardTitle.value = cardData.card_title.value;
            cardTitle.type = cardData.card_title.type;
            card.card_title = cardTitle;

            const cardUrl = new CardUrl();
            if (cardData.card_url) {
              if (cardData.card_url.ios) {
                cardUrl.ios = cardData.card_url.ios;
              }
              if (cardData.card_url.android) {
                cardUrl.android = cardData.card_url.android;
              }
            }
            card.card_url = cardUrl;

            card.card_ext = cardData.card_ext;
            card.card_polling = cardData.card_polling;
            card.data_completed = cardData.data_completed;

            const cardDataObj = new ModData();
            const modData = cardData.mod_data[0]
            if (modData) {
              cardDataObj.header = modData.header;
              cardDataObj.icon = modData.icon;
              cardDataObj.prefix = modData.prefix;
              cardDataObj.content = modData.content;
              cardDataObj.url = modData.url;
              cardDataObj.url_v2 = modData.url_v2;
              cardDataObj.req_desc = modData.req_desc;
              const jump = modData.jump;
              if (jump) {
                const jumpUrl: CardUrl = new CardUrl()
                if (jump.android) {
                  jumpUrl.android = jump.android
                }
                if (jump.ios) {
                  jumpUrl.ios = jump.ios
                }
                cardDataObj.jump = jumpUrl
              }
            }

            // const tags = cardData.mod_data[0].tags[0].map((tag: any) => {
            //   return {
            //     value: tag.value,
            //     type: tag.type,
            //   };
            // });
            // cardDataObj.tags = [tags];

            if (modData) {
              cardDataObj.content_id = modData.content_id;
            }

            card.mod_data = [cardDataObj];

            card.card_version = cardData.card_version;
            card.render_key = cardData.render_key;
            card.point = cardData.point;
            card.function_id = cardData.function_id;

            return card;
          });

          floor.card_show_list = cardShowList;

          floor.card_hidden_list = floorData.card_hidden_list;
          floor.show_title = floorData.show_title;

          return floor;
        });

        data.floor_list = floorList;
        data.channel = jsonData.data.channel;
        jsonBean.data = data;
        jsonBean.trace_id = jsonData.trace_id;
        // jsonBean 对象包含了从 JSON 数据中解析得到的完整数据结构
        callBack(jsonBean)
        Logger.debug("解析JSON完毕")
        this.processAsyncRequests(callBack, jsonBean)
      }
    })), this)
  }

  /**
   * 部分数据的填充，如果  modData.req_desc == "HTTP_GET"  ，则需要填充内部的httpResponse数据。
   * @param callBack
   * @param jsonBean
   */
  async processAsyncRequests(callBack, jsonBean) {
    const floorListFor = jsonBean.data.floor_list
    for (const floor of floorListFor) {
      for (const card of floor.card_show_list) {
        for (const modData of card.mod_data) {
          if (modData.url_v2 && modData.req_desc == "HTTP_GET") {
            const response = await sendHttpRequest(modData.url_v2)
            const parsedData: ApiResponse = JSON.parse(response.result as string);
            modData.httpResponse = parsedData
          }
        }
      }
    }
    callBack(jsonBean)
  }

  requestHomeBannerConfig(callBack: Callback<HomeBannerBean[]>) {
    //加载首页的金刚区的本地json文件
    // const url = "https://eq.10jqka.com.cn/eqadmin/tmp/indexFeed/iphone2.txt"
    getRawFileJSON("home_banner_config.json", ((response => {
      if (response) {
        const feedBeanList: HomeBannerBean[] = response.indexApp.map((item: any) => {
          return new HomeBannerBean(item)
        })
        callBack(feedBeanList)
      }
    })), this)
  }
}

export class HomeBannerBean {
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
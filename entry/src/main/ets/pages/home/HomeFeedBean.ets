export class CardTitle {
  value: string = "";
  type: string = "";
}

export class CardUrl {
  ios: string = "";
  android: string = "";
}


export class ModData {
  icon: string = "";
  prefix: string = "";
  content: string;
  contentObj: DataDesc;
  jump: CardUrl;
  tags: Tag[][];
  content_id: string = "";
  url: string = "";
  url_v2: string = "";
  req_desc: string = "";
  param_list: string[] = [];
  httpResponse: ApiResponse;

  header: Tag[];
  list: ModDataListItem[] = [];
}

export class ModDataListItem {
  prefix: Prefix;
  data: Tag;
  title: string;
  content: string;
  jump: Jump;
  data_desc: DataDesc[] = [];
  type: string;
  market: string;
  stock_code: string;
  value: string;
  name: string;
  tags: Tag[][];
}

export class DataDesc {
  color: string;
  type: string;
  value: string;
}

export class Card {
  card_id: number = 0;
  card_key: string = "";
  card_template: string = "";
  card_size: number = 0;
  card_title: CardTitle = new CardTitle();
  card_url: CardUrl = new CardUrl();
  card_ext: null | any = null;
  card_polling: boolean = false;
  data_completed: boolean = false;
  mod_data: ModData[] = [];
  card_version: number = 0;
  render_key: string = "";
  point: string = "";
  function_id: string = "";
  cardHttpBean: CardHttpBean

  stockDataInfo(): Tag {
    try {
      return this.cardHttpBean.tags[0][0]
    } catch (e) {
      return null
    }
  }

  modDataContentCheck() {
    return this.mod_data && this.mod_data[0] && this.mod_data[0].content
  }

  isModDataTagsCheck() {
    if (this.mod_data && this.mod_data[0] && Array.isArray(this.mod_data[0].tags) && Array.isArray(this.mod_data[0].tags[0])) {
      return this.mod_data[0].tags[0]
    }
  }

  getCardHttpBean(): CardHttpBean {
    if (this.mod_data && this.mod_data[0]) {
      const modData = this.mod_data[0]
      if (modData.httpResponse && modData.httpResponse.data && modData.httpResponse.data.list) {
        const contentList = modData.httpResponse.data.list[0]
        if (contentList) {
          return contentList
        }
      }
    }
    return null
  }
}

export class Icon {
  day_pic: string = "";
  night_pic: string = "";
}

export class Floor {
  floor_id: number = 0;
  version: number = 0;
  floor_name: string = "";
  floor_key: string = "";
  icon: Icon = new Icon();
  card_show_list: Card[] = [];
  card_hidden_list: null | any = null;
  show_title: boolean = true;
}

export class Data {
  strategy_id: number = 0;
  version: number = 0;
  floor_list: Floor[] = [];
  channel: string = "";
}

export class HomeFeedBean {
  code: number = 0;
  msg: string = "";
  data: Data = new Data();
  trace_id: string = "";
}

export class ApiResponse {
  status_code: number;
  data: CardHttpData;
  status_msg: string;

  isApiResponseTags(): Tag[] {
    if (this.data
      && this.data.list
      && Array.isArray(this.data.list)
      && this.data.list[0]
      && this.data.list[0].tags
      && Array.isArray(this.data.list[0].tags)
      && this.data.list[0].tags[0]
      && Array.isArray(this.data.list[0].tags[0])) {
      return this.data.list[0].tags[0]
    }
    return []
  }
}

export interface CardHttpData {
  list: CardHttpBean[];
  header: Tag[];
}

export interface CardHttpBean {
  content: string;
  jump: Jump;
  tags: Tag[][];
  prefix: Prefix;
}

export interface Jump {
  ios: string;
  android: string;
}

export class Tag {
  type: string;
  market: string;
  background: string;
  stock_code: string;
  value: string;
  stock_name: string;
}

export interface Prefix {
  type: string;
  value: string;
}
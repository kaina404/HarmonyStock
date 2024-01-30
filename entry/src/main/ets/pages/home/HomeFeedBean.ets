export class CardTitle {
  value: string = "";
  type: string = "";
}

export class CardUrl {
  ios: string = "";
  android: string = "";
}


export class ModData {
  header: string = "";
  icon: string = "";
  prefix: string = "";
  content: string = "";
  jump: CardUrl;
  tags: Tag[][];
  content_id: string = "";
  url: string = "";
  url_v2: string = "";
  req_desc: string = "";
  param_list: string[] = [];
  httpResponse: ApiResponse;
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

  modDataContentCheck() {
    return this.mod_data && this.mod_data[0] && this.mod_data[0].content
  }

  isModDataCheck(): boolean {
    if (this.mod_data && this.mod_data[0] && this.mod_data[0].tags && this.mod_data[0].tags[0] && this.mod_data[0].tags[0]) {
      return true
    }
    return false
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

export interface ApiResponse {
  status_code: number;
  data: CardHttpData;
  status_msg: string;
}

export interface CardHttpData {
  list: CardHttpBean[];
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
}

export interface Prefix {
  type: string;
  value: string;
}
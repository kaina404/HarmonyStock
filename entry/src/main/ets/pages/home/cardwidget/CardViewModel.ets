/*
 * Copyright (c) 2024 Kaina404 Device Co., Ltd.
 *
 *  https://github.com/kaina404/
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import Logger from '../../../common/Logger';
import { Card, ModData, ModDataListItem } from '../HomeFeedBean';

export class CardViewModel {
  private card: Card = null

  constructor(card: Card) {
    this.card = card
  }

  checkData(card: Card) {
    this.card = card
    return card
  }

  getCardType(card: Card): CardType {
    this.card = card
    try {
      if (card.mod_data[0].list.length > 0) {
        return CardType.List
      }
    } catch (e) {
      Logger.error(e.message)
    }
    try {
      if (card.mod_data[0].list[0].tags[0][0].stock_code && card.mod_data[0].list[0].content) {
        return CardType.CONTENT_FOR_TXT_AND_BOTTOM
      }
    } catch (e) {
      Logger.error(e.message)
    }
    return CardType.UNKNOWN
  }

  getModData(card: Card):ModData {
    this.card = card
    return this.card.mod_data[0]
  }

  getCardList(): ModDataListItem[] {
    try {
      if (this.card.mod_data[0].list.length > 0) {
        return this.card.mod_data[0].list
      }
    } catch (e) {
    }
    return []
  }
}

export enum CardType {
  UNKNOWN,
  List,
  CONTENT_FOR_TXT_AND_BOTTOM,
}

export enum CardSize {
  NORMAL = 3,
  LARGER = 2
}
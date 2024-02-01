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
import { defaultBlackColor, defaultColor, redColor } from '../../../common/Constants';
import Logger from '../../../common/Logger';
import { CardItemData, KeyValueData, ModDataBean } from '../CardResponse';

export class CardViewModel {
  private card: CardItemData = null

  constructor(card: CardItemData) {
    this.card = card
  }

  getColor(colorDesc: string): string {
    if (colorDesc === "black") return defaultBlackColor
    if (colorDesc === "red") return redColor
    return defaultBlackColor
  }

  checkData(card: CardItemData) {
    this.card = card
    return card
  }

  getCardType(card: CardItemData): CardType {
    this.card = card
    try {
      if (card.mod_data[0].content && card.mod_data[0].tags) {
        return CardType.CONTENT_FOR_TXT_AND_BOTTOM
      }
    } catch (e) {
      Logger.error(e.message)
    }
    try {
      if (card.mod_data[0].list.length > 0) {
        return CardType.List
      }
    } catch (e) {
      Logger.error(e.message)
    }
    return CardType.UNKNOWN
  }

  getModData(card: CardItemData): ModDataBean {
    this.card = card
    return this.card.mod_data[0]
  }

  getCardList(): KeyValueData[] {
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
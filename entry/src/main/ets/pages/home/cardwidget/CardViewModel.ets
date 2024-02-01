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
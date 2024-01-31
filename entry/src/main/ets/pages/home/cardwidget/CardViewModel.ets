import { Card, ModDataListItem } from '../HomeFeedBean';

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
    }
    return CardType.UNKNOWN
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
}

export enum CardSize {
  NORMAL = 3,
  LARGER = 2
}
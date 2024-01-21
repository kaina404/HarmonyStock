import { expect } from '@ohos/hypium';
import { DrawRect } from '../pages/DrawRect';
import { defaultColor, greenColor, redColorRGB } from './Constants';

/**
 * 根据矩形区域获取填充Rect区域的文字大小。
 * @param context
 * @param rect
 * @param initFontSize 9px
 * @returns
 */
export function getTextMaxFontSize(context: CanvasRenderingContext2D, rect: DrawRect, initFontSize: string, txt: string): string {
  if (initFontSize.endsWith('px') && rect.width > 0 && rect.width > 0) {
    context.font = initFontSize
    //计算最最新价格合适的文本大小,文本过大就缩小，反之就放大。文本过大，两种情况：过宽、过高。
    var heightFontMaxSizeInt: number = parseInt(initFontSize.replace('px', ''), 10)
    //根据宽计算一遍最合适的字体大小
    var tmpTextMetrics = context.measureText(txt)
    var txtW = tmpTextMetrics.width
    if (txtW > rect.width) {
      while (txtW > rect.width && heightFontMaxSizeInt > 5) {
        heightFontMaxSizeInt -= 1
        context.font = heightFontMaxSizeInt + 'px'
        txtW = context.measureText(txt).width
      }
    } else {
      while (txtW < rect.width && heightFontMaxSizeInt > 5) {
        heightFontMaxSizeInt += 1
        context.font = heightFontMaxSizeInt + 'px'
        txtW = context.measureText(txt).width
      }
    }
    //再根据高计算一遍最合适的字体
    tmpTextMetrics = context.measureText(txt)
    var txtH = tmpTextMetrics.height
    var heightMaxFont = heightFontMaxSizeInt
    if (txtH > rect.height) {
      while (txtH > rect.height && heightMaxFont > 5) {
        heightMaxFont -= 1
        context.font = heightMaxFont + 'px'
        txtH = context.measureText(txt).height
      }
    } else {
      while (txtH < rect.height && heightMaxFont > 5) {
        heightMaxFont += 1
        context.font = heightMaxFont + 'px'
        txtH = context.measureText(txt).height
      }
    }

    return Math.min(heightMaxFont, heightFontMaxSizeInt) + 'px'

  }
  return initFontSize
}

/**
 * 根据最新价跟昨收价比较，获取红涨绿跌颜色
 * @param last
 * @param prev_close
 */
export function getPriceColor(last: number, open: number): string {
  if (last && open) {
    if (last == open) {
      return defaultColor
    } else if (last > open) {
      return redColorRGB
    } else {
      return greenColor
    }
  }
  return defaultColor
}
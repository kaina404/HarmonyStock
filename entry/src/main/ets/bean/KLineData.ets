export class KLineData {
  time: number
  open: number
  close: number
  high: number
  low: number
  volume: number
  centerX: number = 0//当前数据所在的X轴位置


  constructor(time?: number, open?: number, close?: number, high?: number, low?: number, volume?: number) {
    this.time = time
    this.open = open
    this.close = close
    this.high = high
    this.low = low
    this.volume = volume
  }
}

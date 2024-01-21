export class DrawRect {
  startX: number = 0
  startY: number = 0
  width: number = 0
  height: number = 0

  constructor(startX: number, startY: number, width: number, height: number) {
    this.startX = startX
    this.startY = startY
    this.width = width
    this.height = height
  }

  public getEndX(): number {
    return this.startX + this.width
  }

  public getEndY(): number {
    return this.startY + this.height
  }

  public fillRect(context: CanvasRenderingContext2D, color: string) {
    context.fillStyle = color
    context.fillRect(this.startX, this.startY, this.width, this.height)
  }

  public strokeRect(context: CanvasRenderingContext2D, color: string) {
    context.strokeStyle = color
    context.strokeRect(this.startX, this.startY, this.width, this.height)
  }
}
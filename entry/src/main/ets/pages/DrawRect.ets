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
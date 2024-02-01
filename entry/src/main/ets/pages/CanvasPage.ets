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
import settings from '@ohos.settings'
import hilog from '@ohos.hilog'

@Entry
@Component
struct CanvasPage {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private offContext: OffscreenCanvasRenderingContext2D = new OffscreenCanvasRenderingContext2D(600, 600, this.settings)
  private img: ImageBitmap = new ImageBitmap('/common/startIcon.png')

  aboutToAppear() {
    // this.context.lineWidth = 30
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Canvas(this.context)
        .width('100%')
        .height('100%')
        .backgroundColor('#F5DC62')
        .onReady(() => {

          this.context.fillStyle = '#0097D4'
          this.context.fillRect(50, 50, 100, 100)
          this.context.beginPath()
          this.context.moveTo(80, 80)
          // this.context

          this.context.beginPath()
          this.context.moveTo(50, 50)
          this.context.lineTo(280, 160)
          this.context.stroke()

          let region = new Path2D()
          region.arc(100, 70, 40, 0, 5.28)
          this.context.stroke(region)

          this.context.beginPath()
          this.context.rect(90, 90, 100, 100)
          this.context.stroke()

          this.context.beginPath()
          this.context.strokeStyle = '#e2233e'
          this.context.arc(100, 200, 40, 0, 8)
          this.context.stroke()

          this.context.beginPath()
          this.context.ellipse(100, 200, 40, 100, Math.PI * 0.25, Math.PI * 0, Math.PI * 2)
          this.context.stroke()

          this.context.font = '155px sans-serif'
          this.context.fillText('Canvas', 100, 300)

          this.context.font = '155px'
          this.context.strokeText('Canvas', 100, 350)

          // //-----绘制Image-----
          // // 使用drawImage接口将图片画在（0，0）为起点，宽高130的区域
          // this.offContext.drawImage(this.img, 0, 500, 130, 130);
          // // 将离屏绘制的内容画到canvas组件上
          // let image = this.offContext.transferToImageBitmap()
          // this.context.transferFromImageBitmap(image)
          //
          // //-----获取区域内的ImageData，绘制成新的Image-----
          // // 使用getImageData接口，获得canvas组件区域中，（50，50）为起点，宽高130范围内的绘制内容
          // let imagedata = this.offContext.getImageData(0, 500, 130, 130)
          // // 使用putImageData接口将得到的ImageData画在起点为（150， 150）的区域中
          // this.offContext.putImageData(imagedata, 150, 150)

          let path = new Path2D()
          path.moveTo(150, 350)

          path.lineTo(50, 400)
          path.lineTo(150, 500)
          path.lineTo(250, 600)
          path.lineTo(350, 150)
          path.closePath()
          this.context.fillStyle = '#0097D4'
          this.context.fill(path)

          this.context.font = '55px'
          this.context.fillStyle = '#e2233e'
          this.context.fillText('150, 350', 150, 350)

          let rectPath = new Path2D()
          rectPath.rect(100, 600, 20, 50)
          this.context.lineWidth = 5
          this.context.stroke(rectPath)
        })
        .onClick((event) => {
          hilog.info(0x0000, 'CanvasPage', '%{public}s', 'CanvasPage onClick');
        })
        .onTouch((event) => {
          hilog.info(0x0000, 'CanvasPage', '%{public}s', 'CanvasPage onTouch' + 'tiltX' + event.touches[0].x + 'tiltY' + event.touches[0].y);
        })
        .onMouse((event) => {
          hilog.info(0x0000, 'CanvasPage', '%{public}s', 'CanvasPage onMouse' + 'tiltX' + event.tiltX + 'tiltY' + event.tiltY);
        })
    }
    .backgroundColor(Color.Orange)
    .width('100%')
    .height('100%')
  }
}
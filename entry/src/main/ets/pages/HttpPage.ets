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
import http from '@ohos.net.http'

@Entry
@Component
struct HttpPage {
  @State message: string = 'HttpTest'
  @State response: string = ""

  build() {
    Row() {
      Column() {
        Button(this.message)
          .onClick(() => {
            console.log("LOG111 http hello")
            testHttp((result) => {
              this.response = result
            })
          })
        Text(this.response)
      }
      .width('100%')
    }
    .height('100%')
  }
}

function testHttp(result: (result?: string) => void) {
  console.log("LOG111 http")
  //创建http请求
  let httpRequest = http.createHttp()
  //订阅请求头
  httpRequest.on('headersReceive', (header) => {
    result('获取到请求头信息')
    console.log("获取到请求头信息")
    console.log("header:" + JSON.stringify(header))
  })
  //发起请求
  let promise = httpRequest.request("https://www.wanandroid.com/article/list/1/json", {
    method: http.RequestMethod.GET,
    extraData: {},
    connectTimeout: 5000,
    readTimeout: 5000,
    header: {
      'Content-Type': 'application/json'
    }
  })
  promise.then((data) => {
    if(data.responseCode == http.ResponseCode.OK) {
      result("请求成功"+ JSON.stringify(data.result))
    }else  {
      result("请求失败"+ data.result)
    }
  }).catch((error) => {
    result('error:' + JSON.stringify(error));
  })



}
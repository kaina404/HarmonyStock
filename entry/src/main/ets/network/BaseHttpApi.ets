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
import http from '@ohos.net.http';

/**
 * 统一网络请求，所有的简单的http请求均在这里调用
 * @param url
 * @param method
 * @returns
 */
export async function sendHttpRequest(url: string, method?: http.RequestMethod): Promise<any> {
  const httpRequest = http.createHttp()
  const response = await httpRequest.request(url, {
    method: method,
    extraData: {},
    connectTimeout: 5000,
    readTimeout: 5000,
    header: {
      'platform':'Android',
      'Proxy-Connection': 'keep-alive',
      'Content-Type': 'application/json',
      'Accept-Encoding': 'gzip, deflate',
      'Accept-Language': 'zh-CN,zh;q=0.9,en;q=0.8',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive',
      'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Safari/537.36',
    }
  });
  return response;
}

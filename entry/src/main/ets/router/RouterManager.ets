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
import router from '@ohos.router'

/**
 * App容器页面
 */
export const Path_Main = 'pages/main/ContentPage'
/**
 * 搜索股票页面
 */
export const Path_SearchStockPage = 'pages/SearchStockPage'
/**
 * 个股详情页面（行情、分时图、K线图等等）
 */
export const Path_StockDetailPage = 'pages/StockDetailPage'
/**
 * WebView H5页面
 */
export const Path_WebPage = 'pages/WebPage'
/**
 * 自选股页面
 */
export const Path_SelfStockPage = 'pages/SelfStockPage'

export function openPage(options?: MyRouterOptions) {
  router.pushUrl({
    url: options?.url,
    params: options?.params
  })
}
export function openWebViewPage( url:string, title?: string) {
  router.pushUrl({
    url: Path_WebPage,
    params: {
      'url': url,
      'title': title
    }
  })
}
export function closePage(options?: MyRouterOptions) {
  router.back({
    url: options?.url,
    params: options?.params
  })
}

interface MyRouterOptions {
  url: string;
  params?: Object;
}
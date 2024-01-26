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
export const Path_HttpPage = 'pages/HttpPage'
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
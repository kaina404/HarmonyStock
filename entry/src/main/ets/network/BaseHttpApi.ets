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

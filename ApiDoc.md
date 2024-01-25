https://github.com/kaina404/HarmonyStock


http://yunhq.sse.com.cn:32041/v1/sh1/line/600000?select=time,price,volume,avg_price,amount,highest,lowest&_=1703157469001

//新浪 日K
http://money.finance.sina.com.cn/quotes_service/api/json_v2.php/CN_MarketData.getKLineData?symbol=sh000977&scale=240&ma=5&datalen=5'


//查询上交所所有股票的基础信息
//http://yunhq.sse.com.cn:32041/v1/sh1/list/exchange/equity?select=code,name,open,high,low,last,prev_close,chg_rate,volume,amount,tradephase,change,amp_rate,cpxxsubtype,cpxxprodusta,tradephase
http://yunhq.sse.com.cn:32041/v1/sh1/list/exchange/equity?select=code,name,open,high,low,volume,last
//-------------查询指定股票的基础信息-------
//上交所
http://yunhq.sse.com.cn:32041/v1/sh1/snap/600089
//深交所
http://yunhq.sse.com.cn:32041/v1/sz1/snap/000002

http://yunhq.sse.com.cn:32041/v1/sh1/snap/600089?select=name

# 腾讯股票接口：
分时图
http://data.gtimg.cn/flashdata/hushen/minute/sz000001.js?maxage=110&0.28163905744440854

五天分时图
http://data.gtimg.cn/flashdata/hushen/4day/sz/sz000002.js?maxage=43200&visitDstTime=1

日k
http://data.gtimg.cn/flashdata/hushen/latest/daily/sz000002.js?maxage=43201&visitDstTime=1

指定年份的日K先
http://data.gtimg.cn/flashdata/hushen/daily/17/sz000750.js?visitDstTime=1

周K
http://data.gtimg.cn/flashdata/hushen/latest/weekly/sz000002.js?maxage=43201&visitDstTime=1

月k
http://data.gtimg.cn/flashdata/hushen/monthly/sz000002.js?maxage=43201

实时成交量明细
http://stock.gtimg.cn/data/index.php?appn=detail&action=data&c=sz002451&p=2
p为分页

大单数据
http://stock.finance.qq.com/sstock/list/view/dadan.php?t=js&c=sz002451&max=80&p=1&opt=10&o=0
opt=10 11 12 13 分别对应成交额大于等于（100万 200万 500万 1000万）
opt=1,2,3,4,5,6,7,8 分别对应成交量大于等于（100手 200手 300手 400手 500手 800手 1000手 1500手 2000手）

5分钟
http://ifzq.gtimg.cn/appstock/app/kline/mkline?param=sh600020,m5,,800&_var=m5_today
30分钟
http://ifzq.gtimg.cn/appstock/app/kline/mkline?param=sh600020,m30,,800&_var=m30_today
60分钟
http://ifzq.gtimg.cn/appstock/app/kline/mkline?param=sh600020,m60,,800&_var=m60_today
五日 只有收盘价和成交量
https://web.ifzq.gtimg.cn/appstock/app/day/query?code=sh600089
日数据 640为一年，如三年要640*3
http://web.ifzq.gtimg.cn/appstock/app/fqkline/get?_var=&param=sh600010,day,2013-01-01,2014-12-31,640,qfq
http://web.ifzq.gtimg.cn/appstock/app/fqkline/get?_var=kline_dayqfq2013&param=sh600020,day,2013-01-01,2014-12-31,640,qfq
周数据 128为一年，如三年要128*3
http://web.ifzq.gtimg.cn/appstock/app/fqkline/get?_var=kline_weekqfq2013&param=sh600020,week,2013-01-01,2014-12-31,320,qfq
月数据 12为一年，如三年要12*3
http://web.ifzq.gtimg.cn/appstock/app/fqkline/get?_var=kline_monthqfq2013&param=sh600020,month,2013-01-01,2014-12-31,12,qfq

和讯网股票接口：
日k（所有数据）
http://flashquote.stock.hexun.com/Quotejs/DA/1_601398_DA.html

指定时间区域的日k
http://webstock.quote.hermes.hexun.com/a/kline?code=sse601398&start=20170909150000&number=-1000&type=5&callback=callback

分时线
http://flashquote.stock.hexun.com/Quotejs/MA/1_000001_MA.html?

指定时间区域的分时线
http://webstock.quote.hermes.hexun.com/a/minute?code=sse600000&start=20170424000000&number=6000&callback=callback

明细接口
http://flashquote.stock.hexun.com/Stock_DL.ASPX?m=1&c=000001&t=0.6584310308098793

新浪股票接口：
最近二十天左右的每5分钟数据
http://money.finance.sina.com.cn/quotes_service/api/json_v2.php/CN_MarketData.getKLineData?symbol=sz000001&scale=5&ma=5&datalen=1023
（参数：股票编号、分钟间隔（5、15、30、60）、均值（5、10、15、20、25）、查询个数点（最大值242））

新浪关键词查询股票接口
http://suggest3.sinajs.cn/suggest/type=&key=60&name=suggestdata_1429775785401

查询股票最新行情
http://hq.sinajs.cn/list=sh601003,sh601001

返回结果如下：

var hq_str_sz002142="宁波银行,22.19,22.18,22.39,22.46,21.91,22.38,22.39,68778438,1527185943.73,674547,22.38,14600,22.37,3600,22.36,12700,22.35,2000,22.34,109847,22.39,255400,22.40,13100,22.41,35200,22.42,39200,22.43,2015-06-12,15:05:37,00";
今开，昨收，今收，最高，最低，成交量，成交额
var hq_str_sh601006="大秦铁路, 27.55, 27.25, 26.91, 27.55, 26.20, 26.91, 26.92,
22114263, 589824680, 4695, 26.91, 57590, 26.90, 14700, 26.89, 14300,
26.88, 15100, 26.87, 3100, 26.92, 8900, 26.93, 14230, 26.94, 25150, 26.95, 15220, 26.96, 2008-01-11, 15:05:32";
1
2
3
4
5
这个字符串由许多数据拼接在一起，不同含义的数据用逗号隔开了，按照程序员的思路，顺序号从0开始。
0：”大秦铁路”，股票名字；
1：”27.55″，今日开盘价；
2：”27.25″，昨日收盘价；
3：”26.91″，当前价格；
4：”27.55″，今日最高价；
5：”26.20″，今日最低价；
6：”26.91″，竞买价，即“买一”报价；
7：”26.92″，竞卖价，即“卖一”报价；
8：”22114263″，成交的股票数，由于股票交易以一百股为基本单位，所以在使用时，通常把该值除以一百；
9：”589824680″，成交金额，单位为“元”，为了一目了然，通常以“万元”为成交金额的单位，所以通常把该值除以一万；
10：”4695″，“买一”申请4695股，即47手；
11：”26.91″，“买一”报价；
12：”57590″，“买二”
13：”26.90″，“买二”
14：”14700″，“买三”
15：”26.89″，“买三”
16：”14300″，“买四”
17：”26.88″，“买四”
18：”15100″，“买五”
19：”26.87″，“买五”
20：”3100″，“卖一”申报3100股，即31手；
21：”26.92″，“卖一”报价
(22, 23), (24, 25), (26,27), (28, 29)分别为“卖二”至“卖四的情况”
30：”2008-01-11″，日期；
31：”15:05:32″，时间；

对于股票的K线图，日线图等的获取可以通过请求http://image.sinajs.cn/…./…/.gif此URL获取，其中代表股票代码，详见如下：
查看日K线图：
http://image.sinajs.cn/newchart/daily/n/sh601006.gif

分时线的查询：
http://image.sinajs.cn/newchart/min/n/sh000001.gif

日K线查询：
http://image.sinajs.cn/newchart/daily/n/sh000001.gif

周K线查询：
http://image.sinajs.cn/newchart/weekly/n/sh000001.gif

月K线查询：
http://image.sinajs.cn/newchart/monthly/n/sh000001.gif

网易的数据问题是只能提供不复权的数据，所以我们从网易提取流通市值和总市值，其他的从雪球提取，由于交易时段网易没有相关的接口来抓取流通市值和总市值，所以从腾讯接口提取实时的数据。

网易的接口是：
网易的数据格式为csv文件

日线

http://quotes.money.163.com/service/chddata.html?code=代码&start=开始时间&end=结束时间&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;TURNOVER;VOTURNOVER;VATURNOVER;TCAP;MCAP

参数说明：代码为股票代码，上海股票前加0，如600756变成0600756，深圳股票前加1。时间都是6位标识法，年月日，fields标识想要请求的数据。可以不变。

例如大盘指数数据查询（上证指数000001前加0，沪深300指数000300股票前加0，深证成指399001前加1，中小板指399005前加1，创业板指399006前加1）：
http://quotes.money.163.com/service/chddata.html?code=0000300&start=20151219&end=20171108&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;VOTURNOVER

上海股票数据查询（浪潮）：http://quotes.money.163.com/service/chddata.html?code=0600756&start=20160902&end=20171108&fields=TCLOSE;HIGH;LOW;TOPEN;LCLOSE;CHG;PCHG;VOTURNOVER;

雪球的接口是：
雪球网的数据格式是json字符串

https://xueqiu.com/stock/forchartk/stocklist.json?symbol=代码&period=1day&type=复权还是不复权&begin=开始时间时间戳&end=结束时间时间戳&_=结束时间时间戳

地址参数：上海股票在编号前加SH，深圳股票，在编号前加SZ，period代表的时间间隔，复权不复权使用after和before表示，开始时间和结束时间要用时间戳表示。

注意访问下面的网址前要先点击https://xueqiu.com/，进入一次官网，然后在http头中才能记录你的数据，然后才能通过下面的网址获取数据。

https://xueqiu.com/stock/forchartk/stocklist.json?symbol=SH600756&period=1day&type=before&begin=1478620800000&end=1510126200000&_=1510126200000
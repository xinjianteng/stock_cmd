/// 股票信息条目类，用于表示单个股票的信息
class StockInfoEntry {
  /// 股票名称
  String name;
  /// 股票代码
  String code;
  /// 当前价格
  double currentPrice;
  /// 昨日收盘价
  double yesterdayClosePrice;
  /// 今日开盘价
  double todayOpenPrice;
  /// 最高价格
  double highestPrice;
  /// 最低价格
  double lowestPrice;
  /// 成交量
  int volume;
  /// 成交额
  double turnover;
  // /// 收盘价
  // double closingPrice;
  ///换手率
  double turnoverRate;

  // 添加其他字段...

  /// 构造函数，用于创建股票信息对象
  /// 参数:
  ///   name: 股票名称
  ///   code: 股票代码
  ///   currentPrice: 当前价格
  ///   highestPrice: 最高价格
  ///   lowestPrice: 最低价格
  ///   volume: 成交量
  ///   turnover: 成交额
  ///   closingPrice: 收盘价
  ///   ...: 其他字段
  StockInfoEntry({
    required this.name,
    required this.code,
    required this.currentPrice,
    required this.yesterdayClosePrice,
    required this.todayOpenPrice,
    required this.highestPrice,
    required this.lowestPrice,
    required this.volume,
    required this.turnover,
    required this.turnoverRate,
    // 初始化其他字段...
  });

  // 添加计算涨幅的方法
  double calculateIncreaseRate() {
    if (yesterdayClosePrice == 0) {
      return 0; // 避免除以零的情况
    }
    return ((currentPrice - yesterdayClosePrice) / yesterdayClosePrice) * 100;
  }

  /// 从JSON数据（以列表形式）中解析并创建股票信息对象
  /// 参数:
  ///   parts: 包含股票信息的列表，索引对应股票信息字段
  factory StockInfoEntry.fromJson(List<String> parts) {
    return StockInfoEntry(
      name: parts[1],
      code: parts[2],

      currentPrice: double.parse(parts[3]),

      yesterdayClosePrice: double.parse(parts[4]),
      todayOpenPrice : double.parse(parts[5]),

      volume: int.parse(parts[6]),

      highestPrice: double.parse(parts[33]),
      lowestPrice: double.parse(parts[34]),

      turnover: double.parse(parts[37]),
      turnoverRate: double.parse(parts[38]),

    );
  }

  // 0	51	        1:沪A，51:深A
  // 1	永利股份	股票名称
  // 2	300230	    股票代码
  // 3	5.7	        当前价格
  // 4	5.52	    昨收
  // 5	5.49	    今开
  // 6	132876	    成交量（手）
  // 7	73161	    外盘
  // 8	59712	    内盘
  // 9	5.68	    买一
  // 10	911	        买一量（手）
  // 11	5.67	    买二
  // 12	1420	    买二量（手）
  // 13	5.66	    买三
  // 14	223	        买三量（手）
  // 15	5.65	    买四
  // 16	1121	    买四量（手）
  // 17	5.64	    买五
  // 18	653	        买五量（手）
  // 19	5.7	        卖一
  // 20	806	        卖一量（手）
  // 21	5.71	    卖二
  // 22	687	        卖二量（手）
  // 23	5.72	    卖三
  // 24	1042	    卖三量（手）
  // 25	5.73	    卖四
  // 26	954	        卖四量（手）
  // 27	5.74	    卖五
  // 28	1460	    卖五量（手）
  // 29	11:29:52/5.70/60/B/34146/4919|11:29:49/5.69/6/S/3414/4917	最近逐笔成交
  // 30	20181114113012	时间
  // 31	0.18	    涨跌
  // 32	3.26	    涨幅%
  // 33	5.73	    最高价
  // 34	5.46	    最低价
  // 35	5.70/132876/74586032	价格/成交量（手）/成交额
  // 36	132876	    成交量（手）
  // 37	7459	    成交额（万）
  // 38	2.46	    换手率%
  // 39	10.89	    市盈率(TTM)
  // 40
  // 41	5.73	    最高价
  // 42	5.46	    最低价
  // 43	4.89	    振幅%
  // 44	30.78	    流通市值(亿)
  // 45	46.52	    总市值
  // 46	1.52	    市净率
  // 47	6.07	    涨停价
  // 48	4.97	    跌停价
  // 49	2.41	    量比
  // 50	-621	    委差
  // 51	5.61	    未知
  // 52	9.88	    市盈率(动)
  // 53	15.93	    市盈率(静)



}

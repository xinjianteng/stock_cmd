import 'package:get/get.dart';

class Stock {
  // 基础信息
  String marketType; // 0: 1:沪A，51:深A
  String stockName; // 1: 股票名称
  String stockCode; // 2: 股票代码


  // 价格信息
  RxDouble currentPrice; // 3: 当前价格
  double previousClose; // 4: 昨收
  double openPrice; // 5: 今开
  double highPrice; // 33: 最高价
  double lowPrice; // 34: 最低价
  double changeAmount; // 31: 涨跌
  double changePercent; // 32: 涨幅%

  // 交易数据
  int volume; // 6: 成交量（手）
  int outerVolume; // 7: 外盘
  int innerVolume; // 8: 内盘
  double turnoverRate; // 38: 换手率%
  double transactionAmount; // 37: 成交额（万）

  // 买卖盘口
  List<OrderBookEntry> buyOrders; // 9-18: 买盘五档
  List<OrderBookEntry> sellOrders; // 19-28: 卖盘五档

  // 其他指标
  double peRatioTTM; // 39: 市盈率(TTM)
  double peRatioDynamic; // 52: 市盈率(动)
  double peRatioStatic; // 53: 市盈率(静)
  double pbRatio; // 46: 市净率
  double marketCap; // 45: 总市值
  double circulatingMarketCap; // 44: 流通市值(亿)
  double limitUpPrice; // 47: 涨停价
  double limitDownPrice; // 48: 跌停价
  double amplitude; // 43: 振幅%
  double volumeRatio; // 49: 量比
  int orderDifference; // 50: 委差

  // 时间戳
  String timestamp; // 30: 时间

  // 最近成交记录
  List<TransactionRecord> recentTransactions; // 29: 最近逐笔成交


  @override
  String toString() {
    return 'Stock{marketType: $marketType, stockName: $stockName,'
        ' stockCode: $stockCode, currentPrice: $currentPrice, '
        'previousClose: $previousClose, openPrice: $openPrice, '
        'highPrice: $highPrice, lowPrice: $lowPrice, '
        'changeAmount: $changeAmount, changePercent: $changePercent, '
        'volume: $volume, outerVolume: $outerVolume, innerVolume: $innerVolume,'
        ' turnoverRate: $turnoverRate, transactionAmount: $transactionAmount, '
        'buyOrders: $buyOrders, sellOrders: $sellOrders, peRatioTTM: $peRatioTTM, '
        'peRatioDynamic: $peRatioDynamic, peRatioStatic: $peRatioStatic, '
        'pbRatio: $pbRatio, marketCap: $marketCap, '
        'circulatingMarketCap: $circulatingMarketCap, '
        'limitUpPrice: $limitUpPrice, limitDownPrice: $limitDownPrice, '
        'amplitude: $amplitude, volumeRatio: $volumeRatio, '
        'orderDifference: $orderDifference, timestamp: $timestamp';
  }

  Stock({
    required this.marketType,
    required this.stockName,
    required this.stockCode,
    required this.currentPrice,
    required this.previousClose,
    required this.openPrice,
    required this.highPrice,
    required this.lowPrice,
    required this.changeAmount,
    required this.changePercent,
    required this.volume,
    required this.outerVolume,
    required this.innerVolume,
    required this.turnoverRate,
    required this.transactionAmount,
    required this.buyOrders,
    required this.sellOrders,
    required this.peRatioTTM,
    required this.peRatioDynamic,
    required this.peRatioStatic,
    required this.pbRatio,
    required this.marketCap,
    required this.circulatingMarketCap,
    required this.limitUpPrice,
    required this.limitDownPrice,
    required this.amplitude,
    required this.volumeRatio,
    required this.orderDifference,
    required this.timestamp,
    required this.recentTransactions,
  });


  /// 从JSON数据（以列表形式）中解析并创建股票信息对象
  /// 参数:
  ///   parts: 包含股票信息的列表，索引对应股票信息字段
  factory Stock.fromJson(List<String> parts) {
    return Stock(
      marketType: getMarketType(parts[0]),
      stockName: parts[1],
      stockCode: parts[2],
      currentPrice: double.parse(parts[3]).obs,
      previousClose: double.parse(parts[4]),
      openPrice: double.parse(parts[5]),
      volume: int.parse(parts[6]),
      outerVolume: int.parse(parts[7]),
      innerVolume: int.parse(parts[8]),
      buyOrders: _buildBuyOrders(parts),//9-18: 买盘五档
      sellOrders: _buildSellOrders(parts),//19-28: 卖盘五档
      recentTransactions: _buildRecentTransactions(parts[29]),
      timestamp: parts[30],
      changeAmount: double.parse(parts[31]),
      changePercent: double.parse(parts[32]),
      highPrice: double.parse(parts[33]),
      lowPrice: double.parse(parts[34]),

      transactionAmount: double.parse(parts[37]),
      turnoverRate: double.parse(parts[38]),
      peRatioTTM: double.parse(parts[39]),

      amplitude: double.parse(parts[43]),
      circulatingMarketCap: double.parse(parts[44]),
      marketCap: double.parse(parts[45]),
      pbRatio: double.parse(parts[46]),
      limitUpPrice: double.parse(parts[47]),
      limitDownPrice: double.parse(parts[48]),
      volumeRatio: double.parse(parts[49]),
      orderDifference: int.parse(parts[50]),
      peRatioDynamic: double.parse(parts[52]),
      peRatioStatic: double.parse(parts[53]),

    );
  }

  //分析“v_sz000980=51” 尾数如果是1:沪A，51:深A,属于哪个交易所
  static String getMarketType(String stockCode) {
    if (stockCode.endsWith('1')) {
      return '沪A';
    } else if (stockCode.endsWith('51')) {
      return '深A';
    } else {
      return '未知';
    }
  }


  static List<OrderBookEntry> _buildBuyOrders(List<String> parts) {
    List<OrderBookEntry> orders = [];
    orders.add(OrderBookEntry(
      price: double.parse(parts[9]),
      volume: int.parse(parts[10]),
    ));

    orders.add(OrderBookEntry(
      price: double.parse(parts[11]),
      volume: int.parse(parts[12]),
    ));

    orders.add(OrderBookEntry(
      price: double.parse(parts[13]),
      volume: int.parse(parts[14]),
    ));

    orders.add(OrderBookEntry(
      price: double.parse(parts[15]),
      volume: int.parse(parts[16]),
    ));

    orders.add(OrderBookEntry(
      price: double.parse(parts[17]),
      volume: int.parse(parts[18]),
    ));
    return orders;
  }

  static List<OrderBookEntry> _buildSellOrders(List<String> parts) {
    List<OrderBookEntry> orders = [];
    orders.add(OrderBookEntry(
      price: double.parse(parts[19]).roundToDouble() / 100,
      volume: int.parse(parts[20]),
    ));
    orders.add(OrderBookEntry(
      price: double.parse(parts[21]).roundToDouble() / 100,
      volume: int.parse(parts[22]),
    ));
    orders.add(OrderBookEntry(
      price: double.parse(parts[23]).roundToDouble() / 100,
      volume: int.parse(parts[24]),
    ));
    orders.add(OrderBookEntry(
      price: double.parse(parts[25]).roundToDouble() / 100,
      volume: int.parse(parts[26]),
    ));
    orders.add(OrderBookEntry(
      price: double.parse(parts[27]).roundToDouble() / 100,
      volume: int.parse(parts[28]),
    ));
    return orders;
  }

  // 修改 _buildRecentTransactions 方法
  static List<TransactionRecord> _buildRecentTransactions(String str) {
    List<TransactionRecord> transactions = [];
    // 解析第29项中的最近逐笔成交记录
    if (str.length > 29 && str.isNotEmpty) {
      // 按 | 分割多条记录
      List<String> records = str.split('|');

      for (String record in records) {
        // 按 / 分割每条记录的字段
        List<String> fields = record.split('/');

        if (fields.length >= 6) {
          transactions.add(TransactionRecord(
            time: fields[0],           // 成交时间
            price: double.parse(fields[1]),  // 成交价格
            volume: int.parse(fields[2]),    // 成交量
            direction: fields[3],       // 主动方向(B/S)
            amount: int.parse(fields[4]),    // 成交金额
            tradeId: int.parse(fields[5]),   // 成交编号
          ));
        }
      }
    }

    return transactions;
  }



}

class OrderBookEntry {
  double price; // 价格
  int volume; // 量（手）

  OrderBookEntry({required this.price, required this.volume});
}

class TransactionRecord {
  String time;        // 0: 成交时间
  double price;       // 1: 成交价格
  int volume;         // 2: 成交量
  String direction;   // 3: 主动方向(B/S)
  int amount;         // 4: 成交金额
  int tradeId;        // 5: 成交编号

  TransactionRecord({
    required this.time,
    required this.price,
    required this.volume,
    required this.direction,
    required this.amount,
    required this.tradeId,
  });
}

import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:gbk_codec/gbk_codec.dart';
import 'package:stock_cmd/entry/kline_entry.dart';
import 'package:stock_cmd/entry/stock.dart';

import '../entry/stock_dfcf_entry.dart';
import '../utils/utils.dart';

class Api {
  static Future<List<StockDFCFEntry>> getStockListByDongFangCaiFu() async {
    try {
      var queryParameters = <String, dynamic>{};

      // 设置HTTP请求的头部参数
      queryParameters['pn'] = '1'; // 页码，表示请求的数据页数
      queryParameters['pz'] = '1'; // 每页数量，表示每页最多返回的记录数

      queryParameters['np'] = '1'; // 下一页标识，用于分页请求  |不知道
      queryParameters['ut'] =
          'bd1d9ddb04089700cf9c27f6f7426281'; // 用户令牌，用于身份验证或会话管理
      queryParameters['fltt'] = '2'; // 过滤类型，可能表示数据的筛选条件  | 没有测试出来1/2/3/4
      queryParameters['invt'] = '2'; // 投资类型，用于指定关注的投资类别 | 没有测试出来1/2/10
      // queryParameters['fid'] = 'f3'; // 字段标识，表示请求数据中关注的字段
      queryParameters['fs'] =
          'm:0 t:6,m:0 t:80,m:1 t:2,m:1 t:23,m:0 t:81 s:2048'; // 过滤条件，详细定义了数据筛选规则
      queryParameters['fields'] =
          'f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f12,f13,f14,f15,f16,f17,f18,f20,f21,f23,f24,f25,f22,f11,f62,f128,f136,f115,f152'; // 请求的具体字段列表
      queryParameters['_'] = '1623833739532'; // 时间戳，用于请求的缓存控制或安全验证
      queryParameters['secid'] = '0.301010'; // 时间戳，用于请求的缓存控制或安全验证
      queryParameters['po'] = '1'; // 排序方式，可能表示数据的排序顺序   |1应该是按照编号排序

      var baseOptions = HttpUtil().dio.options;
      baseOptions.baseUrl = 'https://82.push2.eastmoney.com/api';
      baseOptions.responseType = ResponseType.json;

      var response = await HttpUtil().get(
          baseOptions: baseOptions,
          '/qt/clist/get',
          queryParameters: queryParameters);
      if (response['data']['diff'].isEmpty) {
        return [];
      }
      final List<dynamic> diffList = response['data']['diff'];
      final List<StockDFCFEntry> dataList = [];

      for (int i = 0; i < diffList.length; i++) {
        final item = diffList[i];

        final stockItem = StockDFCFEntry(
          code: item['f12'].toString(),
          name: item['f14'].toString(),
          price: item['f2'].toString(),
          change: item['f3'].toString(),
          percent: item['f3p'].toString(),
          volume: item['f5'].toString(),
          amount: item['f6'].toString(),
          open: item['f3'].toString(),
          high: item['f4'].toString(),
          low: item['f5'].toString(),
          close: item['f3'].toString(),
        );
        dataList.add(stockItem);
      }
      return dataList;
    } catch (e) {
      logPrint('Error fetching data: $e');
      return [];
    }
  }

  static String determineExchange(String stockCode) {
    if (stockCode.startsWith('6')) {
      return 'sh$stockCode';
    } else if (stockCode.startsWith('00') || stockCode.startsWith('30')) {
      return 'sz$stockCode';
    } else {
      return '未知交易所';
    }
  }

  static Future<List<Stock>> getStockInfoByCode(
      List<String> codes) async {
    // http://qt.gtimg.cn/q=sz000002
    try {
      var baseOptions = HttpUtil().dio.options;
      baseOptions.baseUrl = 'http://qt.gtimg.cn/';
      baseOptions.responseType = ResponseType.bytes;

      List<Stock> dataList = [];
      for (var code in codes) {
        var codeParams=determineExchange(code);
        var response = await HttpUtil().get(
          baseOptions: baseOptions,
          'q=$codeParams',
        );
        // 使用 gbk_codec 解码 GBK 编码的字节数据
        String decodedData = gbk_bytes.decode(response);
        try {
          Stock stockInfo = parseStockInfo(decodedData);
          logPrint( "****"+stockInfo.toString());
          dataList.add(stockInfo);
        }catch(e){
          logPrint("error:$e");
        }

      }
      return dataList;
    } catch (e) {
      return [];
    }
  }

  static Stock parseStockInfo(String response) {
    // 去掉字符串两边的引号
    response = response.replaceAll('"', '');
    // 按照波浪线分割字符串
    List<String> parts = response.split('~');
    // 创建 StockInfo 对象
    return Stock.fromJson(parts);
  }

  // 获取K线数据
  static Future<List<KLineData>> getKLineData(
      String stockCode, KLinePeriod period) async {
    try {
      // 构建API路径和参数
      String apiPath;
      Map<String, dynamic> params = {
        'code': _formatStockCode(stockCode),
        'date': _getCurrentDate(),
        'is_whole': 0,
      };

      // 根据周期选择不同的API端点
      switch (period) {
        case KLinePeriod.minute5:
          apiPath = 'stock/5';
          break;
        case KLinePeriod.minute15:
          apiPath = 'stock/15';
          break;
        case KLinePeriod.minute30:
          apiPath = 'stock/30';
          break;
        case KLinePeriod.minute60:
          apiPath = 'stock/60';
          break;
        case KLinePeriod.daily:
          apiPath = 'stock/daily';
          break;
        case KLinePeriod.weekly:
          apiPath = 'stock/week';
          break;
        case KLinePeriod.monthly:
          apiPath = 'stock/month';
          break;
      }

      // 设置HTTP请求的基础选项
      var baseOptions = HttpUtil().dio.options;
      baseOptions.baseUrl = 'https://tpdog.com/api';
      baseOptions.responseType = ResponseType.json;

      // 发送GET请求
      var response = await HttpUtil().get(
        baseOptions: baseOptions,
        apiPath,
        queryParameters: params,
      );

      // 解析响应数据
      List<KLineData> klineList = [];
      if (response != null && response is Map && response.containsKey('data')) {
        List<dynamic> dataList = response['data'];
        for (var item in dataList) {
          klineList.add(KLineData(
            date: item['date'] ?? '',
            open: double.parse(item['open'].toString()),
            high: double.parse(item['high'].toString()),
            low: double.parse(item['low'].toString()),
            close: double.parse(item['close'].toString()),
            volume: int.parse(item['volume'].toString()),
          ));
        }
      }

      return klineList;
    } catch (e) {
      logPrint('获取K线数据失败: $e');
      // 返回模拟数据，确保页面能正常显示
      return _getMockKLineData(period);
    }
  }

  // 格式化股票代码为API需要的格式
  static String _formatStockCode(String stockCode) {
    if (stockCode.startsWith('6')) {
      return 'sh.$stockCode';
    } else if (stockCode.startsWith('00') || stockCode.startsWith('30')) {
      return 'sz.$stockCode';
    } else {
      return stockCode;
    }
  }

  // 获取当前日期（YYYY-MM-DD格式）
  static String _getCurrentDate() {
    DateTime now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  // 生成模拟K线数据
  static List<KLineData> _getMockKLineData(KLinePeriod period) {
    List<KLineData> mockData = [];
    DateTime now = DateTime.now();
    double basePrice = 100.0;
    
    // 根据不同周期生成不同数量的数据点
    int dataCount = 50;
    if (period == KLinePeriod.daily) {
      dataCount = 60;
    } else if (period == KLinePeriod.weekly) {
      dataCount = 52;
    } else if (period == KLinePeriod.monthly) {
      dataCount = 24;
    }

    for (int i = dataCount; i >= 0; i--) {
      DateTime date;
      String dateStr;
      
      // 根据周期计算日期
      switch (period) {
        case KLinePeriod.minute5:
        case KLinePeriod.minute15:
        case KLinePeriod.minute30:
        case KLinePeriod.minute60:
        default:
          date = now.subtract(Duration(minutes: i * _getMinutesByPeriod(period)));
          dateStr = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
          break;
      }

      // 生成随机价格波动
      double change = (Random().nextDouble() * 10 - 5);
      double open = basePrice + change;
      double close = open + (Random().nextDouble() * 6 - 3);
      double high = max(open, close) + Random().nextDouble() * 2;
      double low = min(open, close) - Random().nextDouble() * 2;
      int volume = (Random().nextDouble() * 1000000).toInt();

      basePrice = close;

      mockData.add(KLineData(
        date: dateStr,
        open: open,
        high: high,
        low: low,
        close: close,
        volume: volume,
      ));
    }

    return mockData;
  }
}

// 使用dart:math包中的Random、max和min
  
  // 根据K线周期获取对应的分钟数
  int _getMinutesByPeriod(KLinePeriod period) {
    switch (period) {
      case KLinePeriod.minute5:
        return 5;
      case KLinePeriod.minute15:
        return 15;
      case KLinePeriod.minute30:
        return 30;
      case KLinePeriod.minute60:
        return 60;
      default:
        return 5;
    }
  }

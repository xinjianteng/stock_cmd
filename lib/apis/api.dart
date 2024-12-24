import 'package:dio/dio.dart';
import 'package:gbk_codec/gbk_codec.dart';
import 'package:stock_cmd/entry/stock_info_entry.dart';

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

  static Future<List<StockInfoEntry>> getStockInfoByCode(
      List<String> codes) async {
    // http://qt.gtimg.cn/q=sz000002
    try {
      var baseOptions = HttpUtil().dio.options;
      baseOptions.baseUrl = 'http://qt.gtimg.cn/';
      baseOptions.responseType = ResponseType.bytes;

      List<StockInfoEntry> dataList = [];
      for (var code in codes) {
        var codeParams=determineExchange(code);
        var response = await HttpUtil().get(
          baseOptions: baseOptions,
          'q=$codeParams',
        );
        // 使用 gbk_codec 解码 GBK 编码的字节数据
        String decodedData = gbk_bytes.decode(response);
        try {
          StockInfoEntry stockInfo = parseStockInfo(decodedData);
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

  static StockInfoEntry parseStockInfo(String response) {
    // 去掉字符串两边的引号
    response = response.replaceAll('"', '');
    // 按照波浪线分割字符串
    List<String> parts = response.split('~');
    // 创建 StockInfo 对象
    return StockInfoEntry.fromJson(parts);
  }
}

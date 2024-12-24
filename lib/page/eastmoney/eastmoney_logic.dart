import 'package:get/get.dart';
import 'package:stock_cmd/utils/utils.dart';

import '../../apis/api.dart';
import '../../entry/stock_dfcf_entry.dart';

class EastmoneyLogic extends GetxController {
  RxList<StockDFCFEntry> stockDFEntries = <StockDFCFEntry>[].obs;


  @override
  void onInit() {
    // TODO: implement onInit
    logPrint('EastmoneyLogic'+' onInit');
    super.onInit();
  }

   @override
  void onReady() {
    // TODO: implement onReady
     logPrint('EastmoneyLogic'+' onReady');
    super.onReady();

  }

   @override
  void onClose() {
    // TODO: implement onClose
     logPrint('EastmoneyLogic'+' onClose');
     super.onClose();
  }


  void reqAllStockListByDongFangCaiFuHost(String value) async {
    stockDFEntries.clear();
    var response = await Api.getStockListByDongFangCaiFu();
    stockDFEntries.addAll(response);
    update();
  }

  //
  // 个股板块
  // https://tpdog.com/api/board/get?code=sz.000001
  // 交易日查询
  // https://tpdog.com/api/trading_day/is?date=2024-02-05
  // 秒级实时
  // https://tpdog.com/api/current/second?code=sz.000001&sort=2&pagesize=100
  // 分钟实时
  // https://tpdog.com/api/current/minute?code=sz.000001&sort=2&pagesize=100
  // 秒级历史
  // https://tpdog.com/api/his/second?code=sz.000001&sort=1&pagesize=100&date=2024-02-05
  // 分钟历史
  // https://tpdog.com/api/his/minute?code=sz.000001&sort=1&pagesize=100&date=2024-02-05
  // 集合竞价
  // https://tpdog.com/api/current/call_auction?code=sh.600206&sort=2
  // MACD异同移动平均线
  // https://tpdog.com/api/indicator/macd?code=sz.000001&period=1&type=1&macd_long=26&macd_short=12&macd_mid=9&date=2024-02-05&is_whole=0
  // MA移动平均线
  // https://tpdog.com/api/indicator/ma?code=sz.000001&period=1&type=1&date=2024-02-05&ma_days=5,10&is_whole=0
  // BOLL布林线指标
  // https://tpdog.com/api/indicator/boll?code=sz.000001&period=1&type=1&date=2024-02-05&boll_day=20&is_whole=0
  // CCI顺势指标
  // https://https://www.tpdog.com/api/indicator/cci?code=sz.000001&period=1&type=1&date=2024-02-05&cci_day=14&is_whole=0
  // EXPMA指数平均数指标
  // https://tpdog.com/api/indicator/expma?code=sz.000001&period=1&type=1&date=2024-02-05&expma_short=12&expma_long=50&is_whole=0
  // KDJ随机指标
  // https://tpdog.com/api/indicator/kdj?code=sz.000001&period=1&type=1&date=2024-02-05&kdj_day=9&is_whole=0
  // RSI强弱指标
  // https://tpdog.com/api/indicator/rsi?code=sz.000001&period=1&type=1&date=2024-02-05&rsi1=6&rsi2=12&rsi3=24&is_whole=0
  // W&R威廉指标
  // https://tpdog.com/api/indicator/wr?code=sz.000001&period=1&type=1&date=2024-02-05&wr_short=6&wr_long=10&is_whole=0
  // BIAS乖离率
  // https://tpdog.com/api/indicator/bias?code=sz.000001&period=1&type=1&is_whole=0&bias_day1=6&bias_day2=12&bias_day3=24&date=2024-02-05
  // V_MA量均线
  // https://tpdog.com/api/indicator/volume_ma?code=sz.000001&period=10&type=1&date=2024-02-05&volume_ma_days=5,10&is_whole=0
  // MTM动量指标
  // https://tpdog.com/api/indicator/mtm?code=sz.000001&period=1&type=1&date=2024-02-05&mtm_day=12&mtm_ma_day=6
  // BBI多空指标
  // https://tpdog.com/api/indicator/bbi?code=sz.000001&period=1&type=1&date=2024-02-05&bbi_day1=3&bbi_day2=6&bbi_day3=12&bbi_day4=24
  // LWR威廉指标
  // https://tpdog.com/api/indicator/lwr?code=sz.000001&period=1&type=1&date=2024-02-05&lwr_day=9
  // ENE轨道线
  // https://tpdog.com/api/indicator/ene?code=sz.000001&ene_day=10&ene_m1=11&ene_m2=9&date=2024-02-05&type=1&is_whole=0
  // 龙虎榜
  // https://tpdog.com/api/board/bill?date=2024-02-05
  // 个股龙虎榜历史
  // https://tpdog.com/api/board/bill_info?start=2024-01-11&end=2024-02-05&code=sz.000001
  //
  // 涨停股池
  // https://tpdog.com/api/pool/limitup/list?date=2024-02-05
  // 跌停股池
  // https://tpdog.com/api/pool/limitdown/list?date=2024-02-05
  // 强势股池
  // https://tpdog.com/api/pool/strong/list?date=2024-02-05
  // 炸板股池
  // https://tpdog.com/api/pool/fire/list?date=2024-02-05
  // 次新股池
  // https://tpdog.com/api/pool/secnew/list?date=2024-02-05
  // 日K数据
  // tpdog.com/api/stock/daily?code=sz.000001&date=2024-02-05
  // 周K数据
  // https://tpdog.com/api/stock/week?code=sz.000001&date=2024-02-05&is_whole=0
  // 月K数据
  // https://tpdog.com/api/stock/month?code=sz.000001&date=2024-02-05&is_whole=0
  // 季K数据
  // https://tpdog.com/api/stock/quarter?code=sz.000001&date=2024-02-05&is_whole=0
  // 半年K数据
  // https://tpdog.com/api/stock/half?code=sz.000001&date=2024-02-05&is_whole=0
  // 年K数据
  // https://tpdog.com/api/stock/year?code=sz.000001&date=2024-02-05&is_whole=0
  // 日K历史
  // https://tpdog.com/api/stock_his/daily?code=sz.000001&start=2023-05-01&end=2023-05-30
  // 周K历史
  // https://tpdog.com/api/stock_his/week?code=sz.000001&start=2023-01-01&end=2023-04-30&is_whole=0
  // 月K历史
  // https://tpdog.com/api/stock_his/month?code=sz.000001&start=2023-01-01&end=2023-04-30&is_whole=0
  // 季K历史
  // https://tpdog.com/api/stock_his/quarter?code=sz.000001&start=2021-01-01&end=2022-12-31&is_whole=0
  // 半年K历史
  // https://tpdog.com/api/stock_his/half?code=sz.000001&start=2021-01-01&end=2022-12-31&is_whole=0
  // 年K历史
  // https://tpdog.com/api/stock_his/year?code=sz.000001&start=2021-01-01&end=2022-12-31&is_whole=0
  // 5分钟级别
  // https://tpdog.com/api/stock/5?code=sz.000001&date=2024-02-05
  // 15分钟级别
  // https://tpdog.com/api/stock/15?code=sz.000001&date=2024-02-05
  // 30分钟级别
  // https://tpdog.com/api/stock/30?code=sz.000001&date=2024-02-05
  // 60分钟级别
  // https://tpdog.com/api/stock/60?code=sz.000001&date=2024-02-05
  // 120分钟级别
  // https://tpdog.com/api/stock/120?code=sz.000001&date=2024-02-05
  // 异动类型汇总
  // https://tpdog.com/api/unusual/types
  // 实时异动
  // https://tpdog.com/api/unusual/get?un_type=18
  // 历史异动
  // https://https://tpdog.com/api/unusual/his?date=2024-02-05&un_type=18
  // 涨跌分布
  // https://tpdog.com/api/current/distribution
  // ————————————————
  //
  // 版权声明：本文为博主原创文章，遵循 CC 4.0 BY-SA 版权协议，转载请附上原文出处链接和本声明。
  //
  // 原文链接：https://blog.csdn.net/u010614946/article/details/136053893
}

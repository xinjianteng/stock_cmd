import 'package:get/get.dart';
import 'package:stock_cmd/apis/api.dart';
import 'package:stock_cmd/entry/kline_entry.dart';
import 'package:stock_cmd/entry/stock.dart';
import 'package:stock_cmd/utils/utils.dart';

class StockDetailLogic extends GetxController {
  // 股票信息
  final Rx<Stock?> stockInfo = Rx<Stock?>(null);
  // 股票代码
  final String stockCode;
  // 股票名称
  final String stockName;
  // K线数据
  final RxList<KLineData> klineDataList = RxList<KLineData>([]);
  // 当前K线周期
  final Rx<KLinePeriod> currentPeriod = Rx<KLinePeriod>(KLinePeriod.minute5);
  // 是否正在加载
  final RxBool isLoading = false.obs;
  // 错误信息
  final RxString errorMsg = RxString('');

  StockDetailLogic({required this.stockCode, required this.stockName});

  @override
  void onInit() {
    super.onInit();
    logPrint('StockDetailLogic onInit, code: $stockCode, name: $stockName');
    // 初始化时加载股票信息和K线数据
    _loadStockInfo();
    _loadKLineData();
  }

  @override
  void onClose() {
    logPrint('StockDetailLogic onClose');
    super.onClose();
  }

  // 加载股票基本信息
  Future<void> _loadStockInfo() async {
    try {
      List<Stock> stocks = await Api.getStockInfoByCode([stockCode]);
      if (stocks.isNotEmpty) {
        stockInfo.value = stocks.first;
      }
    } catch (e) {
      logPrint('加载股票信息失败: $e');
    }
  }

  // 加载K线数据
  Future<void> _loadKLineData() async {
    isLoading.value = true;
    errorMsg.value = '';
    
    try {
      logPrint('加载${currentPeriod.value.name} K线数据，股票代码: $stockCode');
      List<KLineData> data = await Api.getKLineData(stockCode, currentPeriod.value);
      klineDataList.assignAll(data);
      logPrint('K线数据加载成功，数据量: ${data.length}');
    } catch (e) {
      logPrint('加载K线数据失败: $e');
      errorMsg.value = '加载数据失败，请稍后重试';
    } finally {
      isLoading.value = false;
    }
  }

  // 切换K线周期
  void switchPeriod(KLinePeriod period) {
    if (currentPeriod.value != period) {
      currentPeriod.value = period;
      _loadKLineData();
    }
  }

  // 刷新数据
  Future<void> refreshData() async {
    await _loadStockInfo();
    await _loadKLineData();
  }

  // 获取所有支持的K线周期
  List<KLinePeriod> getAllPeriods() {
    return KLinePeriod.values;
  }
}
import 'package:flutter/widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:stock_cmd/entry/stock.dart';
import 'package:stock_cmd/utils/logger_util.dart';
import 'package:stock_cmd/utils/prefs_util.dart';

import '../../apis/api.dart';

class HomeLogic extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  // RxList<StockInfoEntry> stockEntrys = <StockInfoEntry>[].obs;

  RxList<Stock> stocks = <Stock>[].obs;

  String inputText = "";



  @override
  void onInit() {
    logPrint("HomeLogic  onInit");
    super.onInit();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 800),
    )..repeat(reverse: true);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);


  }

  @override
  void onReady() {
    logPrint("HomeLogic  onReady");
    super.onReady();
    requestByCode();
  }

  @override
  void onClose() {
    logPrint("HomeLogic  onClose");
    controller.dispose();
    super.onClose();
  }

  void requestByCode() async {
    stocks.clear();
    var stockCodes = PrefsUtil().stockCodes;
    List<String> stockCodesList = stockCodes.split(",");
    // 去重
    stockCodesList = stockCodesList.toSet().toList();

    if (stockCodesList.isNotEmpty) {
      var response = await Api.getStockInfoByCode(stockCodesList);

      stocks.addAll(response);
    }
    update();
  }

  void addStock(String value) {
// 使用正则表达式校验股票代码
    RegExp regex = RegExp(r'^(6|0|3)\d{5}$');
    if (!regex.hasMatch(value)) {
      SmartDialog.showToast("无效的股票代码");
    } else {
      var stockCodes = PrefsUtil().stockCodes;
      stockCodes = "$stockCodes,$value";
      PrefsUtil().updateStockCodes(stockCodes);
      requestByCode();
    }
  }

  void cleanStock() {
    PrefsUtil().updateStockCodes('');
    stocks.clear();
    update();
  }



  void delStockByCode(String code) {
    var stockCodes = PrefsUtil().stockCodes;
    stockCodes = stockCodes.replaceAll("$code,", "");
    PrefsUtil().updateStockCodes(stockCodes);
    requestByCode();
    update();
  }

}

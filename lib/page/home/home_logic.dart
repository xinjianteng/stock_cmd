import 'dart:convert';

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
  late List<String> stockCodesList = [];

  @override
  void onInit() {
    logPrint("HomeLogic  onInit");
    super.onInit();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 800),
    )..repeat(reverse: true);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    getStockCodes();
  }

  void getStockCodes() {
    String stockCodes = PrefsUtil().stockCodes;
    stockCodesList =
        stockCodes.split(",").where((code) => code.isNotEmpty).toSet().toList();
    stockCodesList = stockCodesList.toSet().toList();
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
    if (stockCodesList.isNotEmpty) {
      List<Stock> response = await Api.getStockInfoByCode(stockCodesList);

      ///如果stocks里面的stockCode等于response的stockCode则替换,否则添加
      // 遍历响应数据，更新或添加股票信息
      for (Stock newStock in response) {
        // 查找是否已存在相同股票代码的股票
        int existingIndex =
            stocks.indexWhere((stock) => stock.stockCode == newStock.stockCode);
        if (existingIndex != -1) {
          // 如果存在，则更新该股票信息
          stocks[existingIndex] = newStock;
        } else {
          // 如果不存在，则添加新股票
          stocks.add(newStock);
        }
      }
    }
    update();
  }

  void addStock(String value) {
    List<String> values = value.split('/').map((e) => e.trim()).toList();
    List<String> errorCodes = [];
    List<String> successCodes = [];

    for (String code in values) {
      if (!stockCodesList.contains(code)) {
        RegExp regex = RegExp(r'^(6|0|3)\d{5}$');
        if (!regex.hasMatch(code)) {
          errorCodes.add(code);
        } else {
          successCodes.add(code);
          stockCodesList.add(code);
        }
      }
    }
    PrefsUtil().updateStockCodes(jsonEncode(stockCodesList));
    requestByCode();
    Get.showSnackbar(
      GetSnackBar(
        title: '提示',
        message:
            '添加成功：${successCodes.join(', ')}\n添加失败：${errorCodes.join(', ')}',
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void cleanStock() {
    PrefsUtil().updateStockCodes('');
    stockCodesList.clear();
    stocks.clear();
    update();
  }

  void delStockByCode(String code) {
    stocks.removeWhere((element) => element.stockCode == code);
    stockCodesList.removeWhere((element) => element == code);
    PrefsUtil().updateStockCodes(jsonEncode(stockCodesList));
    requestByCode();
    update();
  }
}

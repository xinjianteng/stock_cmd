import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:stock_cmd/utils/logger_util.dart';
import 'package:stock_cmd/utils/prefs_util.dart';

import '../../apis/api.dart';
import '../../entry/stock_info_entry.dart';

class HomeLogic extends GetxController with GetSingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;

  RxList<StockInfoEntry> stockEntrys = <StockInfoEntry>[].obs;

  String inputText = "";

  final List<String> columns = [
    '名称',
    '代码',
    '涨幅',
    '当前',
    '昨收',
    '今开',
    '最高',
    '最低',
    '成交量（万手）',
    '成交额（亿）',
    '换手率',
    '=',
  ];

  RxDouble fontSize= 12.0.obs;
  RxDouble cellWidth= (ScreenUtil().screenWidth/12).obs;

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
    stockEntrys.clear();
    var stockCodes = PrefsUtil().stockCodes;
    List<String> stockCodesList = stockCodes.split(",");
    // 去重
    stockCodesList = stockCodesList.toSet().toList();

    if (stockCodesList.isNotEmpty) {
      var response = await Api.getStockInfoByCode(stockCodesList);
      stockEntrys.addAll(response);
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
    stockEntrys.clear();
    update();
  }

  void addFontSize(){
    if(cellWidth.value * (fontSize.value / 14.0)>=cellWidth.value ){
      SmartDialog.showToast("不能再大了");
      return;
    }else{
      fontSize.value += 2;
      update();
    }


  }

  void reduceFontSize(){
    if(fontSize.value<=2){
      SmartDialog.showToast("不能再小了");
      return;
    }else{
      fontSize.value -= 2;
      update();
    }

  }

  void delStockByCode(String code) {
    var stockCodes = PrefsUtil().stockCodes;
    stockCodes = stockCodes.replaceAll("$code,", "");
    PrefsUtil().updateStockCodes(stockCodes);
    requestByCode();
    update();
  }

}

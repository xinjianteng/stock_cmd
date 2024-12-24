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
}

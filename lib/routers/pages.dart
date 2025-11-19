import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../page/eastmoney/eastmoney_view.dart';
import '../page/home/home_view.dart';
import '../page/stock_detail/stock_detail_view.dart';
import '../page/eastmoney/eastmoney_logic.dart';
import '../page/home/home_logic.dart';
import '../page/stock_detail/stock_detail_logic.dart';
import 'routes.dart';

class AppPages {
  // ignore: constant_identifier_names
  static final RouteObserver<Route> observer = RouteObservers();
  static List<String> history = [];

  ///别名映射页面
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      transition: Transition.zoom,
      middlewares: [],
    ),

    GetPage(
      name: AppRoutes.dongfangcaifu,
      page: () => const EastmoneyPage(),
      transition: Transition.zoom,
      middlewares: [],
    ),
    
    GetPage(
      name: AppRoutes.stockDetail,
      page: () => const StockDetailView(),
      binding: BindingsBuilder(() {
        // 使用工厂函数动态创建控制器，传入股票代码和名称参数
        Get.lazyPut<StockDetailLogic>(() {
          final String stockCode = Get.parameters['code'] ?? '';
          final String stockName = Get.parameters['name'] ?? '';
          return StockDetailLogic(stockCode: stockCode, stockName: stockName);
        });
      }),
      transition: Transition.zoom,
      middlewares: [],
    ),
  ];
}

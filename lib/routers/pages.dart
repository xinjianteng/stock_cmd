import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../page/pages.dart';
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
  ];
}

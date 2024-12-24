import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';
import '../routes.dart';


/// 第一次欢迎页面
class RouteWelcomeMiddleware extends GetMiddleware {
  // priority 数字小优先级高
  @override
  int? priority = 0;

  RouteWelcomeMiddleware({required this.priority});

  @override
  RouteSettings? redirect(String? route) {

    if (PrefsUtil().isFirstOpen == true) {
      return null;
    } else {
      return const RouteSettings(name: AppRoutes.home);
    }

  }
}

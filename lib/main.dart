import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:stock_cmd/utils/logger_util.dart';

import 'init_app.dart';
import 'routers/routes.dart';
import 'values/values.dart';

Future<void> main() async {
  try {
    await initApp();
    runApp(const MyApp());
  } catch (e) {

    Get.snackbar('警告', '应用初始化失败，请稍后再试。');
    // 记录日志
    logPrint("Initialization failed: $e");

  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: AppDimens.deviceSize,
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            initialRoute: AppRoutes.home,
            getPages: AppPages.routes,
            builder: FlutterSmartDialog.init(),
          );
        });
  }
}

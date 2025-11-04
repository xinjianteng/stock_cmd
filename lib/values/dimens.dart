import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/utils.dart';

class AppDimens {
  static Size deviceSize = Size(
    desktopWidth,
    desktopHeight,
  );

  static double desktopWidth = 1002.0;
  static double desktopHeight = 709.0;



  static double margin = 17;

  static double btnWidthNor = GetPlatform.isMobile ? 72.w : 72;
  static double btnHeightNor = GetPlatform.isMobile ? 20.w : 20;

  static double btnWidthMax = GetPlatform.isMobile ? 343.w : 72;
  static double btnHeightMax = GetPlatform.isMobile ? 40.h : 40;

  static double btnFontMin = GetPlatform.isMobile ? 12.sp : 12;
  static double btnFontNor = 14.sp;
  static double btnFontMax = GetPlatform.isMobile ? 16.sp : 8.sp;

  static double btnRadiusMin = GetPlatform.isMobile ? 4.r : 4;
  static double btnRadiusNor = 16.r;
  static double btnRadiusMax = 22.r;


  static double imageWidth = GetPlatform.isMobile ? 100.w : 100;

  static double getStatusBarHeight() {
    // 添加了try-catch来处理可能的异常
    try {
      return ScreenUtil().statusBarHeight;
    } catch (e) {
      print("Error getting status bar height: $e");
      return 0.0; // 提供一个默认值
    }
  }
}

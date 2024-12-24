import 'package:flutter/material.dart';

import 'colors.dart';

class AppStyles {
 static TextStyle buildBtnStyle() {
    return const TextStyle(
      fontSize: 14,
      color: AppColors.white,
    );
  }


  static ButtonStyle buildTextBtnStyle() {
    return TextButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1.0),
      ),
      side: const BorderSide(color: Colors.grey, width: 0.2),
      shadowColor: Colors.red,
    );
  }
}

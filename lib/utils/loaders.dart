import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hope_project/common/globals.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class Loaders {
  // ! Toasts
  static successToast(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  static exceptionToast(String msg) {
    if (kDebugMode) {
      Fluttertoast.showToast(msg: msg);
    }
  }

  static errorToast(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  // ! SnackBars
  static successSnackBar({required String title, message = '', duration = 3}) {
    Get.snackbar(
      title,
      message,
      duration: Duration(seconds: duration),
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: mainColor,
      icon: const Icon(Symbols.check, color: Colors.white),
    );
  }

  static warningSnackBar({
    required String title,
    message = '',
  }) {
    Get.snackbar(
      title,
      message,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: Colors.orange,
      icon: const Icon(Symbols.check, color: Colors.white),
    );
  }
}

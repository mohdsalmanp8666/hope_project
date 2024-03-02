import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hope_project/common/globals.dart';

class FullScreenLoader {
  // * Loading Dialogue Open
  static void openLoadingDialogue(String text) {
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      barrierColor: Colors.grey.withOpacity(0.5),
      builder: (_) => PopScope(
        canPop: false,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 150),
          // color: Colors.white,
          child: customLoadingAnimation(),
        ),
      ),
    );
  }

  // * Loading Dialogue Close
  static void closeLoadingDialogue() {
    Get.back();
  }
}

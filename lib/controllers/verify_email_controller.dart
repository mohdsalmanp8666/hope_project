import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

  final _isVerified = false.obs;
  bool get isVerified => _isVerified.value;
  set isVerified(value) => _isVerified.value = value;

// * Send email whenever Verify Screen appears& set Timer for auto redirect
  @override
  void onInit() {
    sendEmailVerification();
    // setTimerForAutoRedirect();
    super.onInit();
  }

  // * Send Email Verification Link
  sendEmailVerification() async {
    try {
      customLog(isVerified);
      await AuthenticationRepository.instance.sendEmailVerification();
      successToast("Email sent successfully!");
    } catch (e) {
      errorToast(e);
    }
  }
  // * Timer to automatically redirects on Email Verification

  setTimerForAutoRedirect() {
    Timer.periodic(
      const Duration(seconds: 3),
      (timer) async {
        customLog("Checking");
        await FirebaseAuth.instance.currentUser!.reload();
        final user = FirebaseAuth.instance.currentUser;
        if (user!.emailVerified) {
          isVerified = true;
          timer.cancel();
          AuthenticationRepository.instance.setInitialScreen(user);
        }
      },
    );
  }

  // * Manually Check if the email is Verified
  checkEmailVerification() async {
    customLog("here");
    await FirebaseAuth.instance.currentUser!.reload();
    final currentUser = FirebaseAuth.instance.currentUser;
    customLog(currentUser ?? "Nothing");
    if (currentUser != null && currentUser.emailVerified) {
      customLog("Firebase Verified= ${currentUser.emailVerified}");
      isVerified = true;
      await Future.delayed(const Duration(seconds: 3));
      AuthenticationRepository.instance.setInitialScreen(currentUser);
    } else {
      successToast("Please Verify your Email!");
    }
  }
}

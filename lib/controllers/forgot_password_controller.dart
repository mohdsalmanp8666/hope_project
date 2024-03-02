import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/common/customLog.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  final _loading = false.obs;
  bool get loading => this._loading.value;
  set loading(value) => this._loading.value = value;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final email = TextEditingController();

  sendResetLink() async {
    try {
      if (!formKey.currentState!.validate()) {
        return;
      }
      await AuthenticationRepository.instance.forgotPassword(email.text.trim());
    } catch (e) {
      customLog("Ran into Error: $e");
    }
  }
}

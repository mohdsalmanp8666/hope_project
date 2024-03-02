import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/authController.dart';
import 'package:hope_project/utils/utils.dart';

class LoginController extends GetxController {
  final _authController = AuthController();
  final _loading = false.obs;
  bool get loading => _loading.value;
  set loading(value) => _loading.value = value;

  final _loginFailedErr = ''.obs;
  get loginFailedErr => _loginFailedErr.value;
  set loginFailedErr(value) => _loginFailedErr.value = value;

  final emailController = TextEditingController();
  final _emailError = ''.obs;
  String get emailError => _emailError.value;
  set emailError(value) => _emailError.value = value;

  final passwordController = TextEditingController();
  final _passwordError = ''.obs;
  String get passwordError => _passwordError.value;
  set passwordError(value) => _passwordError.value = value;

  @override
  void onClose() {
    emailController.clear();
    emailError = "";
    passwordController.clear();
    passwordError = "";
    super.onClose();
  }

  emailValidation() {
    emailError = '';
    if (emailController.text.isEmpty) {
      emailError = "Enter email";
      return false;
    } else if (!emailController.text.isEmail) {
      emailError = "Enter Valid Email";
      return false;
    } else {
      return true;
    }
  }

  passwordValidation() {
    passwordError = '';
    if (passwordController.text.isEmpty) {
      passwordError = 'Enter Password';
      return false;
    } else {
      return true;
    }
  }

  formValidation() {
    if (emailValidation() && passwordValidation()) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> loginWithEmail() async {
    loading = true;

    if (formValidation()) {
      await AuthenticationRepository.instance.loginWithEmailAndPassword(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    }
    // else {
    // loginFailedErr = "Invalid Email/Password!";
    // throw FirebaseAuthException(code: 'wrong-password');
    // }

    loading = false;
  }

  googleLogin() async {
    final user = await _authController.signInWithGoogle();
    if (user != null) {
      Utils.navigateUserToNextPage(
        user,
        _authController,
        isLoggedIn: true,
      );
    } else {
      errorToast("Something went wrong!");
    }
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
  }
}

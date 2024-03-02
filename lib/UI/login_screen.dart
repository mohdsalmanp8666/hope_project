import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hope_project/UI/User/user_register_screen.dart';
import 'package:hope_project/UI/forgot_password_screen.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/login_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: defaultPadding,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Gap(50),
                  AutoSizeText(
                    "Login",
                    minFontSize: 35,
                    style: customTextStyle(
                      fontSize: 45,
                    ),
                  ),
                  const Gap(14.5),
                  Obx(
                    () => Visibility(
                      visible: loginController.loginFailedErr.isNotEmpty,
                      child: AutoSizeText(
                        loginController.loginFailedErr,
                        maxLines: 1,
                        minFontSize: 14,
                        style: customTextStyle(
                          fontSize: 16,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const Gap(14.5),
                  Obx(
                    () => TextField(
                      controller: loginController.emailController,
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      onChanged: (value) {
                        if (value.isNotEmpty && value.isEmail) {
                          loginController.emailError = '';
                        }
                      },
                      decoration: customInputDecoration(
                        label: 'Email',
                        errorText: loginController.emailError.isEmpty
                            ? null
                            : loginController.emailError,
                      ),
                    ),
                  ),
                  const Gap(15),
                  Obx(
                    () => TextField(
                      obscureText: true,
                      controller: loginController.passwordController,
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          loginController.passwordError = '';
                        }
                      },
                      decoration: customInputDecoration(
                        label: 'Password',
                        errorText: loginController.passwordError.isEmpty
                            ? null
                            : loginController.passwordError,
                      ),
                    ),
                  ),
                  const Gap(5),
                  Container(
                    // size: Size.fromHeight(25),
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        customLog("Move to forgot password page");
                        Get.to(() => ForgotPasswordScreen());
                      },
                      child: AutoSizeText(
                        "Forgot Password?",
                        minFontSize: 12,
                        textAlign: TextAlign.right,
                        style: customTextStyle(
                          fontSize: 15,
                          color: mainColor,
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 150,
                    child: ElevatedButton(
                      onPressed: () => loginController.loading
                          ? successToast("Please wait...")
                          : loginController.loginWithEmail(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                      ),
                      child: Obx(
                        () => loginController.loading
                            ? customLoadingAnimation(
                                color: Colors.white,
                                size: 30,
                              )
                            : AutoSizeText(
                                "Login",
                                minFontSize: 18,
                                style: customTextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const Gap(25),
                  AutoSizeText(
                    "or",
                    style: customTextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                    ),
                  ),
                  const Gap(25),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 150,
                    child: ElevatedButton(
                      onPressed: () =>

                          // loginController.googleLogin(),
                          successToast("Currently not enabled!"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                      ),
                      child: AutoSizeText(
                        "Sign in with Google",
                        style: customTextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Gap(75),
                  GestureDetector(
                    onTap: () => Get.to(() => const UserRegisterScreen()),
                    child: AutoSizeText.rich(
                      TextSpan(
                        text: "New to Hope? ",
                        children: [
                          TextSpan(
                            text: "Register",
                            style: customTextStyle(color: mainColor),
                          ),
                        ],
                      ),
                      minFontSize: 16,
                      style: customTextStyle(fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

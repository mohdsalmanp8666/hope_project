import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/forgot_password_controller.dart';
import 'package:hope_project/utils/validations.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final forgotPasswordController = Get.put(ForgotPasswordController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSize(
        context,
        child: CustomAppbar(
          leading: customBackButton(),
          title: 'Forgot Password?',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: defaultPadding,
          child: Form(
            key: forgotPasswordController.formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Gap(25),
                  AutoSizeText(
                    "A Password reset link will be sent to your registered email address.",
                    textAlign: TextAlign.center,
                    style: customTextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                  const Gap(15),
                  TextFormField(
                    cursorColor: mainColor,
                    controller: forgotPasswordController.email,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    validator: (value) => AppValidator.validateEmail(value),
                    decoration: customInputDecoration(
                      label: 'Email',
                      hintText: "Enter Registered Email",
                      prefixIcon: const Icon(Symbols.email),
                    ),
                  ),
                  const Gap(25),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 150,
                    child: ElevatedButton(
                        onPressed: () => forgotPasswordController.loading
                            ? successToast("Please wait...")
                            : forgotPasswordController.sendResetLink(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                        ),
                        child: Obx(() => forgotPasswordController.loading
                            ? Center(
                                child: customLoadingAnimation(
                                  size: 25,
                                  color: Colors.white,
                                ),
                              )
                            : AutoSizeText(
                              "Send Email",
                              style: customTextStyle(
                                color: Colors.white,
                              ),
                              )
                          )),
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

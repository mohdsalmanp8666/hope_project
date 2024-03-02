import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/verify_email_controller.dart';

class VerifyEmailScreen extends StatelessWidget {
  VerifyEmailScreen({
    Key? key,
    this.email,
  }) : super(key: key);
  final String? email;

  final verifyEmailController = Get.put(VerifyEmailController());

  @override
  Widget build(BuildContext context) {
    customLog("In Build: ${verifyEmailController.isVerified}");
    return Scaffold(
      appBar: appBarSize(
        context,
        child: CustomAppbar(
          leading: IconButton(
            onPressed: () {
              AuthenticationRepository.instance.logoutUser();
            },
            icon: const Icon(
              Symbols.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: "Verify Email",
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: defaultPadding,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox.fromSize(
                  size: Size.fromHeight(
                    MediaQuery.of(context).size.height * 0.35,
                  ),
                  child: Obx(
                    () => verifyEmailController.isVerified
                        ? Icon(Symbols.done)
                        : SvgPicture.asset('assets/images/verify_email.svg'),
                  ),
                ),
                const Gap(25),
                AutoSizeText(
                  "Verify your Email Address!",
                  minFontSize: 24,
                  style: customTextStyle(
                    fontSize: 26,
                    letterSpacing: 1.25,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(25),
                SizedBox.fromSize(
                  size: const Size.fromHeight(65),
                  child: ElevatedButton(
                    onPressed: () =>
                        verifyEmailController.checkEmailVerification(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: AutoSizeText(
                      "Continue",
                      style: customTextStyle(
                        fontSize: 26,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const Gap(25),
                SizedBox.fromSize(
                  size: const Size.fromHeight(50),
                  child: GestureDetector(
                    onTap: () {
                      customLog("Resend Email!");
                      verifyEmailController.sendEmailVerification();
                    },
                    child: AutoSizeText(
                      "Resend Email",
                      textAlign: TextAlign.center,
                      style: customTextStyle(
                        color: mainColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

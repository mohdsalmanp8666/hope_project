import 'package:auto_size_text/auto_size_text.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/User%20Controllers/donateController.dart';
import 'package:hope_project/routes/app_routes.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class DonateScreen extends StatelessWidget {
  DonateScreen({super.key});

  final _donateController = Get.put(DonateController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSize(
        context,
        child: CustomAppbar(
          leading: customBackButton(),
          title: "Donate",
        ),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            child: Padding(
              padding: defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(25),
                  AutoSizeText(
                    "What would you like to donate?",
                    maxLines: 2,
                    minFontSize: 23,
                    textAlign: TextAlign.center,
                    style: customTextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Gap(15),
                  SizedBox.fromSize(
                    child: Obx(
                      () => ChipsChoice.single(
                        padding: const EdgeInsets.all(0),
                        value: _donateController.choiceIndex,
                        choiceItems: C2Choice.listFrom<int, String>(
                          source: _donateController.choices,
                          value: (i, v) => i,
                          label: (i, v) => v,
                        ),
                        onChanged: (val) => _donateController.choiceIndex = val,
                        choiceCheckmark: true,
                        choiceStyle: C2ChipStyle.filled(
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          foregroundStyle: customTextStyle(
                            fontSize: 18,
                          ),
                          color: Colors.grey.withOpacity(0.25),
                          borderStyle: BorderStyle.solid,
                          borderWidth: 1,
                          selectedStyle: C2ChipStyle(
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(8),
                            backgroundColor: mainColor,
                            foregroundColor: Colors.white,
                            foregroundStyle: customTextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  const Gap(15),
                  Obx(() {
                    if (_donateController.choiceIndex == 0) {
                      return _loadClothesDonationWidget(context);
                    } else if (_donateController.choiceIndex == 1) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            "Clothes for:",
                            style: customTextStyle(),
                          ),
                          const Gap(10),
                          ChipsChoice<String>.multiple(
                            wrapped: true,
                            padding: const EdgeInsets.all(0),
                            textDirection: TextDirection.ltr,
                            wrapCrossAlignment: WrapCrossAlignment.start,
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            value: _donateController.foodType,
                            choiceItems: C2Choice.listFrom<String, String>(
                              source: _donateController.foodTypeList,
                              value: (i, v) => v,
                              label: (i, v) => v,
                            ),
                            onChanged: (val) {
                              _donateController.foodTypeErr =
                                  val.isEmpty ? true : false;
                              _donateController.foodType = val;
                              customLog(val);
                            },
                            choiceCheckmark: false,
                            choiceStyle: C2ChipStyle.filled(
                              height: 45,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              foregroundStyle: customTextStyle(
                                fontSize: 18,
                              ),
                              color: Colors.grey.shade600,
                              selectedStyle: C2ChipStyle(
                                backgroundColor: mainColor,
                                foregroundColor: Colors.white,
                                foregroundStyle: customTextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const Gap(5),
                          Obx(
                            () => _donateController.foodTypeErr
                                ? AutoSizeText(
                                    "Select at least 1",
                                    maxLines: 1,
                                    minFontSize: 12,
                                    overflow: TextOverflow.ellipsis,
                                    style: customTextStyle(
                                      fontSize: 13,
                                      color: Colors.red,
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                          const Gap(10),
                        ],
                      );
                    } else {
                      return Container(height: 50, color: Colors.red);
                    }
                  }),
                  const Gap(15),
                  Obx(
                    () => TextField(
                      maxLength: 3,
                      controller: _donateController.itemCountController,
                      keyboardType: TextInputType.number,
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      onChanged: (value) {
                        if (value.isEmpty || (int.tryParse(value)! < 1)) {
                          _donateController.itemErr = true;
                        } else {
                          _donateController.itemErr = false;
                        }
                      },
                      decoration: customInputDecoration(
                        label: "Total Number of items",
                        errorText: _donateController.itemErr
                            ? "Enter total number of items"
                            : null,
                      ),
                    ),
                  ),
                  const Gap(25),
                  AutoSizeText(
                    "Choose mode:",
                    style: customTextStyle(),
                  ),
                  const Gap(15),
                  SizedBox.fromSize(
                    child: Obx(
                      () => ChipsChoice.single(
                        spacing: 0,
                        runSpacing: 0,
                        padding: const EdgeInsets.all(0),
                        value: _donateController.isPickup,
                        choiceItems: const [
                          C2Choice(value: true, label: 'Pickup'),
                          C2Choice(value: false, label: 'Drop Off'),
                        ],
                        onChanged: (val) => _donateController.isPickup = val,
                        choiceCheckmark: true,
                        choiceStyle: C2ChipStyle.filled(
                          height: 45,
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 0),
                          foregroundStyle: customTextStyle(
                            fontSize: 18,
                          ),
                          color: Colors.grey.withOpacity(0.25),
                          borderStyle: BorderStyle.solid,
                          borderWidth: 1,
                          selectedStyle: C2ChipStyle(
                            margin: const EdgeInsets.all(0),
                            padding: const EdgeInsets.all(8),
                            backgroundColor: mainColor,
                            foregroundColor: Colors.white,
                            foregroundStyle: customTextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => _donateController.isPickup
                        ? TextFormField(
                            decoration:
                                customInputDecoration(label: 'Pickup Address'),
                          )
                        : _ngoLocation(
                            address:
                                "No. 67, New Link Rd, Malad, Reserve Bank of India Staff Quarters, Raheja Twp, Malad West, Mumbai, Maharashtra 400064.",
                          ),
                  ),
                  const Gap(25),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_donateController.loading) {
                          successToast("Please wait...");
                        } else {
                          var result =
                              await _donateController.generateDonateRequest();
                          if (result) {
                            // ignore: use_build_context_synchronously
                            PanaraInfoDialog.show(
                              context,
                              imagePath: 'assets/images/verified.png',
                              title: "Thank You",
                              message:
                                  "Your donation request has been successfully submitted to the NGO.",
                              buttonText: "Go to Home Page",
                              onTapDismiss: () =>
                                  Get.offAndToNamed(Routes.homeScreen),
                              color: mainColor,
                              panaraDialogType: PanaraDialogType.custom,
                              barrierDismissible: false,
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                      ),
                      child: Obx(
                        () => _donateController.loading
                            ? customLoadingAnimation(
                                size: 30,
                                color: Colors.white,
                              )
                            : AutoSizeText(
                                "Submit Request",
                                style: customTextStyle(
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const Gap(50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _ngoLocation({required String address}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(25),
        AutoSizeText(
          "NGO Address:",
          style: customTextStyle(),
        ),
        const Gap(15),
        AutoSizeText(
          address,
          style: customTextStyle(
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }

  Column _loadClothesDonationWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          "Clothes for:",
          style: customTextStyle(),
        ),
        const Gap(10),
        ChipsChoice<String>.multiple(
          wrapped: true,
          padding: const EdgeInsets.all(0),
          textDirection: TextDirection.ltr,
          wrapCrossAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          value: _donateController.clothesFor,
          choiceItems: C2Choice.listFrom<String, String>(
            source: _donateController.clothesForList,
            value: (i, v) => v,
            label: (i, v) => v,
          ),
          onChanged: (val) {
            _donateController.clothesForErr = val.isEmpty ? true : false;
            _donateController.clothesFor = val;
            customLog(val);
          },
          choiceCheckmark: false,
          choiceStyle: C2ChipStyle.filled(
            height: 45,
            margin: const EdgeInsets.symmetric(horizontal: 0),
            foregroundStyle: customTextStyle(
              fontSize: 18,
            ),
            color: Colors.grey.shade600,
            selectedStyle: C2ChipStyle(
              backgroundColor: mainColor,
              foregroundColor: Colors.white,
              foregroundStyle: customTextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const Gap(5),
        Obx(
          () => _donateController.clothesForErr
              ? AutoSizeText(
                  "Select at least 1",
                  maxLines: 1,
                  minFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                  style: customTextStyle(
                    fontSize: 13,
                    color: Colors.red,
                  ),
                )
              : const SizedBox(),
        ),
        const Gap(10),
        AutoSizeText(
          "Clothes type:",
          style: customTextStyle(),
        ),
        const Gap(10),
        ChipsChoice<String>.multiple(
          wrapped: true,
          padding: const EdgeInsets.all(0),
          textDirection: TextDirection.ltr,
          wrapCrossAlignment: WrapCrossAlignment.start,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          value: _donateController.clothesTypeSelected,
          choiceItems: C2Choice.listFrom<String, String>(
            source: _donateController.clothesType,
            value: (i, v) => v,
            label: (i, v) => v,
          ),
          onChanged: (val) {
            _donateController.clothesTypeErr = val.isEmpty ? true : false;
            _donateController.clothesTypeSelected = val;
            customLog(_donateController.clothesTypeSelected);
          },
          choiceCheckmark: false,
          choiceStyle: C2ChipStyle.filled(
            height: 45,
            margin: const EdgeInsets.symmetric(horizontal: 0),
            foregroundStyle: customTextStyle(
              fontSize: 18,
            ),
            color: Colors.grey.shade600,
            selectedStyle: C2ChipStyle(
              backgroundColor: mainColor,
              foregroundColor: Colors.white,
              foregroundStyle: customTextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const Gap(5),
        Obx(
          () => _donateController.clothesTypeErr
              ? AutoSizeText(
                  "Select at least 1",
                  maxLines: 1,
                  minFontSize: 12,
                  overflow: TextOverflow.ellipsis,
                  style: customTextStyle(
                    fontSize: 13,
                    color: Colors.red,
                  ),
                )
              : const SizedBox(),
        ),
        const Gap(10),
      ],
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/UI/User/home_screen.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/User%20Controllers/donate_controller.dart';
import 'package:hope_project/models/donate_model.dart';
import 'package:hope_project/models/user_model.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class DonateScreen extends StatelessWidget {
  final UserModel ngo;
  DonateScreen({super.key, required this.ngo});

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
                  _donationItemChoice(),
                  const Divider(),
                  const Gap(15),
                  // ! Donation Body
                  Obx(() {
                    if (_donateController.choiceIndex ==
                        DonationType.Clothes.name) {
                      return _loadClothesDonationWidget(context);
                    } else if (_donateController.choiceIndex ==
                        DonationType.Food.name) {
                      return _loadFoodDonationWidget();
                    } else if (_donateController.choiceIndex ==
                        DonationType.Books.name) {
                      return _loadBookDonationWidget();
                    } else {
                      return Container();
                    }
                  }),
                  const Gap(15),
                  // ! Items Field
                  _itemCountField(context),
                  // ! Description Field
                  const Gap(15),
                  TextField(
                    controller: _donateController.desc,
                    keyboardType: TextInputType.text,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    decoration: customInputDecoration(
                      prefixIcon: const Icon(Symbols.info),
                      label: 'Description/Instructions',
                    ),
                  ),
                  const Gap(25),
                  // ! Mode Selection
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
                        ? _ngoLocation(
                            address: AuthenticationRepository
                                .instance.currentUser!.address
                                .toString(),
                          )
                        // TextFormField(
                        //     decoration:
                        //         customInputDecoration(label: 'Pickup Address'),
                        //   )
                        : _ngoLocation(
                            address: ngo.address.toString(),
                          ),
                  ),
                  const Gap(25),
                  _donateNowButton(context),
                  const Gap(50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Obx _itemCountField(BuildContext context) {
    return Obx(
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
          prefixIcon: const Icon(Symbols.align_items_stretch),
          errorText:
              _donateController.itemErr ? "Enter total number of items" : null,
        ),
      ),
    );
  }

  SizedBox _donateNowButton(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.75,
      child: ElevatedButton(
        onPressed: () async {
          (_donateController.loading)
              ? successToast("Please wait...")
              : await _donateController.generateDonateRequest(context, ngo);
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
    );
  }

  Column _loadBookDonationWidget() {
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
          value: _donateController.booksTypeSelected,
          choiceItems: C2Choice.listFrom<String, String>(
            source: _donateController.bookTypeList,
            value: (i, v) => v,
            label: (i, v) => v,
          ),
          onChanged: (val) {
            _donateController.bookTypeErr = val.isEmpty ? true : false;
            _donateController.booksTypeSelected = val;
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
          () => _donateController.bookTypeErr
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
      ],
    );
  }

  SizedBox _donationItemChoice() {
    return SizedBox.fromSize(
      child: Obx(
        () => ChipsChoice.single(
          padding: const EdgeInsets.all(0),
          value: _donateController.choiceIndex,
          choiceItems: C2Choice.listFrom<String, String>(
            source: [
              DonationType.Clothes.name,
              DonationType.Food.name,
              DonationType.Books.name,
              DonationType.Others.name,
            ],
            value: (i, v) => v,
            label: (i, v) => v,
          ),
          onChanged: (val) {
            _donateController.choiceIndex = val;
            _donateController.resetErrors();
          },
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
    );
  }

  Column _loadFoodDonationWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoSizeText(
          "Food type:",
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
          value: _donateController.foodsTypeSelected,
          choiceItems: C2Choice.listFrom<String, String>(
            source: _donateController.foodTypeList,
            value: (i, v) => v,
            label: (i, v) => v,
          ),
          onChanged: (val) {
            _donateController.foodTypeErr = val.isEmpty ? true : false;
            _donateController.foodsTypeSelected = val;
            customLog(val);
          },
          choiceCheckmark: false,
          choiceStyle: C2ChipStyle.filled(
            height: 45,
            margin: const EdgeInsets.symmetric(horizontal: 10),
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

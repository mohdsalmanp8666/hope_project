import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/User%20Controllers/update_profile_controller.dart';
import 'package:hope_project/utils/validations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});

  final updateProfileController = Get.put(UpdateProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSize(
        context,
        child: CustomAppbar(
          leading: customBackButton(),
          title: "Update Profile",
        ),
      ),
      body: SafeArea(
        child: Form(
          child: Padding(
            padding: defaultPadding,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Gap(25),
                  // ! Profile Pic
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: GestureDetector(
                      onTap: () async {
                        customLog("Open Image Picker");
                        // updateProfileController.isNewImg = true;
                        updateProfileController.pic = Rx<XFile?>(
                          await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          ),
                        );
                        if (updateProfileController.pic.value != null) {
                          customLog("Image Selected");
                          updateProfileController.isNewImg = true;
                        }
                      },
                      child: SizedBox.square(
                        dimension: 100,
                        child: Obx(
                          () => updateProfileController.isNewImg
                              ? Image.file(
                                  File(updateProfileController.pic.value!.path),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.medium,
                                )
                              : Image.network(
                                  updateProfileController.url.value.toString(),
                                  filterQuality: FilterQuality.medium,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: Colors.grey,
                                  ),
                                  loadingBuilder:
                                      (context, child, loadingProgress) =>
                                          loadingProgress != null
                                              ? Center(
                                                  child: customLoadingAnimation(
                                                    color: Colors.white,
                                                    size: 15,
                                                  ),
                                                )
                                              : child,
                                ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(25),
                  // ! Name Field
                  TextFormField(
                    readOnly: true,
                    enabled: false,
                    controller: updateProfileController.name,
                    validator: (value) => AppValidator.validateName(value),
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: customInputDecoration(
                      label: 'Name',
                      isDisabled: true,
                      prefixIcon: const Icon(
                        Symbols.person,
                      ),
                    ),
                  ),
                  const Gap(10),
                  // ! Email Field
                  TextFormField(
                    readOnly: true,
                    enabled: false,
                    controller: updateProfileController.email,
                    validator: (value) => AppValidator.validateEmail(value),
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: customInputDecoration(
                      label: 'Email',
                      prefixIcon: const Icon(
                        Symbols.email,
                      ),
                      suffixIcon: const Icon(
                        Symbols.verified,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  const Gap(10),
                  // ! Phone Number
                  TextFormField(
                    readOnly: true,
                    enabled: false,
                    controller: updateProfileController.phone,
                    validator: (value) => AppValidator.validatePhone(value),
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: customInputDecoration(
                      label: 'Phone Number',
                      prefixIcon: const Icon(
                        Symbols.phone,
                      ),
                    ),
                  ),
                  const Gap(10),
                  // ! Date of Birth
                  TextFormField(
                    readOnly: true,
                    enabled: false,
                    controller: updateProfileController.date,
                    validator: (value) => AppValidator.validateDate(value),
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        lastDate:
                            DateTime.now().subtract(const Duration(days: 6570)),
                        firstDate: DateTime(1951),
                        initialDate:
                            DateTime.now().subtract(const Duration(days: 6570)),
                      );
                      if (pickedDate == null) return;
                      updateProfileController.date.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    },
                    decoration: customInputDecoration(
                      label: 'Date of Birth',
                      prefixIcon: const Icon(
                        Symbols.calendar_month,
                      ),
                    ),
                  ),
                  const Gap(10),
                  // ! Gender
                  DropDownTextField(
                    readOnly: true,
                    isEnabled: false,
                    controller: updateProfileController.gender,
                    validator: (value) => AppValidator.validateGender(value),
                    textFieldDecoration:
                        customInputDecoration(label: 'Select Gender'),
                    dropDownList: const [
                      DropDownValueModel(name: 'Male', value: 'Male'),
                      DropDownValueModel(name: 'Female', value: 'Female'),
                      DropDownValueModel(name: 'Other', value: 'Other'),
                    ],
                  ),
                  const Gap(10),
                  // ! Address
                  TextFormField(
                    controller: updateProfileController.address,
                    validator: (value) => AppValidator.validateAddress(value),
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: customInputDecoration(
                      label: 'Address',
                      prefixIcon: const Icon(
                        Symbols.home,
                      ),
                    ),
                  ),
                  const Gap(25),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 150,
                    child: ElevatedButton(
                      onPressed: () => updateProfileController.loading
                          ? successToast("Please Wait...")
                          : updateProfileController.updateUser(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                      ),
                      child: Obx(
                        () => updateProfileController.loading
                            ? Center(
                                child: customLoadingAnimation(
                                  size: 25,
                                  color: Colors.white,
                                ),
                              )
                            : AutoSizeText(
                                "Update Profile",
                                maxLines: 1,
                                minFontSize: 15,
                                style: customTextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                      ),
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

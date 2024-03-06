import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/NGO%20Controllers/ngo_profile_update_controller.dart';
import 'package:hope_project/utils/validations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/symbols.dart';

class UpdateNGOScreen extends StatelessWidget {
  UpdateNGOScreen({super.key});

  final updateNgoController = Get.put(NGOProfileUpdateController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSize(
        context,
        child: CustomAppbar(
          leading: customBackButton(),
          title: "NGO Profile",
        ),
      ),
      body: SafeArea(
        child: Form(
          key: updateNgoController.formKey,
          child: Padding(
            padding: defaultPadding,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Gap(15),
                  // ! Profile Pic
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: GestureDetector(
                      onTap: () async {
                        customLog("Open Image Picker");
                        // updateProfileController.isNewImg = true;
                        updateNgoController.pic = Rx<XFile?>(
                          await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          ),
                        );
                        if (updateNgoController.pic.value != null) {
                          customLog("Image Selected");
                          updateNgoController.isNewImg = true;
                        }
                      },
                      child: SizedBox.square(
                        dimension: 100,
                        child: Obx(
                          () => updateNgoController.isNewImg
                              ? Image.file(
                                  File(updateNgoController.pic.value!.path),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.medium,
                                )
                              : Image.network(
                                  updateNgoController.url.value.toString(),
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
                  TextFormField(
                    readOnly: true,
                    enabled: false,
                    controller: updateNgoController.ngoName,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: customInputDecoration(label: 'NGO Name'),
                  ),
                  const Gap(15),
                  TextFormField(
                    minLines: 1,
                    maxLines: 3,
                    controller: updateNgoController.ngoDesc,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: customInputDecoration(label: 'Description'),
                  ),
                  const Gap(15),
                  TextFormField(
                    controller: updateNgoController.head,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: customInputDecoration(label: 'Head of NGO'),
                  ),
                  const Gap(15),
                  TextFormField(
                    readOnly: true,
                    enabled: false,
                    controller: updateNgoController.date,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration:
                        customInputDecoration(label: 'Date of Registration'),
                  ),
                  const Gap(15),
                  TextFormField(
                    readOnly: true,
                    enabled: false,
                    controller: updateNgoController.email,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: customInputDecoration(label: 'Email'),
                  ),
                  const Gap(15),
                  TextFormField(
                    readOnly: true,
                    enabled: false,
                    controller: updateNgoController.phone,
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: customInputDecoration(label: 'Phone'),
                  ),
                  const Gap(15),
                  // ! Gender
                  DropDownTextField(
                    // readOnly: true,
                    // isEnabled: false,
                    controller: updateNgoController.gender,
                    validator: (value) => AppValidator.validateGender(value),

                    textFieldDecoration:
                        customInputDecoration(label: 'Select Gender'),
                    dropDownList: const [
                      DropDownValueModel(name: 'Male', value: 'Male'),
                      DropDownValueModel(name: 'Female', value: 'Female'),
                      DropDownValueModel(name: 'Other', value: 'Other'),
                    ],
                  ),
                  // ! Address
                  TextFormField(
                    controller: updateNgoController.address,
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
                      onPressed: () => updateNgoController.loading
                          ? successToast("Please Wait...")
                          : updateNgoController.updateUser(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                      ),
                      child: Obx(
                        () => updateNgoController.loading
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
}

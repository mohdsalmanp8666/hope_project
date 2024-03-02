import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/UI/NGO/ngo_register_screen.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/custom_drawer.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/user_register_controller.dart';
import 'package:hope_project/utils/validations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class UserRegisterScreen extends StatelessWidget {
  final bool isSocialLoggedIn;
  final bool isEditProfile;
  const UserRegisterScreen({
    super.key,
    this.isSocialLoggedIn = false,
    this.isEditProfile = false,
  });

  @override
  Widget build(BuildContext context) {
    final userRegisterController = Get.put(UserRegisterController());
    return Scaffold(
      drawer: isEditProfile ? const CustomDrawer() : null,
      appBar: appBarSize(
        context,
        child: CustomAppbar(
          leading: isEditProfile ? const DrawerButton() : customBackButton(),
          title: isEditProfile ? "Update Profile" : "User Registration",
          actions: isEditProfile
              ? []
              : [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      onTap: () => Get.off(() => NgoRegisterScreen()),
                      child: AutoSizeText(
                        "An NGO?",
                        style: customTextStyle(),
                      ),
                    ),
                  )
                ],
        ),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Form(
            key: userRegisterController.formKey,
            child: Padding(
              padding: defaultPadding,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Gap(25),
                    // * Profile Pic
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: GestureDetector(
                        onTap: () async {
                          userRegisterController.isPicSelected = false;
                          userRegisterController.pic = Rx<XFile?>(
                            await userRegisterController.picker.pickImage(
                              source: ImageSource.gallery,
                            ),
                          );
                          if (userRegisterController.pic.value != null) {
                            customLog("Image Selected");
                            userRegisterController.isPicSelected = true;
                          }
                        },
                        child: SizedBox.square(
                          dimension: 100,
                          child: Container(
                            color: mainColor,
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            child: Obx(
                              () => userRegisterController.isPicSelected
                                  ? Image.file(
                                      File(userRegisterController
                                          .pic.value!.path),
                                      height: 100,
                                      fit: BoxFit.cover,
                                      filterQuality: FilterQuality.medium,
                                    )
                                  : isEditProfile
                                      ? Image.network(
                                          AuthenticationRepository.instance
                                              .currentUser!.nGOData!.pic
                                              .toString(),
                                          height: 100,
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.medium,
                                        )
                                      : const Icon(
                                          Symbols.camera_alt,
                                          size: 35,
                                          color: Colors.white,
                                        ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(15),
                    // * Name
                    TextFormField(
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      validator: (value) => AppValidator.validateName(value),
                      controller: userRegisterController.name,
                      decoration: customInputDecoration(
                        label: 'Name',
                        prefixIcon: const Icon(Symbols.person),
                      ),
                    ),
                    const Gap(15),
                    // * Phone number
                    TextFormField(
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      validator: (value) => AppValidator.validatePhone(value),
                      controller: userRegisterController.phone,
                      decoration: customInputDecoration(
                        label: 'Phone Number',
                        prefixIcon: const Icon(Symbols.phone),
                      ),
                    ),
                    const Gap(25),
                    // * Email
                    TextFormField(
                      // initialValue: isEditProfile
                      //     ? AuthenticationRepository.instance.currentUser!.email
                      //         .toString()
                      //     : "",
                      enabled: !isEditProfile,
                      controller: userRegisterController.email,
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      validator: (value) => AppValidator.validateEmail(value),
                      decoration: customInputDecoration(
                        label: 'Email',
                        prefixIcon: const Icon(Symbols.email),
                      ),
                    ),
                    // !isSocialLoggedIn
                    //     ?
                    Column(
                      children: [
                        const Gap(25),
                        TextFormField(
                          obscureText: true,
                          controller: userRegisterController.password,
                          onTapOutside: (event) =>
                              FocusManager.instance.primaryFocus?.unfocus(),
                          validator: (value) =>
                              AppValidator.validatePassword(value),
                          decoration: customInputDecoration(
                            label: 'Password',
                            prefixIcon: const Icon(Symbols.lock),
                          ),
                        ),
                      ],
                    ),
                    // : SizedBox(),
                    const Gap(25),
                    // * Date of Birth
                    TextFormField(
                      readOnly: true,
                      controller: userRegisterController.date,
                      validator: (value) => AppValidator.validateDate(value),
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          lastDate: DateTime.now()
                              .subtract(const Duration(days: 6570)),
                          firstDate: DateTime(1951),
                          initialDate: DateTime.now()
                              .subtract(const Duration(days: 6570)),
                        );
                        if (pickedDate == null) return;
                        userRegisterController.date.text =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                      },
                      decoration: customInputDecoration(
                        label: 'Date of Birth',
                        prefixIcon: const Icon(Symbols.calendar_month),
                      ),
                    ),
                    const Gap(25),
                    // * Gender
                    DropDownTextField(
                      controller: userRegisterController.gender,
                      validator: (value) => AppValidator.validateGender(value),
                      textFieldDecoration:
                          customInputDecoration(label: 'Select Gender'),
                      dropDownList: const [
                        DropDownValueModel(name: 'Male', value: 'Male'),
                        DropDownValueModel(name: 'Female', value: 'Female'),
                        DropDownValueModel(name: 'Other', value: 'Other'),
                      ],
                    ),
                    const Gap(25),
                    TextFormField(
                      minLines: 1,
                      maxLines: 3,
                      validator: (value) => AppValidator.validateAddress(value),
                      onTapOutside: (event) =>
                          FocusManager.instance.primaryFocus?.unfocus(),
                      controller: userRegisterController.address,
                      decoration: customInputDecoration(
                        label: 'Address',
                      ),
                    ),
                    const Gap(25),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 150,
                      child: ElevatedButton(
                        onPressed: () => userRegisterController.loading
                            ? errorToast("Please wait...")
                            : userRegisterController.signUp(
                                isEditProfile: isEditProfile,
                              ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                        ),
                        child: Obx(
                          () => userRegisterController.loading
                              ? customLoadingAnimation(
                                  size: 25,
                                  color: Colors.white,
                                )
                              : AutoSizeText(
                                  "Register",
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
      ),
    );
  }
}

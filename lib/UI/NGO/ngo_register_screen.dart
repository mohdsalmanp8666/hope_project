import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hope_project/UI/User/user_register_screen.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/NGO%20Controllers/ngo_register_controller.dart';
import 'package:hope_project/utils/validations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class NgoRegisterScreen extends StatelessWidget {
  NgoRegisterScreen({super.key});

  final ngoRegisterController = Get.put(NgoRegisterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSize(
        context,
        child: CustomAppbar(
          leading: customBackButton(),
          title: "NGO Registration",
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                right: 10,
              ),
              child: InkWell(
                onTap: () => Get.off(() => const UserRegisterScreen()),
                child: AutoSizeText(
                  "User?",
                  style: customTextStyle(),
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Form(
          key: ngoRegisterController.formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: defaultPadding,
              child: Column(
                children: [
                  const Gap(25),
                  // ! Profile Pic
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: GestureDetector(
                      onTap: () async {
                        ngoRegisterController.isPicSelected = false;
                        ngoRegisterController.pic = Rx<XFile?>(
                          await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          ),
                        );
                        if (ngoRegisterController.pic.value != null) {
                          customLog("Image Selected");
                          ngoRegisterController.isPicSelected = true;
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
                            () => ngoRegisterController.isPicSelected
                                ? Image.file(
                                    File(ngoRegisterController.pic.value!.path),
                                    height: 100,
                                    width: 100,
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

                  const Gap(25),

                  // * Name of NGO
                  TextFormField(
                    cursorColor: mainColor,
                    controller: ngoRegisterController.name,
                    validator: (value) => AppValidator.validateName(value),
                    decoration: customInputDecoration(
                      label: 'Name of NGO',
                      prefixIcon: const Icon(Symbols.corporate_fare),
                    ),
                  ),
                  const Gap(25),
                  // * NGO Description
                  TextFormField(
                    minLines: 1,
                    maxLines: 3,
                    cursorColor: mainColor,
                    controller: ngoRegisterController.desc,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => AppValidator.validateDesc(value),
                    decoration: customInputDecoration(
                      label: 'NGO Description',
                      prefixIcon: const Icon(Symbols.description),
                    ),
                  ),
                  const Gap(25),
                  // * Name of Head NGO
                  TextFormField(
                    cursorColor: mainColor,
                    controller: ngoRegisterController.headName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => AppValidator.validateName(value),
                    decoration: customInputDecoration(
                      label: 'Head of NGO',
                      prefixIcon: const Icon(Symbols.person),
                    ),
                  ),
                  const Gap(25),
                  // * Date of Registration
                  TextFormField(
                    readOnly: true,
                    cursorColor: mainColor,
                    controller: ngoRegisterController.date,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => AppValidator.validateDate(value),
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
                      // userRegisterController.date.text =
                      ngoRegisterController.date.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      // customLog(DateFormat('yyyy-MM-dd').format(pickedDate));
                    },
                    decoration: customInputDecoration(
                      label: 'Date of Registration',
                      prefixIcon: const Icon(Symbols.calendar_month),
                    ),
                  ),
                  const Gap(25),
                  // * NGO Email
                  TextFormField(
                    cursorColor: mainColor,
                    controller: ngoRegisterController.email,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => AppValidator.validateEmail(value),
                    decoration: customInputDecoration(
                      label: 'Email',
                      prefixIcon: const Icon(Symbols.email),
                    ),
                  ),
                  const Gap(25),
                  // * Password
                  Obx(
                    () => TextFormField(
                      obscureText: ngoRegisterController.isVisible.value,
                      cursorColor: mainColor,
                      controller: ngoRegisterController.password,
                      validator: (value) =>
                          AppValidator.validatePassword(value),
                      decoration: customInputDecoration(
                        label: 'Password',
                        prefixIcon: const Icon(Symbols.key),
                        suffixIcon: IconButton(
                          onPressed: () => ngoRegisterController.isVisible
                              .value = !ngoRegisterController.isVisible.value,
                          icon: Icon(
                            ngoRegisterController.isVisible.value
                                ? Symbols.visibility
                                : Symbols.visibility_off,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(25),
                  // * Phone
                  TextFormField(
                    maxLength: 10,
                    cursorColor: mainColor,
                    keyboardType: TextInputType.number,
                    controller: ngoRegisterController.phone,
                    validator: (value) => AppValidator.validatePhone(value),
                    decoration: customInputDecoration(
                      label: 'Phone Number',
                      prefixIcon: const Icon(Symbols.phone),
                    ),
                  ),
                  const Gap(25),
                  // * Gender of Head
                  DropDownTextField(
                    controller: ngoRegisterController.gender,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => AppValidator.validateGender(value),
                    textFieldDecoration:
                        customInputDecoration(label: 'Gender (NGO Head)'),
                    dropDownList: const [
                      DropDownValueModel(name: 'Male', value: 'Male'),
                      DropDownValueModel(name: 'Female', value: 'Female'),
                      DropDownValueModel(name: 'Other', value: 'Other'),
                    ],
                  ),
                  const Gap(25),
                  // * Address
                  TextFormField(
                    cursorColor: mainColor,
                    controller: ngoRegisterController.address,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => AppValidator.validateAddress(value),
                    decoration: customInputDecoration(
                      label: 'Address & Location',
                      prefixIcon: const Icon(Symbols.location_on),
                    ),
                  ),
                  const Gap(25),
                  // * Address Proof
                  TextFormField(
                    readOnly: true,
                    controller: ngoRegisterController.fileName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) => AppValidator.validateFile(value),
                    onTap: () async {
                      customLog("Initialized Picking file");

                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: [
                          'jpg',
                          'jpeg',
                          'pdf',
                        ],
                      );

                      if (result != null) {
                        customLog("Selected a File");
                        ngoRegisterController.file =
                            File(result.files.single.path!);
                        ngoRegisterController.fileName.text =
                            ngoRegisterController.file!.path.split('/').last;
                      } else {
                        // User canceled the picker
                        successToast("No File Selected");
                        ngoRegisterController.fileName.clear();
                      }
                    },
                    decoration: customInputDecoration(
                      label: 'Address Proof',
                    ),
                  ),
                  const Gap(25),
                  // FlutterLocationPicker(onPicked: (value) {}),
                  SizedBox.fromSize(
                    size: const Size.fromHeight(35),
                    child: AutoSizeText(
                      "NGO Location",
                      textAlign: TextAlign.left,
                      style: customTextStyle(),
                    ),
                  ),
                  // * Latitude
                  TextFormField(
                    cursorColor: mainColor,
                    keyboardType: TextInputType.number,
                    controller: ngoRegisterController.lat,
                    validator: (value) => AppValidator.validateGeoPoint(value),
                    decoration: customInputDecoration(label: 'Latitude'),
                  ),
                  const Gap(10),
                  // * Longitude
                  TextFormField(
                    cursorColor: mainColor,
                    keyboardType: TextInputType.number,
                    controller: ngoRegisterController.lon,
                    validator: (value) => AppValidator.validateGeoPoint(value),
                    decoration: customInputDecoration(label: 'Longitude'),
                  ),
                  // TextFormField(
                  //   readOnly: true,
                  //   initialValue: "19.139935905747844, 72.84721229334006",
                  //   // onTap: () async {
                  //   //   Get.to(
                  //   //     () => GoogleMapLocationPicker(
                  //   //       apiKey: 'AIzaSyAeuUKgw65yAw5uVZGkIBnvndo0aC8KBh4',
                  //   //       onNext: (p0) {
                  //   //         customLog(p0);
                  //   //       },
                  //   //     ),
                  //   //   );
                  //   // },
                  //   decoration:
                  //       customInputDecoration(label: 'Pick Location of NGO'),
                  // ),
                  const Gap(25),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 150,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: () => ngoRegisterController.loading
                            ? successToast("Please wait...")
                            : ngoRegisterController.ngoSignUp(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                        ),
                        child: ngoRegisterController.loading
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
    );
  }
}

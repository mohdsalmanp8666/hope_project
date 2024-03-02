import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/Repositories/Storage/storage_repository.dart';
import 'package:hope_project/Repositories/User/user_repository.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/models/UserModel.dart';
import 'package:image_picker/image_picker.dart';

class UserRegisterController extends GetxController {
  static UserRegisterController get instance => Get.find();

  final _loading = false.obs;
  get loading => _loading.value;
  set loading(value) => _loading.value = value;

// ? Variables
  // XFile? pic;

  final _isPicSelected = false.obs;
  bool get isPicSelected => _isPicSelected.value;
  set isPicSelected(value) => _isPicSelected.value = value;

  late Rx<XFile?> pic;
  var user;

  ImagePicker picker = ImagePicker();
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final date = TextEditingController();
  final gender = SingleValueDropDownController();
  final address = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ?

  

  Future<void> signUp({bool isEditProfile = false}) async {
    try {
      loading = true;
      // Check if the connected to Internet or not
      // final connected = await NetworkManager.instance.isConnected();
      // if (!connected) {
      //   errorToast("No Internet Connection!");
      //   return;
      // }

      // Validate the Image

      if (isEditProfile == false) {
        if (pic.value?.path.isEmpty ?? true) {
          customLog("Image not Added!");
          errorToast("Please add Profile pic!");
          return;
        }

        // Validate the form
        if (!formKey.currentState!.validate()) {
          customLog("Validation Failed!");
          return;
        }
        // Register User in Firebase Authentication
        user = await AuthenticationRepository.instance
            .registerWithEmailAndPassword(
          email.text.trim(),
          password.text.trim(),
        );
      }
      Get.put(StorageRepository());

      final newUser = UserModel(
        id: user.user?.uid ??
            AuthenticationRepository.instance.currentUser!.id.toString(),
        userType: UserType.USER.name,
        name: name.text.trim(),
        email: email.text.trim(),
        phone: phone.text.trim(),
        gender: gender.dropDownValue!.value,
        address: address.text.trim(),
        date: date.text.trim(),
        nGOData: NGOData(
          // Save User Profile Pic
          pic: await StorageRepository.instance.uploadProfilePhoto(
            user.user!.uid,
            File(pic.value!.path),
          ),
        ),
      );
      customLog(isEditProfile);
      if (isEditProfile) {
        customLog(newUser.id);
        // await UserRepository.instance.updateUserData(newUser);
      } else {
        // Save Registered User Data in Firestore
        final userRepository = Get.put(UserRepository());
        await userRepository.saveUserData(newUser);
      }
      // Move to Verify Email Screen
      successToast("Congratulations!");
    } catch (e) {
      // customLog("Ran into Exception, $e");
      // errorToast('Something went wrong!');
    } finally {
      loading = false;
    }
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
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

class NgoRegisterController extends GetxController {
  static NgoRegisterController get instance => Get.find();

  final RxBool _loading = false.obs;
  bool get loading => _loading.value;
  set loading(value) => _loading.value = value;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final desc = TextEditingController();
  final headName = TextEditingController();
  final date = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final isVisible = false.obs;
  final phone = TextEditingController();
  final gender = SingleValueDropDownController();
  final address = TextEditingController();
  final lat = TextEditingController();
  final lon = TextEditingController();
  GeoPoint? geoPoint;

  final _isPicSelected = false.obs;
  bool get isPicSelected => _isPicSelected.value;
  set isPicSelected(value) => _isPicSelected.value = value;

  late Rx<XFile?> pic;

  File? file;
  final fileName = TextEditingController();
  // final geoPoint =

  Future<void> ngoSignUp() async {
    try {
      loading = true;
      // Check if the connected to Internet or not
      // final connected = await NetworkManager.instance.isConnected();
      // if (!connected) {
      //   errorToast("No Internet Connection!");
      //   return;
      // }

      // Validate the form

      if (!formKey.currentState!.validate()) {
        customLog("Validation Failed!");
        return;
      }
      if (isPicSelected == false) {
        customLog("Profile Pic Not Selected!");
        errorToast("Please Select Profile pic");
        return;
      }

      customLog("NGO name: ${name.text.capitalize!.toUpperCase().trim()}");
      customLog("NGO Desc: ${desc.text.trim()}");
      customLog("NGO Head: ${headName.text.capitalize.toString().trim()}");
      customLog("Date of Registration: ${date.text.trim()}");
      customLog("Email: ${email.text.trim()}");
      customLog("Password: ${password.text.trim()}");
      customLog("Phone: ${phone.text.trim()}");
      customLog("Gender: ${gender.dropDownValue!.value.trim()}");
      customLog("Address: ${address.text.capitalize.toString().trim()}");
      GeoPoint geo = GeoPoint(
        double.tryParse(lat.text.trim())!.toDouble(),
        double.tryParse(lon.text.trim())!.toDouble(),
      );
      customLog("GeoPoint: ${geo.latitude}");

      // Register User in Firebase Authentication

      // Register User in Firebase Authentication
      final user =
          await AuthenticationRepository.instance.registerWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );

      final storageRepo = Get.put(StorageRepository());
      final picUrl = await storageRepo.uploadProfilePhoto(
          user.user!.uid, File(pic.value!.path));
      final url = await storageRepo.uploadAddressProof(user.user!.uid, file!);
      customLog(url);

      final newUser = UserModel(
        id: user.user!.uid,
        userType: UserType.NGO.name,
        name: headName.text.capitalize.toString().trim(),
        email: email.text.trim(),
        phone: phone.text.trim(),
        gender: gender.dropDownValue!.value.trim(),
        address: address.text.capitalize.toString().trim(),
        date: date.text.trim(),
        nGOData: NGOData(
          name: name.text.trim(),
          desc: desc.text.trim(),
          location: geo,
          pic: picUrl,
          addressProof: url.toString(),
        ),
      );

      // // Save Registered User Data in Firestore
      final userRepository = Get.put(UserRepository());
      await userRepository.saveUserData(newUser);
//
      // Move to Verify Email Screen
      successToast("Congratulations!");
      //   final user =
      //       await AuthenticationRepository.instance.registerWithEmailAndPassword(
      //     email.text.trim(),
      //     password.text.trim(),
      //   );

      //   final newUser = UserModel(
      //     id: user.user!.uid,
      //     userType: UserType.USER.name,
      //     name: name.text.trim(),
      //     email: email.text.trim(),
      //     phone: phone.text.trim(),
      //     gender: gender.dropDownValue!.value,
      //     address: address.text.trim(),
      //     date: date.text.trim(),
      //     nGOData: NGOData(),
      //   );

      //   // Save Registered User Data in Firestore
      //   final userRepository = Get.put(UserRepository());
      //   await userRepository.saveUserData(newUser);

      //   // Move to Verify Email Screen
      //   successToast("Congratulations!");
      //   Get.offAll(() => HomeScreen());
    } catch (e) {
      customLog("Ran into Exception, $e");
      errorToast('Something went wrong!');
    } finally {
      loading = false;
    }
  }
}

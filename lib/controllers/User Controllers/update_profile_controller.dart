import 'dart:io';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/Repositories/Storage/storage_repository.dart';
import 'package:hope_project/Repositories/User/user_repository.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/drawerController.dart';
import 'package:hope_project/models/user_model.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileController extends GetxController {
  static UpdateProfileController get instance => Get.find();

  final _loading = false.obs;
  bool get loading => _loading.value;
  set loading(value) => _loading.value = value;

  final _isNewImg = false.obs;
  bool get isNewImg => _isNewImg.value;
  set isNewImg(value) => _isNewImg.value = value;

  late Rx<XFile?> pic;

  late UserModel? user;
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phone = TextEditingController();
  final date = TextEditingController();
  final gender = SingleValueDropDownController();
  final address = TextEditingController();
  Rx<String?> url = ''.obs;

  @override
  void onReady() {
    user = AuthenticationRepository.instance.currentUser!;
    assignValues();
    super.onReady();
  }

  assignValues() {
    url.value = user!.nGOData!.pic!;
    name.text = user!.name!;
    email.text = user!.email!;
    phone.text = user!.phone!;
    date.text = user!.date!;
    gender.dropDownValue =
        DropDownValueModel(name: user!.gender.toString(), value: user!.gender);
    address.text = user!.address!;
  }

  @override
  void onClose() {
    CustomDrawerController.instance.selectedIndex = 1;
    super.onClose();
  }

  updateUser() async {
    try {
      loading = true;
      if (isNewImg == true) {
        final storageRepo = Get.put(StorageRepository());
        await storageRepo.uploadProfilePhoto(user!.id!, File(pic.value!.path));
        customLog("Uploaded New Image");
      }
      user!.address = address.text.capitalize!.trim().toString();

      await UserRepository.instance.updateUserData(user as UserModel);

      successToast("User Updated Successfully!");

      Get.back();
    } catch (e) {
      customLog(e);
    } finally {
      loading = false;
    }
  }
}

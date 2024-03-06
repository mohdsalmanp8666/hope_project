import 'dart:io';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/Repositories/Storage/storage_repository.dart';
import 'package:hope_project/Repositories/User/user_repository.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/models/user_model.dart';
import 'package:image_picker/image_picker.dart';

class NGOProfileUpdateController extends GetxController {
  static NGOProfileUpdateController get instance => Get.find();

  // static NGOProfileUpdateController? get instance {
  //   _instance ??= Get.put(NGOProfileUpdateController());
  //   return _instance;
  // }

  final _loading = false.obs;
  bool get loading => _loading.value;
  set loading(value) => _loading.value = value;

  final _isNewImg = false.obs;
  bool get isNewImg => _isNewImg.value;
  set isNewImg(value) => _isNewImg.value = value;

  late Rx<XFile?> pic;

  late UserModel? user;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ngoName = TextEditingController();
  final ngoDesc = TextEditingController();
  final head = TextEditingController();
  final date = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final address = TextEditingController();
  final gender = SingleValueDropDownController();
  Rx<String?> url = ''.obs;

  @override
  void onReady() {
    user = AuthenticationRepository.instance.currentUser!;
    assignValues();
    super.onReady();
  }

  assignValues() {
    url.value = user!.nGOData!.pic!;
    ngoName.text = user!.nGOData!.name!;
    ngoDesc.text = user!.nGOData!.desc!;
    head.text = user!.name!;
    date.text = user!.date!;
    email.text = user!.email!;
    phone.text = user!.phone!;
    address.text = user!.address!;
    gender.dropDownValue =
        DropDownValueModel(name: user!.gender.toString(), value: user!.gender);
  }

  updateUser() async {
    try {
      loading = true;
      if (isNewImg == true) {
        final storageRepo = Get.put(StorageRepository());
        await storageRepo.uploadProfilePhoto(user!.id!, File(pic.value!.path));
        customLog("Uploaded New Image");
      }
      user!.nGOData!.desc = ngoDesc.text.trim().toString();
      user!.name = head.text.capitalize!.trim().toString();
      user!.gender =
          gender.dropDownValue!.name.capitalizeFirst!.trim().toString();
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

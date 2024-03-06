import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/Repositories/Post/post_repository.dart';
import 'package:hope_project/Repositories/Storage/storage_repository.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/models/post_model.dart';
import 'package:image_picker/image_picker.dart';

class AddPostController extends GetxController {
  static AddPostController get instance => Get.find();

  final _loading = false.obs;
  bool get loading => _loading.value;
  set loading(value) => _loading.value = value;

  final _isImagePresent = false.obs;
  bool get isImagePresent => _isImagePresent.value;
  set isImagePresent(value) => _isImagePresent.value = value;

  XFile? pic;
  final captions = TextEditingController();
  final startDate = TextEditingController();
  final endDate = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  clearForm() {
    isImagePresent = false;
    captions.clear();
    startDate.clear();
    endDate.clear();
  }

  createPost() async {
    try {
      loading = true;

      if (!isImagePresent) {
        errorToast("Please select Image!");
        return;
      }

      if (!formKey.currentState!.validate()) {
        customLog("Validation Failed!");
        return;
      }

      final storageRepo = Get.put(StorageRepository());
final user = AuthenticationRepository.instance.currentUser!;
      final id = user.id;
      final ngoName = user.nGOData!.name;
      final ngoPic = user.nGOData!.pic;

      var post = PostModel(
          ngoID: id,
          ngoName: ngoName,
          ngoPic: ngoPic,
          image: await storageRepo.uploadPostImage(
            id.toString(),
            File(pic!.path),
          ),
          caption: captions.text.trim(),
          startDate: Timestamp.fromDate(
              DateTime.tryParse(startDate.text.trim()) as DateTime),
          endDate: Timestamp.fromDate(
              DateTime.tryParse(endDate.text.trim()) as DateTime),
          addedOn: Timestamp.now());

      // final postRepo = Get.put(PostRepository());
      await PostRepository.instance.addPost(post);
      successToast("Post Added Successfully!");
      clearForm();
    } catch (e) {
    } finally {
      loading = false;
    }
  }
}

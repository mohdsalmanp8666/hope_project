import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';

class StorageRepository extends GetxController {
  static StorageRepository get instance => Get.find();

  final storage = FirebaseStorage.instance.ref();

  Future<String?> uploadAddressProof(String uid, File file) async {
    try {
      var ref =
          storage.child('/address_proofs/$uid.${file.path.split('.').last}');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      customLog("Firebase Firestore Exception, ${e.message}");
      return throw errorToast("Something went wrong!");
    } catch (e) {
      customLog(e);
      return throw customLog(e);
    }
  }

  Future<String?> uploadProfilePhoto(String uid, File file) async {
    try {
      var ref = storage.child('/profile_pic/$uid.${file.path.split('.').last}');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      customLog("Firebase Firestore Exception, ${e.message}");
      return throw errorToast("Something went wrong!");
    } catch (e) {
      customLog(e);
      return throw customLog(e);
    }
  }
}

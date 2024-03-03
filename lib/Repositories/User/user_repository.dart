import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

// Function to fetch User Data from Firestore
  Future getUserData(String userId) async {
    try {
      return await _db
          .collection('users')
          .where("id", isEqualTo: userId)
          .limit(1)
          .get()
          .then((value) => value.docs[0].data());
    } on FirebaseException catch (e) {
      customLog("Ran Into Firebase Exception");
      throw errorToast(e.code);
    } on FormatException catch (e) {
      customLog("Ran into format Exception");
      throw errorToast(e);
    } on PlatformException catch (e) {
      customLog("Ran into Platform Exception");
      throw errorToast(e.code);
    } catch (e) {
      throw customLog("Ran into $e");
    }
  }

  // Function to store User data to Firestore
  Future<void> saveUserData(UserModel user) async {
    try {
      customLog(user.toJson());
      await _db.collection('users').doc(user.id).set(user.toJson());
    } on FirebaseException catch (e) {
      customLog("Ran Into Firebase Exception");
      throw errorToast(e.code);
    } on FormatException catch (e) {
      customLog("Ran into format Exception");
      throw errorToast(e);
    } on PlatformException catch (e) {
      customLog("Ran into Platform Exception");
      throw errorToast(e.code);
    } catch (e) {
      throw errorToast(e);
    }
  }

  // Function to update User Data to Firestore
  Future<void> updateUserData(UserModel user) async {
    try {
      customLog("In Update Method of User Repo ${user.id}");
      await _db.collection('users').doc(user.id).update(user.toJson());
    } on FirebaseException catch (e) {
      customLog("Ran Into Firebase Exception");
      throw errorToast(e.code);
    } on FormatException catch (e) {
      customLog("Ran into format Exception");
      throw errorToast(e);
    } on PlatformException catch (e) {
      customLog("Ran into Platform Exception");
      throw errorToast(e.code);
    } catch (e) {
      throw errorToast(e);
    }
  }
}

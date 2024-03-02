import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';

class NGORepository extends GetxController {
  static NGORepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // registerNGO(){
  //   try {
  //     await _db.collection('')
  //  } on FirebaseException catch (e) {
  //     customLog("Firebase Firestore Exception, ${e.message}");
  //     throw errorToast("Something went wrong!");
  //   } catch (e) {
  //     customLog(e);
  //   }
  // }

  getNGODetails(String ngoID) async {
    try {
      customLog("Inside Single NGO Data Repo");
      return await _db
          .collection('users')
          .doc(ngoID)
          .get()
          .then((value) => value);
    } on FirebaseException catch (e) {
      customLog("Firebase Firestore Exception, ${e.message}");
      throw errorToast("Something went wrong!");
    } catch (e) {
      customLog(e);
    }
  }

  getNGORequirements(String ngoID) async {
    try {
      return await _db
          .collection('requirements')
          .where('id', isEqualTo: ngoID)
          .get();
    } on FirebaseException catch (e) {
      customLog("Firebase Firestore Exception, ${e.message}");
      throw errorToast("Something went wrong!");
    } catch (e) {
      customLog(e);
    }
  }

  loadNGO() async {
    try {
      return await _db
          .collection('users')
          .where('userType', isEqualTo: "NGO")
          .limit(5)
          .get()
          .then((value) => value.docs);
    } on FirebaseException catch (e) {
      customLog("Firebase Firestore Exception, ${e.message}");
      throw errorToast("Something went wrong!");
    } catch (e) {
      customLog(e);
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/models/post_model.dart';

class PostRepository extends GetxController {
  static PostRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  addPost(PostModel post) async {
    try {
      return await _db.collection('posts').doc().set(post.toJson());
    } on FirebaseException catch (e) {
      return throw successToast(e.message);
    } catch (e) {
      return throw errorToast(e.toString());
    }
  }

  getPost(String id) async {
    try {
      customLog("Inside Get Posts");
      customLog(id);
      return await _db
          .collection('posts')
          .where('ngoID', isEqualTo: id)
          .get()
          .then((value) {
        customLog(value.docs);
        return value.docs;
      });
    } on FirebaseException catch (e) {
      return throw successToast(e.message);
    } catch (e) {
      return throw errorToast(e.toString());
    }
  }
}

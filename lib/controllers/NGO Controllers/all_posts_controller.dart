import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/Repositories/Post/post_repository.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/models/post_model.dart';

class AllPostsController extends GetxController {
  static AllPostsController get instance => Get.find();

  final _loading = false.obs;
  bool get loading => _loading.value;
  set loading(value) => _loading.value = value;

  List<PostModel?> posts = [];

  Rx<int> rows = 0.obs;

  @override
  void onReady() {
    getPosts();
    super.onReady();
  }

  getPosts() async {
    try {
      loading = true;

      final List<QueryDocumentSnapshot?> result = await PostRepository.instance
          .getPost(
              AuthenticationRepository.instance.currentUser!.id.toString());

      posts = result
          .map((val) => PostModel.fromJson(val!.data() as Map<String, dynamic>))
          .toList();

      calculateNumberOfRows(1);
      // for (var d in data) {
      //   customLog(PostModel.fromJson(d));
      // }
// posts = List.from(elements)
      customLog(rows.value);
    } catch (e) {
      exceptionToast();
      customLog(e);
    } finally {
      loading = false;
    }
  }

  calculateNumberOfRows(int length) {
    if (length != 0) {
      rows.value = (length / 3).ceil();
    }
  }
}

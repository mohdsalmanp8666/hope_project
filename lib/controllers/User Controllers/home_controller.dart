import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/NGO/ngo_repository.dart';
import 'package:hope_project/Repositories/Post/post_repository.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/models/post_model.dart';
import 'package:hope_project/models/user_model.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final _isEndOfPage = false.obs;
  get isEndOfPage => _isEndOfPage.value;
  set isEndOfPage(value) => _isEndOfPage.value = value;

  final _loading = false.obs;
  bool get loading => _loading.value;
  set loading(value) => _loading.value = value;

  final _ngoLoading = false.obs;
  bool get ngoLoading => _ngoLoading.value;
  set ngoLoading(value) => _ngoLoading.value = value;

  final _feedsLoading = false.obs;
  bool get feedsLoading => _feedsLoading.value;
  set feedsLoading(value) => _feedsLoading.value = value;

  Rx<List<UserModel?>> data = Rx<List<UserModel?>>([]);
  List<PostModel?> posts = [];

  @override
  void onInit() {
    Get.put(NGORepository());
    Get.put(PostRepository());
    loadNGOData();
    loadRecentFeeds();
    super.onInit();
  }

  loadNGOData() async {
    try {
      ngoLoading = true;

      final List<QueryDocumentSnapshot?> result =
          await NGORepository.instance.loadNGO();

      data.value = result
          .map((val) => UserModel.fromJson(val!.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      customLog("Ran into Error while NGO Loading Data: $e");
    } finally {
      ngoLoading = false;
    }
  }

  loadRecentFeeds() async {
    try {
      feedsLoading = true;

      final List<QueryDocumentSnapshot?> result =
          await PostRepository.instance.recentPosts();

      posts = result
          .map((val) => PostModel.fromJson(val!.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      customLog(e);
    } finally {
      feedsLoading = false;
    }
  }
}

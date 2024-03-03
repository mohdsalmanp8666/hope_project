import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/NGO/ngo_repository.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/models/user_model.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final _isEndOfPage = false.obs;
  get isEndOfPage => _isEndOfPage.value;
  set isEndOfPage(value) => _isEndOfPage.value = value;

  final _loading = false.obs;
  bool get loading => _loading.value;
  set loading(value) => _loading.value = value;

  Rx<List<UserModel?>> data = Rx<List<UserModel?>>([]);
// late Rx<UserModel?> ngoData;
//   @override
//   void onReady() {
//     // TODO: implement onReady

// ngoData = await NGORepository.instance.loadNGO()

//     super.onReady();
//   }

  @override
  void onInit() {
    Get.put(NGORepository());
    loadNGOData();
    scrollController.addListener((_scrollListener));
    super.onInit();
  }

  loadNGOData() async {
    try {
      loading = true;

      final List<QueryDocumentSnapshot?> result =
          await NGORepository.instance.loadNGO();

      data.value = result
          .map((val) => UserModel.fromJson(val!.data() as Map<String, dynamic>))
          .toList();

      customLog(data.value);
      // for (var ngo in result) {
      //   customLog(ngo?.data());
      // }
    } catch (e) {
      customLog("Ran into Error while loading Data: $e");
    } finally {
      loading = false;
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      isEndOfPage = true;
    } else {
      isEndOfPage = false;
    }
  }

  final List<NGODetails> ngo = [
    NGODetails(
      img:
          'https://shikshafoundation.org/wp-content/uploads/2019/11/shikshalogo.png',
      ngoName: 'Shiksha Foundation',
      ngoDesc:
          "A CHARITABLE TRUST, formed for a noble cause to nurture underprivileged children’s education section in the society. Shiksha foundation was started in 2007 and Registered on 29th March2011 under the BPT ACT 1950, with the registration number 1673. Order under section 80G (5) (vi) of the income tax act, 1961 NQ. CIT (E) I2014-15/DEL SE25786-08012015/5880 PAN NO. AAKTS4253M",
    ),
    NGODetails(
      img: 'https://inner-search.org/images/trust.png',
      ngoName: 'Inner Search Foundation',
      ngoDesc:
          'Inner Search Foundation is a non-profitable charitable trust founded on the 13th November 2000 under the Bombay Public Trust Act 1950. It has been established with an objective of helping individuals develop a complete understanding of self at all the three levels and thereby become more effective in their respective fields of influence. The methodology used for this is the age-old practical science and philosophy of Yoga, understood as A Way of Life. Improved physical and mental health, peace of mind, creativity and productivity are the fruits one reaps along the path to complete Self Awareness.',
    ),
  ];
}

class NGODetails {
  final String? img;
  final String? ngoName;
  final String? ngoDesc;

  NGODetails({required this.img, required this.ngoName, required this.ngoDesc});
}

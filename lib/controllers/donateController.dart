import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/NGO/ngo_repository.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/models/UserModel.dart';

class DonateController extends GetxController {
  

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  final _loading = false.obs;
  get loading => _loading.value;
  set loading(value) => _loading.value = value;

  final itemCountController = TextEditingController();

  final _itemErr = false.obs;
  get itemErr => _itemErr.value;
  set itemErr(value) => _itemErr.value = value;

  final _isPickup = false.obs;
  get isPickup => _isPickup.value;
  set isPickup(value) => _isPickup.value = value;

  // ! Clothes Related Variables & functions

  final _choiceIndex = 0.obs;
  get choiceIndex => _choiceIndex.value;
  set choiceIndex(value) => _choiceIndex.value = value;
  List<String> choices = ['Clothes', 'Food', 'Books', 'Others'];

  final Rx<List<String>> _clothesFor = Rx([]);
  List<String> get clothesFor => _clothesFor.value;
  set clothesFor(value) => _clothesFor.value = value;
  List<String> clothesForList = ['Men', 'Women', 'Kids'];
  final _clothesForErr = false.obs;
  get clothesForErr => _clothesForErr.value;
  set clothesForErr(value) => _clothesForErr.value = value;

  final Rx<List<String>> _clothesTypeSelected = Rx([]);
  List<String> get clothesTypeSelected => _clothesTypeSelected.value;
  set clothesTypeSelected(value) => _clothesTypeSelected.value = value;

  final _clothesTypeErr = false.obs;
  get clothesTypeErr => _clothesTypeErr.value;
  set clothesTypeErr(value) => _clothesTypeErr.value = value;

  List<String> clothesType = [
    'Shirt',
    'T-Shirt',
    'Pant/Jeans',
    'Shorts',
    'Trouser',
    'Coats',
    'Suit',
    'Top',
  ];

  // TODO: Have to make chips dynamic
  updateClothesType(List<String> data) {
    customLog(data);
  }

  List<String> menClothesType = [
    'Shirt',
    'T-Shirt',
    'Pant/Jeans',
    'Shorts',
    'Trouser',
    'Coats'
  ];

  List<String> womenClothesType = ['Suit', 'Shirt', 'Pants', 'Top', 'Coats'];
  List<String> kidClothesType = ['Suit', 'Shorts'];

  bool genderValidation() {
    clothesForErr = false;
    if (clothesFor.isEmpty) {
      clothesForErr = true;
      return false;
    }
    return true;
  }

  bool typeValidation() {
    clothesTypeErr = false;
    if (clothesTypeSelected.isEmpty) {
      clothesTypeErr = true;
      return false;
    }
    return true;
  }

  bool itemCountValidation() {
    itemErr = false;
    if (itemCountController.text.isEmpty) {
      itemErr = true;
      return false;
    }
    return true;
  }

  // ! Food Related Variables and Functions
  final Rx<List<String>> _foodType = Rx([]);
  List<String> get foodType => _foodType.value;
  set foodType(value) => _foodType.value = value;
  List<String> foodTypeList = ['Cooked', 'Ration', 'Groceries'];
  final _foodTypeErr = false.obs;
  get foodTypeErr => _foodTypeErr.value;
  set foodTypeErr(value) => _foodTypeErr.value = value;

  formValidation() {
    if (genderValidation() && typeValidation() && itemCountValidation()) {
      return true;
    }
    return false;
  }

  generateDonateRequest() async {
    loading = true;
    try {
      await Future.delayed(const Duration(seconds: 2));
      if (formValidation()) {
        loading = false;
        return true;
      } else {
        customLog("Validation Failed!");
        loading = false;
        return false;
      }
    } catch (e) {}
    loading = false;
  }
}

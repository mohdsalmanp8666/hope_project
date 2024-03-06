import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/Repositories/Donation/donation_repository.dart';
import 'package:hope_project/Repositories/NGO/ngo_repository.dart';
import 'package:hope_project/UI/User/home_screen.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/models/donate_model.dart';
import 'package:hope_project/models/user_model.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

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
  final desc = TextEditingController();

  final _itemErr = false.obs;
  get itemErr => _itemErr.value;
  set itemErr(value) => _itemErr.value = value;

  final _isPickup = false.obs;
  get isPickup => _isPickup.value;
  set isPickup(value) => _isPickup.value = value;

  resetErrors() {
    clothesFor.clear();
    clothesTypeSelected.clear();
    clothesTypeErr = false;
    clothesForErr = false;
    foodsTypeSelected.clear();
    foodTypeErr = false;
    booksTypeSelected.clear();
    bookTypeErr = false;
    itemErr = false;
  }

  // ! Clothes Related Variables & functions

  final Rx<String> _choiceIndex = Rx<String>(DonationType.Clothes.name);
  get choiceIndex => _choiceIndex.value;
  set choiceIndex(value) => _choiceIndex.value = value;

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
    'Others'
  ];

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

  // ! Food Related Variables and Functions
  final Rx<List<String>> _foodType = Rx([]);
  List<String> get foodType => _foodType.value;
  set foodType(value) => _foodType.value = value;
  List<String> foodTypeList = ['Cooked', 'Ration', 'Groceries'];

  final Rx<List<String>> _foodsTypeSelected = Rx([]);
  List<String> get foodsTypeSelected => _foodsTypeSelected.value;
  set foodsTypeSelected(value) => _foodsTypeSelected.value = value;
  final _foodTypeErr = false.obs;
  bool get foodTypeErr => _foodTypeErr.value;
  set foodTypeErr(value) => _foodTypeErr.value = value;

  bool foodTypeValidation() {
    foodTypeErr = false;
    if (foodsTypeSelected.isEmpty) {
      foodTypeErr = true;
      return false;
    }
    return true;
  }

  // ! Book Related Variables and Functions
  final Rx<List<String>> _bookType = Rx([]);
  List<String> get bookType => _bookType.value;
  set bookType(value) => _bookType.value = value;
  List<String> bookTypeList = [
    'Notebooks',
    'Textbooks',
    'Fiction',
    'Non-Fictions',
    'Others'
  ];
  final Rx<List<String>> _booksTypeSelected = Rx([]);
  List<String> get booksTypeSelected => _booksTypeSelected.value;
  set booksTypeSelected(value) => _booksTypeSelected.value = value;
  final _bookTypeErr = false.obs;
  get bookTypeErr => _bookTypeErr.value;
  set bookTypeErr(value) => _bookTypeErr.value = value;

  bool bookTypeValidation() {
    bookTypeErr = false;
    if (booksTypeSelected.isEmpty) {
      bookTypeErr = true;
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

  formValidation(String type) {
    if (type == DonationType.Clothes.name) {
      // * Validate Clothes Donation Field
      customLog("Inside Clothes Validation");
      if (!genderValidation() && !typeValidation()) {
        return false;
      }
    }
    if (type == DonationType.Food.name) {
      // * Validation Food Donation Fields
      customLog("Inside Food Validation");
      if (!foodTypeValidation()) return false;
    }
    if (type == DonationType.Books.name) {
      // * Validation Books Donation Fields
      customLog("Inside Books Validation");
      if (!bookTypeValidation()) return false;
    }

    if (!itemCountValidation()) {
      customLog("Inside Item count validation");
      return false;
    }
    return true;
  }

  generateDonateRequest(BuildContext context, UserModel ngo) async {
    try {
      loading = true;
      if (!formValidation(choiceIndex)) {
        return;
      }

      var donationRequest = DonationModel(
        userId: AuthenticationRepository.instance.currentUser!.id,
        userName: AuthenticationRepository.instance.currentUser!.name,
        ngoId: ngo
            .id, //  await NGORepository.instance.getNGOReference(ngo.id.toString()),
        ngoName: ngo.name,
        status: DonationStatus.Pending.name,
        donationType: choiceIndex,
        numberOfItems: int.tryParse(itemCountController.text.trim().toString()),
        mode: isPickup
            ? DonationDeliveryType.PickUp.name
            : DonationDeliveryType.DropOff.name,
        address: isPickup
            ? AuthenticationRepository.instance.currentUser!.address
            : ngo.address,
        addedOn: Timestamp.now(),
        clothes: ClothesModel(
            clothesFor: clothesFor, clothesType: clothesTypeSelected),
        food: FoodsModel(foodType: foodsTypeSelected),
        books: BooksModel(bookType: booksTypeSelected),
      );

      Get.put(DonationRepository());
      await DonationRepository.instance.generateRequest(donationRequest);
      await Future.delayed(const Duration(seconds: 2));
      // if (formValidation()) {
      //   loading = false;
      //   return true;
      // } else {
      //   customLog("Validation Failed!");
      //   loading = false;
      //   return false;
      // }
      PanaraInfoDialog.show(
        context,
        imagePath: 'assets/images/verified.png',
        title: "Thank You",
        message:
            "Your donation request has been successfully submitted to the NGO.",
        buttonText: "Go to Home Page",
        onTapDismiss: () => Get.offAll(() => HomeScreen()),
        // Get.offAndToNamed(Routes.homeScreen),
        color: mainColor,
        panaraDialogType: PanaraDialogType.custom,
        barrierDismissible: false,
      );
    } catch (e) {
    } finally {
      loading = false;
    }
  }
}

import 'package:get/get.dart';

class CustomDrawerController extends GetxController {
  static CustomDrawerController get instance => Get.find();

  // Index for Navigation between Screens

  final _selectedIndex = 1.obs;
  get selectedIndex => _selectedIndex.value;
  set selectedIndex(value) => _selectedIndex.value = value;
}

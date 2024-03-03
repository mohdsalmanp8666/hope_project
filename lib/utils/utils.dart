// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:hope_project/UI/User/homeScreen.dart';
// import 'package:hope_project/UI/User/user_register_screen.dart';
// import 'package:hope_project/controllers/authController.dart';
// import 'package:hope_project/models/UserDataModelSingleton.dart';
// import 'package:hope_project/models/UserModel.dart';

// class Utils {
//   // static Future<void> setCurrentUserData(Map<String, dynamic> userData) async {
//   //   UserDataModelSingleton.instance?.currentUserData =
//   //       UserModel.fromJson(userData);
//   //   // final pref = await SharedPreferences.getInstance();
//   //   // pref.setString(key, value)
//   // }

//   static void navigateUserToNextPage(
//     User user,
//     AuthController authController, {
//     bool isLoggedIn = false,
//   }) async {
//     // * After Successful google sign in check if the user data exists in Firestore
//     Map<String, dynamic> userData =
//         await authController.doesUserExists(uid: user.uid);
//     if (userData.isNotEmpty) {
//       Utils.setCurrentUserData(userData);
//       // If User exists Navigate to home page
//       // Get.offAllNamed(Routes.homeScreen);
//       Get.offAll(() => HomeScreen());
//     } else {
//       // Navigate to register screen
//       // Get.offAllNamed(Routes.userRegister);
//       Get.offAll(() => UserRegisterScreen());
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/User/user_repository.dart';
import 'package:hope_project/UI/NGO/ngo_dashboard_screen.dart';
import 'package:hope_project/UI/User/homeScreen.dart';
import 'package:hope_project/UI/login_screen.dart';
import 'package:hope_project/UI/verify_email_screen.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/models/user_model.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;

  UserModel? currentUser;

  // late final Rx<UserModel?> user;
  @override
  void onReady() {
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, setInitialScreen);
  }

  setInitialScreen(User? user) async {
    customLog("Inside Set Initial Screen");
    if (user == null) {
      customLog("No user Logged In");
      Get.offAll(() => LoginScreen());
    } else {
      customLog("User Present");
      Get.put(UserRepository());
// final result = await UserRepository.instance.getUserData(user.uid);
      if (user.emailVerified) {
        customLog("Email Verified User");

        currentUser = UserModel.fromJson(
            await UserRepository.instance.getUserData(user.uid));
        if (currentUser!.userType == UserType.USER.name) {
          Get.offAll(() => HomeScreen());
        } else {
          Get.offAll(() => NgoDashboardScreen());
        }
      } else {
        Get.offAll(() => VerifyEmailScreen(
              email: user.email,
            ));
      }
//        UserDataModelSingleton.instance!.currentUserData =
    }
  }

  //

  // ! Email and Password Sign in

  // * Email Authentication [SignIn]
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      customLog(e.code);
      switch (e.code) {
        case 'invalid-password':
          return successToast("Invalid Password");
        case 'invalid-email':
          return successToast("Invalid Email");
        case 'invalid-credential':
          return successToast('Invalid Email/password');
        default:
          return successToast("Something else");
      }
    } catch (e) {
      customLog("Inside Exception: $e");
      errorToast("Something went wrong!");
    }
  }

  // * Email Authentication [SignUp]
  Future<UserCredential> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      customLog("Inside Repository:\nEmail: $email\nPassword:$password");

      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw errorToast(e.code);
    } on FirebaseException catch (e) {
      throw errorToast(e.code);
    } catch (e) {
      throw errorToast(e);
    }
  }

  // * ReAuthenticate
  // * Email Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw errorToast(e.code);
    } on FirebaseException catch (e) {
      throw errorToast(e.code);
    } catch (e) {
      throw errorToast(e);
    }
  }

  // * Forgot Password
  forgotPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(
        email: email,
      );
    } on FirebaseAuthException catch (e) {
//       May throw a [FirebaseAuthException] with the following error codes:

// auth/invalid-email
// Thrown if the email address is not valid.
// auth/missing-android-pkg-name
// An Android package name must be provided if the Android app is required to be installed.
// auth/missing-continue-uri
// A continue URL must be provided in the request.
// auth/missing-ios-bundle-id
// An iOS Bundle ID must be provided if an App Store ID is provided.
// auth/invalid-continue-uri
// The continue URL provided in the request is invalid.
// auth/unauthorized-continue-uri
// The domain of the continue URL is not whitelisted. Whitelist the domain in the Firebase console.
// auth/user-not-found
// Thrown if there is no user corresponding to the email address.
      if (e.code == 'user-not-found') {
        customLog("Hey");
        throw errorToast(e.code);
      }
      customLog(e.code);
    } on FirebaseException catch (e) {
      throw errorToast(e.code);
    } catch (e) {
      throw errorToast(e);
    }
  }

  // ! Social Login

  // * SignIn with Google [GoogleAuthentication]

  // !
  // * Logout User
  Future<void> logoutUser() async => await _auth.signOut();
  // * Delete User
}

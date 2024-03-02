import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController {
  Future<User?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    final result = await FirebaseAuth.instance.signInWithCredential(credential);
    return result.user;
  }

  // * Check if the user data exists or not in FireStore Firebase
  Future<Map<String, dynamic>> doesUserExists({required String uid}) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      return userData.data() ?? {};
    } catch (e) {
      customLog("Error Checking if user exists: $e");
      return {};
    }
  }

  Future<void> logoutUser() async {
    await FirebaseAuth.instance.signOut();
  }
}

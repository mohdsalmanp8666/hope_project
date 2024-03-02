import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/firebase_options.dart';

Future<void> main() async {
  // * Widget Binding
  WidgetsFlutterBinding.ensureInitialized();

  // * Firebase Initialization & Authentication Repository
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((value) => Get.put(AuthenticationRepository()));
  

  // * Main Run
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Project Hope',
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: customLoadingAnimation(),
          ),
        ),
      ),
    );
  }
}

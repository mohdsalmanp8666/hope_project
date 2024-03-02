import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: AutoSizeText("Hope Project"),
        ),
      ),
    );
  }
}

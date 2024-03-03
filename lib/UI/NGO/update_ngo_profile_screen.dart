import 'package:flutter/material.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/globals.dart';

class UpdateNGOScreen extends StatelessWidget {
  const UpdateNGOScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSize(
        context,
        child: CustomAppbar(
          leading: customBackButton(),
          title: "NGO Profile",
        ),
      ),
    );
  }
}

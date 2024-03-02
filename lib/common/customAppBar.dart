import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:hope_project/common/globals.dart';

class CustomAppbar extends StatelessWidget {
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  const CustomAppbar({super.key, this.title, this.leading, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: mainColor,
      automaticallyImplyLeading: false,
      leading: leading,
      title: AutoSizeText(
        "$title",
        maxLines: 1,
        minFontSize: 17,
        style: customTextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      actions: actions,
    );
  }
}

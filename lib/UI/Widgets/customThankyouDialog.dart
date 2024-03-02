import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';

class CustomThankyouDialog extends StatelessWidget {
  const CustomThankyouDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return PanaraInfoDialog.show(
      context,
      title: "Hello",
      message: "This is the PanaraInfoDialog",
      buttonText: "Okay",
      onTapDismiss: () {
        Navigator.pop(context);
      },
      panaraDialogType: PanaraDialogType.normal,
      barrierDismissible: false, // optional parameter (default is true)
    );
  }
}

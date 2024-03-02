import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:material_symbols_icons/symbols.dart';

const defaultPadding = EdgeInsets.symmetric(horizontal: 20);

successToast(msg) {
  Fluttertoast.showToast(msg: msg);
}

exceptionToast() {
  Fluttertoast.showToast(msg: "Something went wrong!");
}

errorToast(err) {
  Fluttertoast.showToast(msg: err.toString(), backgroundColor: Colors.red);
}

TextStyle customTextStyle({
  double fontSize = 20,
  FontWeight fontWeight = FontWeight.normal,
  Color color = Colors.black,
  double letterSpacing = 1,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
  );
}

InputDecoration customInputDecoration({
  required String label,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? errorText,
  bool isDisabled = true,
  String? hintText,
}) {
  return InputDecoration(
    labelText: label,
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
    alignLabelWithHint: true,
    counter: const SizedBox(),
    errorText: errorText,
    filled: !isDisabled,
    fillColor: Colors.grey.shade200,
    hintText: hintText,
    enabled: isDisabled,
    floatingLabelStyle: customTextStyle(fontSize: 15, color: mainColor),
    border:
        const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    focusedBorder:
        const OutlineInputBorder(borderSide: BorderSide(color: mainColor)),
    disabledBorder:
        const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    enabledBorder:
        const OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
  );
}

// Preferred Size Widget for AppBar
const mainColor = Color(0xFF2196f3);

PreferredSizeWidget appBarSize(BuildContext context, {required Widget child}) {
  return PreferredSize(
    preferredSize: Size(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height * 0.07,
    ),
    child: child,
  );
}

Widget customBackButton() {
  return IconButton(
    onPressed: () => Get.back(),
    icon: const Icon(
      Symbols.arrow_back_ios,
      color: Colors.white,
    ),
  );
}

Widget customLoadingAnimation({Color color = mainColor, double size = 60}) {
  return LoadingAnimationWidget.staggeredDotsWave(color: color, size: size);
}

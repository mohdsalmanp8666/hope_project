import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/NGO%20Controllers/add_post_controller.dart';
import 'package:hope_project/utils/validations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class AddPostScreen extends StatelessWidget {
  AddPostScreen({super.key});

  final addPostController = Get.put(AddPostController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSize(
        context,
        child: CustomAppbar(
          leading: customBackButton(),
          title: "Add Post",
        ),
      ),
      body: SafeArea(
        child: Form(
          key: addPostController.formKey,
          child: Padding(
            padding: defaultPadding,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Gap(20),
                  _imageForPost(context),
                  const Gap(20),
                  TextFormField(
                    minLines: 1,
                    maxLines: 3,
                    cursorColor: mainColor,
                    controller: addPostController.captions,
                    validator: (value) => AppValidator.validateCaptions(value),
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    decoration: customInputDecoration(
                      label: 'Captions',
                    ),
                  ),
                  const Gap(20),
                  // ! Start Date Field
                  TextFormField(
                    readOnly: true,
                    cursorColor: mainColor,
                    controller: addPostController.startDate,
                    validator: (value) => AppValidator.validateDate(value),
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        lastDate: DateTime.now().add(const Duration(days: 10)),
                        firstDate: DateTime.now(),
                        initialDate: DateTime.now(),
                      );
                      if (pickedDate == null) return;
                      addPostController.startDate.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    },
                    decoration: customInputDecoration(label: 'Start Date'),
                  ),
                  const Gap(20),
                  // ! End Date Field
                  TextFormField(
                    readOnly: true,
                    cursorColor: mainColor,
                    controller: addPostController.endDate,
                    validator: (value) => AppValidator.validateDate(value),
                    onTapOutside: (event) =>
                        FocusManager.instance.primaryFocus?.unfocus(),
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        lastDate: DateTime.now().add(const Duration(days: 30)),
                        firstDate: addPostController.startDate.text.isEmpty
                            ? DateTime.now().add(const Duration(days: 1))
                            : DateTime.tryParse(
                                    addPostController.startDate.text)!
                                .add(const Duration(days: 1)),
                        initialDate: addPostController.startDate.text.isEmpty
                            ? DateTime.now().add(const Duration(days: 1))
                            : DateTime.tryParse(
                                    addPostController.startDate.text)!
                                .add(const Duration(days: 1)),
                      );
                      if (pickedDate == null) return;
                      addPostController.endDate.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    },
                    decoration: customInputDecoration(label: 'End Date'),
                  ),
                  const Gap(30),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width - 150,
                    child: ElevatedButton(
                      onPressed: () => addPostController.loading
                          ? successToast("Please wait...")
                          : addPostController.createPost(),
                      style:
                          ElevatedButton.styleFrom(backgroundColor: mainColor),
                      child: Obx(
                        () => addPostController.loading
                            ? Center(
                                child: customLoadingAnimation(
                                  size: 30,
                                  color: Colors.white,
                                ),
                              )
                            : AutoSizeText(
                                'Add Post',
                                maxLines: 1,
                                minFontSize: 20,
                                style: customTextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _imageForPost(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.fromHeight(MediaQuery.of(context).size.height * 0.3),
      child: GestureDetector(
        onTap: () async {
          addPostController.isImagePresent = false;
          addPostController.pic =
              await ImagePicker().pickImage(source: ImageSource.gallery);

          if (addPostController.pic?.path.isNotEmpty ?? false) {
            addPostController.isImagePresent = true;
            customLog("Image Selected!");
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(style: BorderStyle.solid),
          ),
          child: Obx(
            () => addPostController.isImagePresent
                ? Image.file(
                    File(addPostController.pic!.path),
                    filterQuality: FilterQuality.high,
                    fit: BoxFit.fitWidth,
                  )
                : const Icon(
                    Symbols.camera_alt,
                    size: 55,
                    semanticLabel: "Camera Icon",
                  ),
          ),
        ),
      ),
    );
  }
}

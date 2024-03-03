import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/Post/post_repository.dart';
import 'package:hope_project/UI/NGO/add_post_screen.dart';
import 'package:hope_project/UI/NGO/posts_screen.dart';
import 'package:hope_project/UI/NGO/update_ngo_profile_screen.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/globals.dart';

class NgoDashboardScreen extends StatelessWidget {
   NgoDashboardScreen({super.key});

  final postRepo = Get.put(PostRepository());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSize(
        context,
        child: CustomAppbar(
          title:
              'Welcome, ${AuthenticationRepository.instance.currentUser!.nGOData?.name ?? ''}',
          actions: [
            IconButton(
                onPressed: () async {
                  await AuthenticationRepository.instance.logoutUser();
                },
                icon: const Icon(
                  Symbols.exit_to_app,
                  color: Colors.white,
                ))
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: defaultPadding,
            child: Column(
              children: [
                const Gap(25),
                // ? First Button row
                SizedBox.fromSize(
                  size:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
                  child: Row(
                    children: [
                      // * New Post Button
                      _newPostButton(context),
                      const Gap(5),
                      // * Donation History Button
                      _donationHistoryButton(context),
                    ],
                  ),
                ),
                const Gap(25),

                SizedBox.fromSize(
                  size:
                      Size.fromHeight(MediaQuery.of(context).size.height * 0.1),
                  child: Row(
                    children: [
                      // * View Requests Button
                      _viewRequestsButton(context),
                      const Gap(5),
                      // * Profile Button
                      _profileButton(context),
                    ],
                  ),
                ),
                // _viewRequestsButton(context),
                const Gap(25),
                _yourPostsButton(context),
                const Gap(25),
                SizedBox.fromSize(
                  size: const Size.fromHeight(50),
                  child: const AutoSizeText(
                    "Recent Feeds",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _profileButton(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: (MediaQuery.of(context).size.width - 50) / 2,
      child: ElevatedButton(
        onPressed: () => Get.to(() => const UpdateNGOScreen()),
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: AutoSizeText(
          "Profile",
          maxLines: 1,
          minFontSize: 18,
          style: customTextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  SizedBox _viewRequestsButton(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: (MediaQuery.of(context).size.width - 50) / 2,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: AutoSizeText(
          "View Requests",
          maxLines: 1,
          minFontSize: 18,
          style: customTextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  SizedBox _newPostButton(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: (MediaQuery.of(context).size.width - 50) / 2,
      // color: Colors.amber,
      child: ElevatedButton(
        onPressed: () => Get.to(() => AddPostScreen()),
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: AutoSizeText(
          "New Post",
          maxLines: 1,
          minFontSize: 18,
          style: customTextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  SizedBox _donationHistoryButton(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: (MediaQuery.of(context).size.width - 50) / 2,
      // color: Colors.amber,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: AutoSizeText(
          "Donation History",
          maxLines: 1,
          minFontSize: 16,
          style: customTextStyle(
            color: Colors.white,
            fontSize: 22,
          ),
        ),
      ),
    );
  }

  SizedBox _yourPostsButton(BuildContext context) {
    return SizedBox(
      height: (MediaQuery.of(context).size.height * 0.1),
      width: MediaQuery.of(context).size.width - 150,
      child: ElevatedButton(
        onPressed: () => Get.to(() => NGOPosts()),
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: AutoSizeText(
          "Your Posts",
          minFontSize: 20,
          style: customTextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

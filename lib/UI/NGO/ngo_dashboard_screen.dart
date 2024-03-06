import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/Post/post_repository.dart';
import 'package:hope_project/UI/NGO/add_post_screen.dart';
import 'package:hope_project/UI/User/donation_history.dart';
import 'package:hope_project/UI/NGO/donation_requests.dart';
import 'package:hope_project/UI/NGO/posts_screen.dart';
import 'package:hope_project/UI/NGO/update_ngo_profile_screen.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/controllers/User%20Controllers/home_controller.dart';
import 'package:hope_project/models/post_model.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/globals.dart';

class NgoDashboardScreen extends StatelessWidget {
  NgoDashboardScreen({super.key});

  final postRepo = Get.put(PostRepository());
  final homeController = Get.put(HomeController());
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
                  Get.dialog(
                    AlertDialog(
                      title: const Text('Are you sure?'),
                      actions: [
                        // ! Logout Action Call
                        TextButton(
                          onPressed: () async {
                            await AuthenticationRepository.instance
                                .logoutUser();
                            successToast("Successfully Logged out!");
                          },
                          child: Text(
                            "Logout",
                            style: customTextStyle(
                              fontSize: 14,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ],
                    ),
                  );
                  // await AuthenticationRepository.instance.logoutUser();
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                AutoSizeText(
                  "Recent Feeds,",
                  minFontSize: 18,
                  style: customTextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(25),
                SizedBox.fromSize(
                  size: const Size.fromHeight(300),
                  child: Obx(() => homeController.feedsLoading
                      ? Center(
                          child: customLoadingAnimation(),
                        )
                      : homeController.posts.isEmpty
                          ? Center(
                              child: AutoSizeText(
                                "No Posts to show!",
                                maxLines: 1,
                                style: customTextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            )
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                customLog(homeController.posts.length);
                                var post = homeController.posts[index];
                                return SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.75,
                                  child: Card(
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Column(
                                        children: [
                                          _ngoDetails(post),
                                          _postImage(post),
                                          SizedBox.fromSize(
                                            size: const Size.fromHeight(
                                                300 - (150 + 75)),
                                            child: AutoSizeText(
                                              post!.caption.toString(),
                                              maxLines: 3,
                                              wrapWords: true,
                                              minFontSize: 16,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.justify,
                                              style: customTextStyle(),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: ((context, index) {
                                return const Gap(25);
                              }),
                              itemCount: homeController.posts.length,
                            )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox _postImage(PostModel? post) {
    return SizedBox.fromSize(
      size: const Size.fromHeight(150),
      child: Image.network(
        post!.image.toString(),
        fit: BoxFit.cover,
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stackTrace) => Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
          filterQuality: FilterQuality.high,
        ),
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress != null
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    child: Center(
                      child: customLoadingAnimation(
                        size: 28,
                      ),
                    ),
                  )
                : child,
      ),
    );
  }

  SizedBox _ngoDetails(PostModel? post) {
    return SizedBox.fromSize(
      size: const Size.fromHeight(65),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        padding: defaultPadding,
        child: Row(
          children: [
            _ngoProfilePic(post),
            const Gap(5),
            _ngoName(
              post!.ngoName.toString(),
            ),
          ],
        ),
      ),
    );
  }
// SizedBox _ngoDetails(PostModel? post) {
//     return SizedBox.fromSize(
//       size: const Size.fromHeight(65),
//       child: Container(
//         decoration: BoxDecoration(
//           border: Border(
//             bottom: BorderSide(
//               color: Colors.grey.shade400,
//             ),
//           ),
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(15),
//             topRight: Radius.circular(15),
//           ),
//         ),
//         padding: defaultPadding,
//         child: Row(
//           children: [
//             _ngoProfilePic(post),
//             const Gap(5),
//             _ngoName(
//               post!.ngoName.toString(),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

  AutoSizeText _ngoName(String ngoName) {
    return AutoSizeText(
      ngoName,
      maxLines: 1,
      minFontSize: 15,
      overflow: TextOverflow.clip,
      style: customTextStyle(
        fontSize: 18,
      ),
    );
  }

  SizedBox _ngoProfilePic(PostModel? post) {
    return SizedBox.square(
      dimension: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.network(
          "${post!.ngoPic}",
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
        ),
      ),
    );
  }
  SizedBox _profileButton(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: (MediaQuery.of(context).size.width - 50) / 2,
      child: ElevatedButton(
        onPressed: () => Get.to(() => UpdateNGOScreen()),
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
        onPressed: () => Get.to(() => DonationRequests()),
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
        onPressed: () => Get.to(() => DonationHistoryScreen()),
        style: ElevatedButton.styleFrom(
          backgroundColor: mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: AutoSizeText(
          "Donation History",
          maxLines: 1,
          // minFontSize: 16,
          textAlign: TextAlign.center,
          style: customTextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
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

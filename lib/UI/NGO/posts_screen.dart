import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/NGO%20Controllers/all_posts_controller.dart';

class NGOPosts extends StatelessWidget {
  NGOPosts({super.key});

  final postsController = Get.put(AllPostsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSize(
        context,
        child: CustomAppbar(
          leading: customBackButton(),
          title: "NGO Posts",
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ! NGO Profile
            SizedBox.fromSize(
              size: Size.fromHeight(MediaQuery.of(context).size.height * 0.15),
              child: Container(
                // color: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ngoProfilePic(),
                    const Gap(5),
                    _ngoNameAndHeadName(context),
                  ],
                ),
              ),
            ),

            // Expanded(child: Placeholder())
            Obx(
              () => postsController.loading
                  ? Center(
                      child: customLoadingAnimation(),
                    )
                  // : Container(
                  //     child: Text("Loaded the Data"),
                  //   )
                  : Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          var post = postsController.posts[index];
                          return SizedBox.square(
                            dimension: MediaQuery.of(context).size.width / 3,
                            child: GestureDetector(
                              onTap: () => customLog(index),
                              child: Image.network(
                                "${post!.image}",
                                fit: BoxFit.cover,
                                filterQuality: FilterQuality.medium,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset('assets/images/logo.png'),
                                loadingBuilder:
                                    (context, child, loadingProgress) =>
                                        loadingProgress == null
                                            ? child
                                            : Center(
                                                child: customLoadingAnimation(
                                                  size: 26,
                                                ),
                                              ),
                              ),
                            ),
                          );
                        },
                        itemCount: postsController.posts.length,

                        // crossAxisCount: 3,
                        // children: ListView.builder(
                        //   itemCount: postsController.rows.value,
                        //   itemBuilder: (context, index) {
                        //     return Container();
                        //   },
                        // ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _ngoProfilePic() {
    return SizedBox.square(
      dimension: 75,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.network(
          "${AuthenticationRepository.instance.currentUser!.nGOData!.pic}",
          fit: BoxFit.cover,
          filterQuality: FilterQuality.medium,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey,
          ),
          loadingBuilder: (context, child, loadingProgress) =>
              loadingProgress == null
                  ? child
                  : Center(
                      child: customLoadingAnimation(
                        size: 32,
                      ),
                    ),
        ),
      ),
    );
  }

  SizedBox _ngoNameAndHeadName(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.fromWidth(MediaQuery.of(context).size.width - 200),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            "${AuthenticationRepository.instance.currentUser!.nGOData!.name}",
            maxLines: 1,
            minFontSize: 18,
            overflow: TextOverflow.ellipsis,
            style: customTextStyle(
              fontSize: 25,
              letterSpacing: 1.25,
              fontWeight: FontWeight.w600,
            ),
          ),
          AutoSizeText(
            "${AuthenticationRepository.instance.currentUser!.name}",
            maxLines: 1,
            minFontSize: 15,
            overflow: TextOverflow.ellipsis,
            style: customTextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}

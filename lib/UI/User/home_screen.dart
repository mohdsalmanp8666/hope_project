import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/UI/NGO/NGOHome.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/custom_drawer.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/drawerController.dart';
import 'package:hope_project/controllers/User%20Controllers/home_controller.dart';
import 'package:hope_project/models/post_model.dart';
import 'package:hope_project/models/user_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final drawerController = Get.put(CustomDrawerController());
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: appBarSize(
        context,
        child: CustomAppbar(
          leading: const DrawerButton(
            style: ButtonStyle(
              foregroundColor: MaterialStatePropertyAll(Colors.white),
            ),
          ),
          title:
              "Welcome, ${AuthenticationRepository.instance.currentUser!.name.toString().capitalize}",
        ),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: Padding(
            padding: defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(25),
                AutoSizeText(
                  "NGO's Near you,",
                  minFontSize: 18,
                  style: customTextStyle(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Gap(15),
                SizedBox.fromSize(
                  size: const Size.fromHeight(300),
                  child: Obx(() => homeController.ngoLoading
                      ? Center(
                          child: customLoadingAnimation(),
                        )
                      : homeController.data.value.isEmpty
                          ? Center(
                              child: AutoSizeText(
                                "No NGO to show!",
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
                                customLog(homeController.data.value.length);
                                var ngo = homeController.data.value[index];
                                return NGOCard(
                                  ngo: ngo!,
                                  // ngoID: ngo.id.toString(),
                                  // img: ngo.nGOData!.pic.toString(),
                                  // ngoName: ngo.nGOData!.name.toString(),
                                  // ngoDesc: ngo.nGOData!.desc.toString(),
                                );
                              },
                              separatorBuilder: ((context, index) {
                                return const Gap(25);
                              }),
                              itemCount: homeController.data.value.length,
                            )),
                ),
                const Gap(35),
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
                  child: Obx(
                    () => homeController.feedsLoading
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
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
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
                              ),
                  ),
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

  AutoSizeText _ngoName(String ngoName) {
    return AutoSizeText(
      ngoName,
      maxLines: 1,
      minFontSize: 15,
      wrapWords: true,
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
}

class NGOCard extends StatelessWidget {
  final UserModel ngo;

  const NGOCard({
    super.key,
    required this.ngo,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Card(
        child: InkWell(
          onTap: () {
            customLog("Clicked on NGO");
            Get.to(
              () => NGOHomeScreen(
                ngo: ngo,
                // ngoID: ngoID,
                // ngoName: ngoName,
                // ngoDesc: ngoDesc,
                // ngoImg: img,
              ),
            );
          },
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: [
              SizedBox.fromSize(
                size: const Size.fromHeight(150),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  child: CachedNetworkImage(
                    imageUrl: ngo.nGOData!.pic.toString(),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.medium,
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.medium,
                    ),
                    progressIndicatorBuilder: (context, url, progress) =>
                        Center(child: customLoadingAnimation()),
                  ),
                ),
              ),
              const Gap(7.5),
              const Divider(),
              const Gap(7.5),
              AutoSizeText(
                ngo.nGOData!.name.toString(),
                maxLines: 1,
                minFontSize: 18,
                overflow: TextOverflow.ellipsis,
                style: customTextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: AutoSizeText(
                  ngo.nGOData!.desc.toString(),
                  maxLines: 4,
                  minFontSize: 13,
                  wrapWords: true,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.ellipsis,
                  style: customTextStyle(
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

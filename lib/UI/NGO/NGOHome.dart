import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:hope_project/UI/User/donateScreen.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/User%20Controllers/home_controller.dart';
import 'package:hope_project/models/user_model.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class NGOHomeScreen extends StatelessWidget {
  final UserModel ngo;
  // final String ngoName;
  // final String ngoDesc;
  // final String ngoImg;
  // final String ngoID;
  final bool showDonateButton;
  NGOHomeScreen(
      {super.key,
    // required this.ngoName,
    // required this.ngoDesc,
    // required this.ngoImg,
    // required this.ngoID,
      this.showDonateButton = false,
  
    required this.ngo,
  });

  final homeController = Get.find<HomeController>();
  // final ngoDetailsController = Get.put(NGOHomeController(id: ngoID));

  @override
  Widget build(BuildContext context) {
    customLog("NGO ID: ${ngo.id}");
    return Scaffold(
      // drawer: CustomDrawer(),
      floatingActionButton: Obx(
        () => FloatingActionButton.extended(
          isExtended: homeController.isEndOfPage ? true : false,
          onPressed: () => Get.to(() => DonateScreen(ngo: ngo)),
          backgroundColor: mainColor,
          icon: const Icon(
            Symbols.volunteer_activism,
            color: Colors.white,
          ),
          label: AutoSizeText(
            "Donate Now",
            style: customTextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: homeController.isEndOfPage
          ? FloatingActionButtonLocation.centerFloat
          : FloatingActionButtonLocation.endFloat,
      appBar: appBarSize(
        context,
        child: CustomAppbar(
          leading: customBackButton(),
          title: ngo.nGOData!.name.toString(),
        ),
      ),
      body: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            controller: homeController.scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // * NGO Image
                SizedBox.fromSize(
                  size: Size.fromHeight(
                    MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: Padding(
                      padding: defaultPadding,
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
                    // Image(
                    //   fit: BoxFit.cover,
                    //   loadingBuilder: (context, child, loadingProgress) =>
                    //       loadingProgress == null
                    //           ? child
                    //           : Center(child: customLoadingAnimation()),
                    //   errorBuilder: (context, error, stackTrace) =>
                    //       const Placeholder(),
                    //   image: NetworkImage(
                    //     ngoImg,
                    //   ),
                    // )
                      //  CachedNetworkImage(
                      //   imageUrl: ngoImg,
                      //   fit: BoxFit.fill,
                      //   errorWidget: (context, url, error) => const SizedBox(
                      //     child: Placeholder(),
                      //   ),
                      //   progressIndicatorBuilder: (context, url, progress) =>
                      //       Center(child: customLoadingAnimation()),
                      // ),
                      ),
                ),
                const Gap(15),
                // * NGO Name
                Padding(
                  padding: defaultPadding,
                  child: AutoSizeText(
                    "${ngo.nGOData!.name}",
                    style: customTextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Divider(color: Colors.grey),
                // * NGO Overview
                headingSection(heading: "Overview:"),
                Divider(
                  indent: 20,
                  endIndent: MediaQuery.of(context).size.width * 0.65,
                ),
                const Gap(10),
                Padding(
                  padding: defaultPadding,
                  child: SizedBox(
                    child: AutoSizeText(
                      "${ngo.nGOData!.desc}",
                      minFontSize: 18,
                      textAlign: TextAlign.justify,
                      style: customTextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                ),
                // * NGO Current Requirements
                const Gap(15),
                headingSection(heading: "Current Requirements:"),
                Divider(
                  indent: 20,
                  endIndent: MediaQuery.of(context).size.width * 0.3,
                ),

                const Gap(100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding headingSection({required String heading}) {
    return Padding(
      padding: defaultPadding,
      child: AutoSizeText(
        heading,
        style: customTextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:hope_project/controllers/NGO%20Controllers/home_controller.dart';

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
            child: SingleChildScrollView(
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
                    ),
                  ),
                  const Gap(15),
                  SizedBox.fromSize(
                    size: const Size.fromHeight(300),
                    child: Obx(() => homeController.loading
                        ? Center(
                            child: customLoadingAnimation(),
                          )
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              customLog(homeController.data.value.length);
                              var ngo = homeController.data.value[index];
                              return NGOCard(
                                ngoID: ngo!.id.toString(),
                                img: ngo.nGOData!.pic.toString(),
                                ngoName: ngo.nGOData!.name.toString(),
                                ngoDesc: ngo.nGOData!.desc.toString(),
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
                    "Recent Donations,",
                    minFontSize: 18,
                    style: customTextStyle(
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                  const Gap(25),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NGOCard extends StatelessWidget {
  final String ngoID;
  final String img;
  final String ngoName;
  final String ngoDesc;
  const NGOCard({
    super.key,
    required this.img,
    required this.ngoName,
    required this.ngoDesc,
    required this.ngoID,
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
                ngoID: ngoID,
                ngoName: ngoName,
                ngoDesc: ngoDesc,
                ngoImg: img,
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
                  child: Image(
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : Center(child: customLoadingAnimation()),
                    errorBuilder: (context, error, stackTrace) =>
                        const Placeholder(),
                    image: NetworkImage(
                      img,
                    ),
                  ),
                ),
              ),
              const Gap(7.5),
              const Divider(),
              const Gap(7.5),
              AutoSizeText(
                ngoName,
                maxLines: 1,
                minFontSize: 18,
                overflow: TextOverflow.ellipsis,
                style: customTextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: AutoSizeText(
                  ngoDesc,
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

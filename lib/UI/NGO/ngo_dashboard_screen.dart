import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/common/customAppBar.dart';
import 'package:hope_project/common/globals.dart';

class NgoDashboardScreen extends StatelessWidget {
  const NgoDashboardScreen({super.key});

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
                icon: Icon(
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
                      SizedBox(
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
                            "New Post",
                            maxLines: 1,
                            minFontSize: 18,
                            style: customTextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      const Gap(5),
                      // * Donation History Button
                      SizedBox(
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
                      ),
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
                      SizedBox(
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
                            "View Requests",
                            maxLines: 1,
                            minFontSize: 18,
                            style: customTextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      const Gap(5),
                      // * Profile Button
                      SizedBox(
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
                            "Profile",
                            maxLines: 1,
                            minFontSize: 18,
                            style: customTextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(25),
                SizedBox(
                  height: (MediaQuery.of(context).size.height * 0.1),
                  width: MediaQuery.of(context).size.width - 150,
                  child: ElevatedButton(
                    onPressed: () {},
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
                ),
                const Gap(25),
                SizedBox.fromSize(
                  size: Size.fromHeight(50),
                  child: AutoSizeText(
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
}

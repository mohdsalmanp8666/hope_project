import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hope_project/Repositories/Authentication/authentication_repository.dart';
import 'package:hope_project/UI/User/donation_history.dart';
import 'package:hope_project/UI/User/home_screen.dart';
import 'package:hope_project/UI/User/update_profile_screen.dart';
import 'package:hope_project/common/customLog.dart';
import 'package:hope_project/common/globals.dart';
import 'package:hope_project/controllers/drawerController.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              margin: const EdgeInsets.all(0),
              decoration: BoxDecoration(
                color: mainColor.withOpacity(0.25),
              ),
              child: Container(),
            ),
            DrawerItemWidget(
              index: 1,
              leadingIcon: Icons.home_outlined,
              title: "Home",
            ),
            DrawerItemWidget(
              index: 2,
              leadingIcon: Icons.person_outline,
              title: "Profile",
            ),
            DrawerItemWidget(
              index: 3,
              leadingIcon: Icons.volunteer_activism_outlined,
              title: "Donations",
            ),
            DrawerItemWidget(
              index: 10,
              leadingIcon: Icons.logout_outlined,
              title: "Logout",
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItemWidget extends StatelessWidget {
  final int index;
  final IconData leadingIcon;
  final String title;
  DrawerItemWidget({
    super.key,
    required this.index,
    required this.leadingIcon,
    required this.title,
  });

  final drawerController = Get.find<CustomDrawerController>();
  @override
  Widget build(BuildContext context) {
    // final authController = Get.find<AuthController>();
    return ListTile(
      onTap: () async {
        Get.back();
        if (drawerController.selectedIndex != index) {
          if (index != 10) drawerController.selectedIndex = index;
          switch (index) {
            // ? Case for Home Page (i.e Menu Item 1)
            case 1:
              customLog("Navigating to Home Page");
              Get.offAll(() => HomeScreen());
              break;
            // ? Case for Profile Page (i.e Menu Item 2)
            case 2:
              customLog("Profile Page Clicked");
              Get.to(() => UpdateProfileScreen());
              break;
            // ? Case for Donation History Page (i.e Menu Item 3)
            case 3:
              customLog("Donation Page Clicked");
              Get.to(() => DonationHistoryScreen());
              break;
           
            // ? Case for Logout Functionality (i.e Menu Item 4)
            case 10:
              customLog("Logout Menu Item Clicked!");
              Get.dialog(
                AlertDialog(
                  title: const Text('Are you sure?'),
                  actions: [
                    // ! Logout Action Call
                    TextButton(
                      onPressed: () async {
                        await AuthenticationRepository.instance.logoutUser();
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
              break;
            // ? Default case (i.e. Handling error)
            default:
              customLog("Default Case");
              break;
          }
        }
      },
      selected: drawerController.selectedIndex == index,
      selectedColor: mainColor,
      // selectedTileColor: mainColor.withOpacity(0.75),
      leading: Icon(
        leadingIcon,
        size: 24,
        color: Colors.black,
      ),

      title: Text(
        title,
        style: customTextStyle(
          fontSize: 16,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/HomeScreenContant/explorer_tab.dart';
import 'package:pandlive/App/AppUi/HomeScreenContant/following_tab_screen.dart';
import 'package:pandlive/App/AppUi/HomeScreenContant/newjoin_users_tab.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';

class HomeController extends GetxController {
  var selectedIndex = 1.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}

class Homescreen extends StatelessWidget {
  Homescreen({super.key});

  // Local controller for HomeScreen only
  final HomeController controller = HomeController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            /// 🔥 TAB BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => controller.changeTab(0),
                            child: Text(
                              "Following",
                              style: TextStyle(
                                fontSize: controller.selectedIndex.value == 0
                                    ? 20
                                    : 18,
                                fontWeight: controller.selectedIndex.value == 0
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: controller.selectedIndex.value == 0
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => controller.changeTab(1),
                            child: Text(
                              "Explore",
                              style: TextStyle(
                                fontSize: controller.selectedIndex.value == 1
                                    ? 20
                                    : 18,
                                fontWeight: controller.selectedIndex.value == 1
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: controller.selectedIndex.value == 1
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => controller.changeTab(2),
                            child: Text(
                              "New",
                              style: TextStyle(
                                fontSize: controller.selectedIndex.value == 2
                                    ? 20
                                    : 18,
                                fontWeight: controller.selectedIndex.value == 2
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: controller.selectedIndex.value == 2
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search, size: 26),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Image(
                      image: AssetImage(AppImages.settings),
                      height: 28,
                      width: 28,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔹 TAB VIEW
            Expanded(
              child: Obx(() {
                if (controller.selectedIndex.value == 0) {
                  return FollowingScreen();
                } else if (controller.selectedIndex.value == 1) {
                  return ExplorerScreen();
                } else {
                  return NewUsersScreen();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/HomeScreenContant/explorer_tab.dart';
import 'package:pandlive/App/AppUi/HomeScreenContant/following_tab_screen.dart';
import 'package:pandlive/App/AppUi/HomeScreenContant/newjoin_users_tab.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';

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
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    bool isArabic = Get.locale?.languageCode == "ar";
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
                              isArabic ? localization.following : "Following",
                              style: isArabic
                                  ? AppStyle.arabictext.copyWith(
                                      fontSize:
                                          controller.selectedIndex.value == 0
                                          ? 24
                                          : 20,
                                      fontWeight:
                                          controller.selectedIndex.value == 0
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: controller.selectedIndex.value == 0
                                          ? Colors.black
                                          : Colors.grey,
                                    )
                                  : TextStyle(
                                      fontSize:
                                          controller.selectedIndex.value == 0
                                          ? 20
                                          : 18,
                                      fontWeight:
                                          controller.selectedIndex.value == 0
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
                              isArabic ? localization.explore : "Explore",
                              style: isArabic
                                  ? AppStyle.arabictext.copyWith(
                                      fontSize:
                                          controller.selectedIndex.value == 1
                                          ? 24
                                          : 20,
                                      fontWeight:
                                          controller.selectedIndex.value == 1
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: controller.selectedIndex.value == 1
                                          ? Colors.black
                                          : Colors.grey,
                                    )
                                  : TextStyle(
                                      fontSize:
                                          controller.selectedIndex.value == 1
                                          ? 20
                                          : 18,
                                      fontWeight:
                                          controller.selectedIndex.value == 1
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
                              isArabic ? localization.bnew : "New",
                              style: isArabic
                                  ? AppStyle.arabictext.copyWith(
                                      fontSize:
                                          controller.selectedIndex.value == 2
                                          ? 24
                                          : 20,
                                      fontWeight:
                                          controller.selectedIndex.value == 2
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: controller.selectedIndex.value == 2
                                          ? Colors.black
                                          : Colors.grey,
                                    )
                                  : TextStyle(
                                      fontSize:
                                          controller.selectedIndex.value == 2
                                          ? 20
                                          : 18,
                                      fontWeight:
                                          controller.selectedIndex.value == 2
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
                    onPressed: () {
                      Get.defaultDialog(
                        title: isArabic ? "المضيف المفضل؟" : "Favourite host?",
                        titleStyle: isArabic
                            ? AppStyle.arabictext.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )
                            : TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                        content: MyTextFormField(
                          controller: searchController,
                          keyboard: TextInputType.text,
                          hintext: isArabic ? "ابحث هنا.." : "Search here..",
                        ),
                        cancel: TextButton(
                          onPressed: () {
                            searchController.clear();
                          },
                          child: Text(
                            isArabic ? "بحث" : "Search",
                            style: isArabic
                                ? AppStyle.arabictext.copyWith(
                                    fontSize: 18,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  )
                                : const TextStyle(
                                    fontSize: 16,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                          ),
                        ),
                        confirm: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            isArabic ? "يلغي" : "Cancel",
                            style: isArabic
                                ? AppStyle.arabictext.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  )
                                : const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.red,
                                  ),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.search, size: 26),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.language);
                    },
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

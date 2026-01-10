import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                                    ? 18
                                    : 16,
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
                                    ? 18
                                    : 16,
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
                                    ? 18
                                    : 16,
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
                  IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
                ],
              ),
            ),

            /// 🔹 TAB VIEW
            Expanded(
              child: Obx(() {
                if (controller.selectedIndex.value == 0) {
                  return const Center(
                    child: Text(
                      "Following Content",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else if (controller.selectedIndex.value == 1) {
                  return const Center(
                    child: Text(
                      "Explore Content",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                } else {
                  return const Center(
                    child: Text(
                      "New Content",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }
}

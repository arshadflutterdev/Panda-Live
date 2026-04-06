import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';

class ReelsScreen extends StatelessWidget {
  const ReelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReelsController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video List
          Obx(() {
            var currentList = controller.isForYou.value
                ? controller.forYouList
                : controller.followingList;
            return PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: currentList.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    "Video ${index + 1}",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              },
            );
          }),

          // Top Overlay (Tabs + Upload Button)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Upload Button (Left Side)
                IconButton(
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => print("Upload Screen"),
                ),
                const SizedBox(width: 20),

                // Tabs Logic
                Obx(
                  () => GestureDetector(
                    onTap: () => controller.toggleTab(false),
                    child: Text(
                      "Following",
                      style: TextStyle(
                        color: !controller.isForYou.value
                            ? Colors.white
                            : Colors.white60,
                        fontWeight: !controller.isForYou.value
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                const Text("|", style: TextStyle(color: Colors.white30)),
                const SizedBox(width: 15),
                Obx(
                  () => GestureDetector(
                    onTap: () => controller.toggleTab(true),
                    child: Text(
                      "For You",
                      style: TextStyle(
                        color: controller.isForYou.value
                            ? Colors.white
                            : Colors.white60,
                        fontWeight: controller.isForYou.value
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),

                // Spacer for balance
                const SizedBox(width: 50),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReelsController extends GetxController {
  var forYouList = <VideoModel>[].obs;
  var followingList = <VideoModel>[].obs;
  var isForYou = true.obs; // Toggle state

  @override
  void onInit() {
    super.onInit();
    fetchForYou();
    fetchFollowing();
  }

  void fetchForYou() async {
    var snap = await FirebaseFirestore.instance.collection('videos').get();
    forYouList.assignAll(
      snap.docs.map((doc) => VideoModel.fromSnap(doc)).toList(),
    );
  }

  void fetchFollowing() async {
    // Yahan following logic ayega (e.g. jinko user follow karta hai)
    var snap = await FirebaseFirestore.instance
        .collection('videos')
        .where('isFollowing', isEqualTo: true)
        .get();
    followingList.assignAll(
      snap.docs.map((doc) => VideoModel.fromSnap(doc)).toList(),
    );
  }

  void toggleTab(bool val) {
    isForYou.value = val;
  }
}

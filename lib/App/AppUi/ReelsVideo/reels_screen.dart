import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/reel_player_screen.dart';
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
          // 1. Main Video PageView
          Obx(
            () => PageView.builder(
              scrollDirection: Axis.vertical,
              itemCount: controller.videoList.length,
              // ReelsScreen ke PageView.builder mein ye update karein:
              itemBuilder: (context, index) {
                final data = controller.videoList[index];
                return Stack(
                  children: [
                    // Actual Video Player
                    VideoPlayerItem(videoUrl: data.videoUrl),

                    // Caption aur Username overlay (Optional)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "@${data.username}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            data.caption,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // 2. Top Bar (Tabs & Upload)
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // UPLOAD BUTTON
                IconButton(
                  icon: Icon(
                    Icons.add_box_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () => controller.pickVideo(),
                ),
                const SizedBox(width: 20),
                // TABS
                Text(
                  "Following",
                  style: TextStyle(color: Colors.white60, fontSize: 17),
                ),
                const SizedBox(width: 15),
                Text("|", style: TextStyle(color: Colors.white30)),
                const SizedBox(width: 15),
                Text(
                  "For You",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(width: 50), // Balance ke liye
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
                    // 1. Video Player (Asli data bhejien)
                    VideoPlayerItem(
                      videoUrl: data.videoUrl,
                      videoId: data.id,
                      username: data.username,
                      caption: data.caption,
                      profilePic: data.profilePic,
                    ),

                    // 2. TikTok Style Profile Image (Right Side)
                    Positioned(
                      right: 15,
                      bottom: 110,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(1.5),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey[900],
                              // Check karein agar URL valid hai
                              backgroundImage: data.profilePic.isNotEmpty
                                  ? NetworkImage(data.profilePic)
                                  : null,
                              child: data.profilePic.isEmpty
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // 3. Name aur Caption (Left Side)
                    Positioned(
                      left: 15,
                      bottom: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "@${data.username}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            data.caption,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },

              // itemBuilder: (context, index) {
              //   final data = controller.videoList[index];
              //   return Stack(
              //     children: [
              //       // Actual Video Player
              //       VideoPlayerItem(videoUrl: data.videoUrl),

              //       // Caption aur Username overlay (Optional)
              //       Positioned(
              //         bottom: 20,
              //         left: 20,
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           children: [
              //             Text(
              //               "@${data.username}",
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold,
              //               ),
              //             ),
              //             Text(
              //               data.caption,
              //               style: TextStyle(color: Colors.white),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   );
              // },
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

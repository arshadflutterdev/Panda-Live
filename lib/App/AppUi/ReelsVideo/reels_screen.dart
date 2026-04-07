import 'package:firebase_auth/firebase_auth.dart';
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
                final data =
                    controller.videoList[index]; // Firebase se aane wala data

                return Stack(
                  children: [
                    // 1. Actual Video Player
                    VideoPlayerItem(videoUrl: data.videoUrl),

                    // 2. Right Side Profile/User Section (TikTok Style)
                    Positioned(
                      right: 15,
                      bottom: 120, // Isay likes ke upar set karein
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Yahan user ki profile par janay ka logic aaye ga
                              print("Navigate to profile of: ${data.username}");
                            },
                            child: Container(
                              padding: const EdgeInsets.all(
                                2,
                              ), // White border effect
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.black,
                                // --- REAL IMAGE LOADING ---
                                // Agar profilePic link hai to wo dikhao
                                backgroundImage: data.profilePic.isNotEmpty
                                    ? NetworkImage(data.profilePic)
                                    : null,
                                // Agar profilePic khali hai to User ka pehla letter dikhao
                                child: data.profilePic.isEmpty
                                    ? Text(
                                        data.username.isNotEmpty
                                            ? data.username[0].toUpperCase()
                                            : "?",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),

                          // Wo chota sa red plus icon (TikTok Follow Button)
                          // ReelsScreen.dart mein Profile Picture ke neeche wala Plus Icon code:
                          StreamBuilder<bool>(
                            stream: controller.isFollowing(
                              data.uid,
                            ), // Check kar raha hai follow status
                            builder: (context, snapshot) {
                              // Agar data load ho raha ho ya user already followed ho, toh khali box dikhao (Hide icon)
                              if (data.uid ==
                                  FirebaseAuth.instance.currentUser!.uid) {
                                return const SizedBox.shrink();
                              }
                              if (snapshot.data == true) {
                                return const SizedBox.shrink(); // Icon gayab ho jayega
                              }

                              // Agar user followed NAHI hai, toh Plus Icon dikhao
                              return Transform.translate(
                                offset: const Offset(0, -10),
                                child: GestureDetector(
                                  onTap: () {
                                    controller.followUser(
                                      data.uid,
                                    ); // Follow logic call hoga
                                  },
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    // 3. Bottom Left Overlay (Username aur Caption)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "@${data.username}", // Dynamic Username
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            data.caption, // Dynamic Caption
                            style: const TextStyle(color: Colors.white),
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

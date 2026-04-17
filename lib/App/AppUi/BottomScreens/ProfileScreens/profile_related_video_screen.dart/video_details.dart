// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/main_profile_screen.dart';

// import 'package:pandlive/App/AppUi/ReelsVideo/Reels_Models.dart/reels_model.dart';
// import 'package:pandlive/App/AppUi/ReelsVideo/reel_player_screen.dart';
// import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart'; // Apna ReelsController import karein

// class VideoDetailScreen extends StatelessWidget {
//   final List<VideoModel> videoList;
//   final int initialIndex;

//   const VideoDetailScreen({
//     super.key,
//     required this.videoList,
//     required this.initialIndex,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final PageController pageController = PageController(
//       initialPage: initialIndex,
//     );
//     final ReelsController reelsController =
//         Get.find<ReelsController>(); // Controller find karein

//     return Scaffold(
//       backgroundColor: Colors.black,
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: PageView.builder(
//         controller: pageController,
//         scrollDirection: Axis.vertical,
//         itemCount: videoList.length,
//         itemBuilder: (context, index) {
//           final data = videoList[index];

//           return Stack(
//             children: [
//               // --- 1. VIDEO PLAYER ---
//               VideoPlayerItem(videoUrl: data.videoUrl, videoId: data.id),

//               // --- 2. SIDE ACTIONS (LIKES, COMMENTS, SAVES) ---
//               Positioned(
//                 right: 15,
//                 bottom: 100,
//                 child: Column(
//                   children: [
//                     // Profile Pic + Follow Button
//                     _buildProfileSection(data, reelsController),
//                     const SizedBox(height: 20),

//                     // Like Button (Real-time Obx)
//                     Obx(() {
//                       final currentVideo = reelsController.videoList.firstWhere(
//                         (v) => v.id == data.id,
//                         orElse: () => data,
//                       );
//                       bool isLiked = currentVideo.likes.contains(
//                         FirebaseAuth.instance.currentUser!.uid,
//                       );
//                       return _buildActionItem(
//                         icon: Icons.favorite,
//                         label: "${currentVideo.likes.length}",
//                         color: isLiked ? Colors.red : Colors.white,
//                         onTap: () => reelsController.likeVideo(data.id),
//                       );
//                     }),
//                     const SizedBox(height: 20),

//                     // Comment Button
//                     _buildActionItem(
//                       icon: Icons.comment,
//                       label: "${data.commentCount}",
//                       onTap: () {
//                         // showCommentBottomSheet logic yahan add karein
//                       },
//                     ),
//                     const SizedBox(height: 20),

//                     // Favorite / Save Button (StreamBuilder)
//                     StreamBuilder<bool>(
//                       stream: reelsController.isFavorite(data.id),
//                       builder: (context, snapshot) {
//                         bool isFav = snapshot.data ?? false;
//                         return _buildActionItem(
//                           icon: isFav ? Icons.bookmark : Icons.bookmark_border,
//                           label: isFav ? "Saved" : "Save",
//                           color: isFav ? Colors.amber : Colors.white,
//                           onTap: () => reelsController.toggleFavorite(
//                             data.id,
//                             data.toJson(),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),

//               // --- 3. USER INFO (BOTTOM) ---
//               Positioned(
//                 bottom: 30,
//                 left: 15,
//                 right: 80,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "@${data.username}",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       data.caption,
//                       style: const TextStyle(color: Colors.white, fontSize: 14),
//                       maxLines: 2,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   // Profile section with Follow button logic
//   Widget _buildProfileSection(VideoModel data, ReelsController controller) {
//     return GestureDetector(
//       onTap: () => Get.to(() => ProfileScreen(uid: data.uid)),
//       child: Stack(
//         clipBehavior: Clip.none,
//         children: [
//           CircleAvatar(
//             radius: 25,
//             backgroundColor: Colors.white,
//             backgroundImage: NetworkImage(data.profilePic),
//           ),
//           StreamBuilder<bool>(
//             stream: controller.isFollowing(data.uid),
//             builder: (context, snapshot) {
//               if (data.uid == FirebaseAuth.instance.currentUser!.uid ||
//                   snapshot.data == true) {
//                 return const SizedBox.shrink();
//               }
//               return Positioned(
//                 bottom: -10,
//                 left: 15,
//                 child: GestureDetector(
//                   onTap: () => controller.followUser(data.uid),
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(Icons.add, color: Colors.white, size: 20),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionItem({
//     required IconData icon,
//     required String label,
//     Color color = Colors.white,
//     VoidCallback? onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Column(
//         children: [
//           Icon(icon, color: color, size: 38),
//           const SizedBox(height: 5),
//           Text(
//             label,
//             style: const TextStyle(color: Colors.white, fontSize: 12),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/main_profile_screen.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/Reels_Models.dart/reels_model.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/reel_player_screen.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';

class VideoDetailScreen extends StatelessWidget {
  final List<VideoModel> videoList;
  final int initialIndex;

  const VideoDetailScreen({
    super.key,
    required this.videoList,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Controller ko initial index ke sath setup karein
    final PageController pageController = PageController(
      initialPage: initialIndex,
    );
    final ReelsController reelsController = Get.find<ReelsController>();

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        // 1. Agar list khali ho jaye to foran wapas profile par bhejein
        if (videoList.isEmpty) {
          Future.microtask(() => Get.back());
          return const SizedBox.shrink();
        }

        return PageView.builder(
          // 2. ValueKey lagane se Flutter ko pata chalega ke list modify hui hai
          // Ye line RangeError ko khatam karne ke liye sabse zaroori hai
          key: ValueKey(videoList.length),
          controller: pageController,
          scrollDirection: Axis.vertical,
          itemCount: videoList.length,
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            // 3. Mazeed safety check takay invalid index access na ho
            if (index >= videoList.length || index < 0) {
              return const SizedBox.shrink();
            }

            final data = videoList[index];

            return Stack(
              // Har video ke liye unique key takay state save rahe
              key: ValueKey(data.id),
              children: [
                // --- VIDEO PLAYER ---
                VideoPlayerItem(videoUrl: data.videoUrl, videoId: data.id),

                // --- SIDE ACTIONS ---
                Positioned(
                  right: 15,
                  bottom: 100,
                  child: Column(
                    children: [
                      _buildProfileSection(data, reelsController),
                      const SizedBox(height: 20),

                      // Like Button
                      Obx(() {
                        final currentVideo =
                            reelsController.videoList.firstWhereOrNull(
                              (v) => v.id == data.id,
                            ) ??
                            data;

                        bool isLiked = currentVideo.likes.contains(
                          FirebaseAuth.instance.currentUser!.uid,
                        );
                        return _buildActionItem(
                          icon: Icons.favorite,
                          label: "${currentVideo.likes.length}",
                          color: isLiked ? Colors.red : Colors.white,
                          onTap: () => reelsController.likeVideo(data.id),
                        );
                      }),
                      const SizedBox(height: 20),

                      _buildActionItem(
                        icon: Icons.comment,
                        label: "${data.commentCount}",
                        onTap: () {},
                      ),
                      const SizedBox(height: 20),

                      // Favorite/Save Button
                      StreamBuilder<bool>(
                        stream: reelsController.isFavorite(data.id),
                        builder: (context, snapshot) {
                          bool isFav = snapshot.data ?? false;
                          return _buildActionItem(
                            icon: isFav
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            label: isFav ? "Saved" : "Save",
                            color: isFav ? Colors.amber : Colors.white,
                            onTap: () => reelsController.toggleFavorite(
                              data.id,
                              data.toJson(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                // --- USER INFO ---
                Positioned(
                  bottom: 30,
                  left: 15,
                  right: 80,
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
                      const SizedBox(height: 8),
                      Text(
                        data.caption,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }

  // Profile Section Widget
  Widget _buildProfileSection(VideoModel data, ReelsController controller) {
    return GestureDetector(
      onTap: () => Get.to(() => ProfileScreen(uid: data.uid)),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(data.profilePic),
          ),
          StreamBuilder<bool>(
            stream: controller.isFollowing(data.uid),
            builder: (context, snapshot) {
              if (data.uid == FirebaseAuth.instance.currentUser!.uid ||
                  snapshot.data == true) {
                return const SizedBox.shrink();
              }
              return Positioned(
                bottom: -10,
                left: 15,
                child: GestureDetector(
                  onTap: () => controller.followUser(data.uid),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Action Icon Button Widget
  Widget _buildActionItem({
    required IconData icon,
    required String label,
    Color color = Colors.white,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: color, size: 38),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

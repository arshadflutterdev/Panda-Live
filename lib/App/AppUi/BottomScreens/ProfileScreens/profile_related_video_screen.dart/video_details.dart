// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/main_profile_screen.dart';
// // import 'package:pandlive/App/AppUi/ReelsVideo/Reels_Models.dart/reels_model.dart';
// // import 'package:pandlive/App/AppUi/ReelsVideo/reel_player_screen.dart';
// // import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';
// // import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_screen_controller.dart';

// // class VideoDetailScreen extends StatelessWidget {
// //   final List<VideoModel> videoList;
// //   final int initialIndex;

// //   const VideoDetailScreen({
// //     super.key,
// //     required this.videoList,
// //     required this.initialIndex,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     final PageController pageController = PageController(
// //       initialPage: initialIndex,
// //     );
// //     final ReelsController reelsController = Get.find<ReelsController>();

// //     return Scaffold(
// //       backgroundColor: Colors.black,
// //       extendBodyBehindAppBar: true,
// //       appBar: AppBar(
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
// //           onPressed: () => Get.back(),
// //         ),
// //       ),
// //       body: Obx(() {
// //         if (videoList.isEmpty) {
// //           Future.microtask(() => Get.back());
// //           return const SizedBox.shrink();
// //         }

// //         return PageView.builder(
// //           key: ValueKey(videoList.length),
// //           controller: pageController,
// //           scrollDirection: Axis.vertical,
// //           itemCount: videoList.length,
// //           itemBuilder: (context, index) {
// //             if (index >= videoList.length || index < 0)
// //               return const SizedBox.shrink();

// //             final data = videoList[index];

// //             return Stack(
// //               key: ValueKey(data.id),
// //               children: [
// //                 VideoPlayerItem(videoUrl: data.videoUrl, videoId: data.id),
// //                 Positioned(
// //                   right: 15,
// //                   bottom: 100,
// //                   child: Column(
// //                     children: [
// //                       _buildProfileSection(data, reelsController),
// //                       const SizedBox(height: 20),

// //                       // Like Button
// //                       Obx(() {
// //                         final currentVideo =
// //                             reelsController.videoList.firstWhereOrNull(
// //                               (v) => v.id == data.id,
// //                             ) ??
// //                             data;
// //                         bool isLiked = currentVideo.likes.contains(
// //                           FirebaseAuth.instance.currentUser!.uid,
// //                         );
// //                         return _buildActionItem(
// //                           icon: Icons.favorite,
// //                           label: "${currentVideo.likes.length}",
// //                           color: isLiked ? Colors.red : Colors.white,
// //                           onTap: () => reelsController.likeVideo(data.id),
// //                         );
// //                       }),
// //                       const SizedBox(height: 20),

// //                       _buildActionItem(
// //                         icon: Icons.comment,
// //                         label: "${data.commentCount}",
// //                         onTap: () {},
// //                       ),
// //                       const SizedBox(height: 20),

// //                       // Favorite/Save Button
// //                       StreamBuilder<bool>(
// //                         stream: reelsController.isFavorite(data.id),
// //                         builder: (context, snapshot) {
// //                           bool isFav = snapshot.data ?? false;
// //                           return _buildActionItem(
// //                             icon: isFav
// //                                 ? Icons.bookmark
// //                                 : Icons.bookmark_border,
// //                             label: isFav ? "Saved" : "Save",
// //                             color: isFav ? Colors.amber : Colors.white,
// //                             onTap: () => reelsController.toggleFavorite(
// //                               data.id,
// //                               data.toJson(),
// //                             ),
// //                           );
// //                         },
// //                       ),
// //                       const SizedBox(height: 5),
// //                       // Favorite button ke niche
// //                       if (video.uid != FirebaseAuth.instance.currentUser!.uid)
// //                         Column(
// //                           children: [
// //                             IconButton(
// //                               onPressed: () => controller.downloadVideo(
// //                                 video.videoUrl,
// //                                 video.id,
// //                               ),
// //                               icon: const Icon(
// //                                 Icons.download_for_offline_outlined,
// //                                 size: 35,
// //                                 color: Colors.white,
// //                               ),
// //                             ),
// //                             const Text(
// //                               "Save",
// //                               style: TextStyle(
// //                                 color: Colors.white,
// //                                 fontSize: 12,
// //                               ),
// //                             ),
// //                           ],
// //                         ),

// //                       // More Options (Privacy & Delete)
// //                       if (data.uid == FirebaseAuth.instance.currentUser!.uid)
// //                         _buildActionItem(
// //                           icon: Icons.more_horiz,
// //                           label: "More",
// //                           onTap: () => _showOptionsBottomSheet(context, data),
// //                         ),
// //                     ],
// //                   ),
// //                 ),

// //                 // User Info Section
// //                 Positioned(
// //                   bottom: 30,
// //                   left: 15,
// //                   right: 80,
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Row(
// //                         children: [
// //                           Text(
// //                             "@${data.username}",
// //                             style: const TextStyle(
// //                               color: Colors.white,
// //                               fontWeight: FontWeight.bold,
// //                               fontSize: 16,
// //                             ),
// //                           ),
// //                           // Privacy Icon if video is private
// //                           if (data.isPrivate == true)
// //                             const Padding(
// //                               padding: EdgeInsets.only(left: 8.0),
// //                               child: Icon(
// //                                 Icons.lock,
// //                                 color: Colors.white70,
// //                                 size: 14,
// //                               ),
// //                             ),
// //                         ],
// //                       ),
// //                       const SizedBox(height: 8),
// //                       Text(
// //                         data.caption,
// //                         style: const TextStyle(
// //                           color: Colors.white,
// //                           fontSize: 14,
// //                         ),
// //                         maxLines: 2,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             );
// //           },
// //         );
// //       }),
// //     );
// //   }

// //   void _showOptionsBottomSheet(BuildContext context, VideoModel video) {
// //     final controller = Get.find<ProfileController>(tag: video.uid);
// //     bool isCurrentlyPrivate = video.isPrivate ?? false;

// //     showModalBottomSheet(
// //       context: context,
// //       backgroundColor: Colors.white,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //       ),
// //       builder: (context) {
// //         return SafeArea(
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               const SizedBox(height: 10),
// //               Container(
// //                 width: 40,
// //                 height: 4,
// //                 decoration: BoxDecoration(
// //                   color: Colors.grey[300],
// //                   borderRadius: BorderRadius.circular(10),
// //                 ),
// //               ),
// //               const Padding(
// //                 padding: EdgeInsets.all(15.0),
// //                 child: Text(
// //                   "Video Settings",
// //                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
// //                 ),
// //               ),
// //               const Divider(height: 0),

// //               // Privacy Toggle Option
// //               ListTile(
// //                 leading: Icon(
// //                   isCurrentlyPrivate ? Icons.public : Icons.lock_outline,
// //                   color: Colors.black87,
// //                 ),
// //                 title: Text(
// //                   isCurrentlyPrivate ? "Make Public" : "Make Private",
// //                 ),
// //                 onTap: () =>
// //                     controller.toggleVideoPrivacy(video.id, isCurrentlyPrivate),
// //               ),

// //               // Delete Option
// //               ListTile(
// //                 leading: const Icon(Icons.delete_outline, color: Colors.red),
// //                 title: const Text(
// //                   "Delete Video",
// //                   style: TextStyle(color: Colors.red),
// //                 ),
// //                 onTap: () {
// //                   Get.back();
// //                   Get.defaultDialog(
// //                     title: "Delete Video",
// //                     middleText: "Are you sure? This action cannot be undone.",
// //                     textConfirm: "Delete",
// //                     textCancel: "Cancel",
// //                     confirmTextColor: Colors.white,
// //                     buttonColor: Colors.red,
// //                     onConfirm: () {
// //                       controller.deleteVideo(video.id);
// //                       Get.back();
// //                     },
// //                   );
// //                 },
// //               ),
// //               const SizedBox(height: 10),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   Widget _buildProfileSection(VideoModel data, ReelsController controller) {
// //     return GestureDetector(
// //       onTap: () => Get.to(() => ProfileScreen(uid: data.uid)),
// //       child: Stack(
// //         clipBehavior: Clip.none,
// //         children: [
// //           CircleAvatar(
// //             radius: 25,
// //             backgroundColor: Colors.white,
// //             backgroundImage: NetworkImage(data.profilePic),
// //           ),
// //           StreamBuilder<bool>(
// //             stream: controller.isFollowing(data.uid),
// //             builder: (context, snapshot) {
// //               if (data.uid == FirebaseAuth.instance.currentUser!.uid ||
// //                   snapshot.data == true)
// //                 return const SizedBox.shrink();
// //               return Positioned(
// //                 bottom: -10,
// //                 left: 15,
// //                 child: GestureDetector(
// //                   onTap: () => controller.followUser(data.uid),
// //                   child: Container(
// //                     decoration: const BoxDecoration(
// //                       color: Colors.red,
// //                       shape: BoxShape.circle,
// //                     ),
// //                     child: const Icon(Icons.add, color: Colors.white, size: 20),
// //                   ),
// //                 ),
// //               );
// //             },
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildActionItem({
// //     required IconData icon,
// //     required String label,
// //     Color color = Colors.white,
// //     VoidCallback? onTap,
// //   }) {
// //     return GestureDetector(
// //       onTap: onTap,
// //       child: Column(
// //         children: [
// //           Icon(icon, color: color, size: 38),
// //           const SizedBox(height: 5),
// //           Text(
// //             label,
// //             style: const TextStyle(color: Colors.white, fontSize: 12),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/main_profile_screen.dart';
// import 'package:pandlive/App/AppUi/ReelsVideo/Reels_Models.dart/reels_model.dart';
// import 'package:pandlive/App/AppUi/ReelsVideo/reel_player_screen.dart';
// import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_screen_controller.dart';

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
//     final ReelsController reelsController = Get.find<ReelsController>();

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
//       body: Obx(() {
//         if (videoList.isEmpty) {
//           Future.microtask(() => Get.back());
//           return const SizedBox.shrink();
//         }

//         return PageView.builder(
//           key: ValueKey(videoList.length),
//           controller: pageController,
//           scrollDirection: Axis.vertical,
//           itemCount: videoList.length,
//           itemBuilder: (context, index) {
//             if (index >= videoList.length || index < 0)
//               return const SizedBox.shrink();

//             final data = videoList[index];

//             return Stack(
//               key: ValueKey(data.id),
//               children: [
//                 VideoPlayerItem(videoUrl: data.videoUrl, videoId: data.id),
//                 Positioned(
//                   right: 15,
//                   bottom: 100,
//                   child: Column(
//                     children: [
//                       _buildProfileSection(data, reelsController),
//                       const SizedBox(height: 20),

//                       // Like Button
//                       Obx(() {
//                         final currentVideo =
//                             reelsController.videoList.firstWhereOrNull(
//                               (v) => v.id == data.id,
//                             ) ??
//                             data;
//                         bool isLiked = currentVideo.likes.contains(
//                           FirebaseAuth.instance.currentUser!.uid,
//                         );
//                         return _buildActionItem(
//                           icon: Icons.favorite,
//                           label: "${currentVideo.likes.length}",
//                           color: isLiked ? Colors.red : Colors.white,
//                           onTap: () => reelsController.likeVideo(data.id),
//                         );
//                       }),
//                       const SizedBox(height: 20),

//                       _buildActionItem(
//                         icon: Icons.comment,
//                         label: "${data.commentCount}",
//                         onTap: () {},
//                       ),
//                       const SizedBox(height: 20),

//                       // Favorite/Save Button
//                       StreamBuilder<bool>(
//                         stream: reelsController.isFavorite(data.id),
//                         builder: (context, snapshot) {
//                           bool isFav = snapshot.data ?? false;
//                           return _buildActionItem(
//                             icon: isFav
//                                 ? Icons.bookmark
//                                 : Icons.bookmark_border,
//                             label: isFav ? "Saved" : "Save",
//                             color: isFav ? Colors.amber : Colors.white,
//                             onTap: () => reelsController.toggleFavorite(
//                               data.id,
//                               data.toJson(),
//                             ),
//                           );
//                         },
//                       ),

//                       // Download Button (Only for other users' videos)
//                       if (data.uid !=
//                           FirebaseAuth.instance.currentUser!.uid) ...[
//                         const SizedBox(height: 20),
//                         _buildActionItem(
//                           icon: Icons.download_for_offline_outlined,
//                           label: "Download",
//                           onTap: () => reelsController.downloadVideo(
//                             data.videoUrl,
//                             data.id,
//                           ),
//                         ),
//                       ],

//                       // More Options (Privacy & Delete)
//                       if (data.uid ==
//                           FirebaseAuth.instance.currentUser!.uid) ...[
//                         const SizedBox(height: 20),
//                         _buildActionItem(
//                           icon: Icons.more_horiz,
//                           label: "More",
//                           onTap: () => _showOptionsBottomSheet(
//                             context,
//                             data,
//                             reelsController,
//                           ),
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),

//                 // User Info Section
//                 Positioned(
//                   bottom: 30,
//                   left: 15,
//                   right: 80,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Text(
//                             "@${data.username}",
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                           // Privacy Icon if video is private
//                           if (data.isPrivate == true)
//                             const Padding(
//                               padding: EdgeInsets.only(left: 8.0),
//                               child: Icon(
//                                 Icons.lock,
//                                 color: Colors.white70,
//                                 size: 14,
//                               ),
//                             ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         data.caption,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                         ),
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       }),
//     );
//   }

//   void _showOptionsBottomSheet(
//     BuildContext context,
//     VideoModel video,
//     ReelsController reelsController,
//   ) {
//     final controller = Get.find<ProfileController>(tag: video.uid);
//     bool isCurrentlyPrivate = video.isPrivate ?? false;

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return SafeArea(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 10),
//               Container(
//                 width: 40,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               const Padding(
//                 padding: EdgeInsets.all(15.0),
//                 child: Text(
//                   "Video Settings",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//               ),
//               const Divider(height: 0),

//               // Download Option for Own Video
//               ListTile(
//                 leading: const Icon(Icons.download, color: Colors.black87),
//                 title: const Text("Download Video"),
//                 onTap: () {
//                   Get.back();
//                   reelsController.downloadVideo(video.videoUrl, video.id);
//                 },
//               ),

//               // Privacy Toggle Option
//               ListTile(
//                 leading: Icon(
//                   isCurrentlyPrivate ? Icons.public : Icons.lock_outline,
//                   color: Colors.black87,
//                 ),
//                 title: Text(
//                   isCurrentlyPrivate ? "Make Public" : "Make Private",
//                 ),
//                 onTap: () {
//                   Get.back();
//                   controller.toggleVideoPrivacy(video.id, isCurrentlyPrivate);
//                 },
//               ),

//               // Delete Option
//               ListTile(
//                 leading: const Icon(Icons.delete_outline, color: Colors.red),
//                 title: const Text(
//                   "Delete Video",
//                   style: TextStyle(color: Colors.red),
//                 ),
//                 onTap: () {
//                   Get.back();
//                   Get.defaultDialog(
//                     title: "Delete Video",
//                     middleText: "Are you sure? This action cannot be undone.",
//                     textConfirm: "Delete",
//                     textCancel: "Cancel",
//                     confirmTextColor: Colors.white,
//                     buttonColor: Colors.red,
//                     onConfirm: () {
//                       controller.deleteVideo(video.id);
//                       Get.back();
//                     },
//                   );
//                 },
//               ),
//               const SizedBox(height: 10),
//             ],
//           ),
//         );
//       },
//     );
//   }

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
//                   snapshot.data == true)
//                 return const SizedBox.shrink();
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
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_screen_controller.dart';

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
    final PageController pageController = PageController(
      initialPage: initialIndex,
    );
    final ReelsController reelsController = Get.find<ReelsController>();

    return Scaffold(
      extendBody: true, // <--- Ye bottom bar ka gap khatam karega
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (videoList.isEmpty) {
          Future.microtask(() => Get.back());
          return const SizedBox.shrink();
        }

        return PageView.builder(
          key: ValueKey(videoList.length),
          controller: pageController,
          scrollDirection: Axis.vertical,
          itemCount: videoList.length,
          itemBuilder: (context, index) {
            if (index >= videoList.length || index < 0)
              return const SizedBox.shrink();

            final data = videoList[index];

            return Stack(
              key: ValueKey(data.id),
              children: [
                VideoPlayerItem(videoUrl: data.videoUrl, videoId: data.id),
                Positioned(
                  right: 15,
                  bottom: 45,
                  child: Column(
                    children: [
                      _buildProfileSection(data, reelsController),
                      const SizedBox(height: 10),

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

                      // Comment Button
                      _buildActionItem(
                        icon: Icons.comment,
                        label: "${data.commentCount}",
                        onTap: () {},
                      ),

                      // Favorite/Save Button (App ke andar save karne ke liye)
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

                      // DOWNLOAD BUTTON (Sirf Dusre User ki video pe dikhega)
                      if (data.uid !=
                          FirebaseAuth.instance.currentUser!.uid) ...[
                        _buildActionItem(
                          icon: Icons.download_for_offline_outlined,
                          label: "Download",
                          onTap: () => reelsController.downloadVideo(
                            data.videoUrl,
                            data.id,
                          ),
                        ),
                      ],

                      // MORE OPTIONS (Apni video pe 3 dots jisme download aur privacy hai)
                      if (data.uid ==
                          FirebaseAuth.instance.currentUser!.uid) ...[
                        _buildActionItem(
                          icon: Icons.more_horiz,
                          label: "More",
                          onTap: () => _showOptionsBottomSheet(
                            context,
                            data,
                            reelsController,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // User Info Section
                Positioned(
                  bottom: 20,
                  left: 15,
                  right: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "@${data.username}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (data.isPrivate == true)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.lock,
                                color: Colors.white70,
                                size: 14,
                              ),
                            ),
                        ],
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

  void _showOptionsBottomSheet(
    BuildContext context,
    VideoModel video,
    ReelsController reelsController,
  ) {
    final controller = Get.find<ProfileController>(tag: video.uid);
    bool isCurrentlyPrivate = video.isPrivate ?? false;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  "Video Settings",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const Divider(height: 0),

              // Apni video download karne ka option
              ListTile(
                leading: const Icon(Icons.download, color: Colors.black87),
                title: const Text("Download Video"),
                onTap: () {
                  Get.back();
                  reelsController.downloadVideo(video.videoUrl, video.id);
                },
              ),

              ListTile(
                leading: Icon(
                  isCurrentlyPrivate ? Icons.public : Icons.lock_outline,
                  color: Colors.black87,
                ),
                title: Text(
                  isCurrentlyPrivate ? "Make Public" : "Make Private",
                ),
                onTap: () {
                  Get.back();
                  controller.toggleVideoPrivacy(video.id, isCurrentlyPrivate);
                },
              ),

              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text(
                  "Delete Video",
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Get.back();
                  Get.defaultDialog(
                    title: "Delete Video",
                    middleText: "Are you sure? This action cannot be undone.",
                    textConfirm: "Delete",
                    textCancel: "Cancel",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    onConfirm: () {
                      controller.deleteVideo(video.id);
                      Get.back();
                    },
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

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
                  snapshot.data == true)
                return const SizedBox.shrink();
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

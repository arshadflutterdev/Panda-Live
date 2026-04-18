// // // import 'package:firebase_auth/firebase_auth.dart';
// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // // import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/main_profile_screen.dart';

// // // import 'package:pandlive/App/AppUi/ReelsVideo/Reels_Models.dart/reels_model.dart';
// // // import 'package:pandlive/App/AppUi/ReelsVideo/reel_player_screen.dart';
// // // import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart'; // Apna ReelsController import karein

// // // class VideoDetailScreen extends StatelessWidget {
// // //   final List<VideoModel> videoList;
// // //   final int initialIndex;

// // //   const VideoDetailScreen({
// // //     super.key,
// // //     required this.videoList,
// // //     required this.initialIndex,
// // //   });

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final PageController pageController = PageController(
// // //       initialPage: initialIndex,
// // //     );
// // //     final ReelsController reelsController =
// // //         Get.find<ReelsController>(); // Controller find karein

// // //     return Scaffold(
// // //       backgroundColor: Colors.black,
// // //       extendBodyBehindAppBar: true,
// // //       appBar: AppBar(
// // //         backgroundColor: Colors.transparent,
// // //         elevation: 0,
// // //         leading: IconButton(
// // //           icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
// // //           onPressed: () => Get.back(),
// // //         ),
// // //       ),
// // //       body: PageView.builder(
// // //         controller: pageController,
// // //         scrollDirection: Axis.vertical,
// // //         itemCount: videoList.length,
// // //         itemBuilder: (context, index) {
// // //           final data = videoList[index];

// // //           return Stack(
// // //             children: [
// // //               // --- 1. VIDEO PLAYER ---
// // //               VideoPlayerItem(videoUrl: data.videoUrl, videoId: data.id),

// // //               // --- 2. SIDE ACTIONS (LIKES, COMMENTS, SAVES) ---
// // //               Positioned(
// // //                 right: 15,
// // //                 bottom: 100,
// // //                 child: Column(
// // //                   children: [
// // //                     // Profile Pic + Follow Button
// // //                     _buildProfileSection(data, reelsController),
// // //                     const SizedBox(height: 20),

// // //                     // Like Button (Real-time Obx)
// // //                     Obx(() {
// // //                       final currentVideo = reelsController.videoList.firstWhere(
// // //                         (v) => v.id == data.id,
// // //                         orElse: () => data,
// // //                       );
// // //                       bool isLiked = currentVideo.likes.contains(
// // //                         FirebaseAuth.instance.currentUser!.uid,
// // //                       );
// // //                       return _buildActionItem(
// // //                         icon: Icons.favorite,
// // //                         label: "${currentVideo.likes.length}",
// // //                         color: isLiked ? Colors.red : Colors.white,
// // //                         onTap: () => reelsController.likeVideo(data.id),
// // //                       );
// // //                     }),
// // //                     const SizedBox(height: 20),

// // //                     // Comment Button
// // //                     _buildActionItem(
// // //                       icon: Icons.comment,
// // //                       label: "${data.commentCount}",
// // //                       onTap: () {
// // //                         // showCommentBottomSheet logic yahan add karein
// // //                       },
// // //                     ),
// // //                     const SizedBox(height: 20),

// // //                     // Favorite / Save Button (StreamBuilder)
// // //                     StreamBuilder<bool>(
// // //                       stream: reelsController.isFavorite(data.id),
// // //                       builder: (context, snapshot) {
// // //                         bool isFav = snapshot.data ?? false;
// // //                         return _buildActionItem(
// // //                           icon: isFav ? Icons.bookmark : Icons.bookmark_border,
// // //                           label: isFav ? "Saved" : "Save",
// // //                           color: isFav ? Colors.amber : Colors.white,
// // //                           onTap: () => reelsController.toggleFavorite(
// // //                             data.id,
// // //                             data.toJson(),
// // //                           ),
// // //                         );
// // //                       },
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),

// // //               // --- 3. USER INFO (BOTTOM) ---
// // //               Positioned(
// // //                 bottom: 30,
// // //                 left: 15,
// // //                 right: 80,
// // //                 child: Column(
// // //                   crossAxisAlignment: CrossAxisAlignment.start,
// // //                   children: [
// // //                     Text(
// // //                       "@${data.username}",
// // //                       style: const TextStyle(
// // //                         color: Colors.white,
// // //                         fontWeight: FontWeight.bold,
// // //                         fontSize: 16,
// // //                       ),
// // //                     ),
// // //                     const SizedBox(height: 8),
// // //                     Text(
// // //                       data.caption,
// // //                       style: const TextStyle(color: Colors.white, fontSize: 14),
// // //                       maxLines: 2,
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ),
// // //             ],
// // //           );
// // //         },
// // //       ),
// // //     );
// // //   }

// // //   // Profile section with Follow button logic
// // //   Widget _buildProfileSection(VideoModel data, ReelsController controller) {
// // //     return GestureDetector(
// // //       onTap: () => Get.to(() => ProfileScreen(uid: data.uid)),
// // //       child: Stack(
// // //         clipBehavior: Clip.none,
// // //         children: [
// // //           CircleAvatar(
// // //             radius: 25,
// // //             backgroundColor: Colors.white,
// // //             backgroundImage: NetworkImage(data.profilePic),
// // //           ),
// // //           StreamBuilder<bool>(
// // //             stream: controller.isFollowing(data.uid),
// // //             builder: (context, snapshot) {
// // //               if (data.uid == FirebaseAuth.instance.currentUser!.uid ||
// // //                   snapshot.data == true) {
// // //                 return const SizedBox.shrink();
// // //               }
// // //               return Positioned(
// // //                 bottom: -10,
// // //                 left: 15,
// // //                 child: GestureDetector(
// // //                   onTap: () => controller.followUser(data.uid),
// // //                   child: Container(
// // //                     decoration: const BoxDecoration(
// // //                       color: Colors.red,
// // //                       shape: BoxShape.circle,
// // //                     ),
// // //                     child: const Icon(Icons.add, color: Colors.white, size: 20),
// // //                   ),
// // //                 ),
// // //               );
// // //             },
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }

// // //   Widget _buildActionItem({
// // //     required IconData icon,
// // //     required String label,
// // //     Color color = Colors.white,
// // //     VoidCallback? onTap,
// // //   }) {
// // //     return GestureDetector(
// // //       onTap: onTap,
// // //       child: Column(
// // //         children: [
// // //           Icon(icon, color: color, size: 38),
// // //           const SizedBox(height: 5),
// // //           Text(
// // //             label,
// // //             style: const TextStyle(color: Colors.white, fontSize: 12),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/main_profile_screen.dart';
// // import 'package:pandlive/App/AppUi/ReelsVideo/Reels_Models.dart/reels_model.dart';
// // import 'package:pandlive/App/AppUi/ReelsVideo/reel_player_screen.dart';
// // import 'package:pandlive/App/AppUi/ReelsVideo/video_controllers.dart';

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
// //     // Controller ko initial index ke sath setup karein
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
// //         // 1. Agar list khali ho jaye to foran wapas profile par bhejein
// //         if (videoList.isEmpty) {
// //           Future.microtask(() => Get.back());
// //           return const SizedBox.shrink();
// //         }

// //         return PageView.builder(
// //           // 2. ValueKey lagane se Flutter ko pata chalega ke list modify hui hai
// //           // Ye line RangeError ko khatam karne ke liye sabse zaroori hai
// //           key: ValueKey(videoList.length),
// //           controller: pageController,
// //           scrollDirection: Axis.vertical,
// //           itemCount: videoList.length,
// //           physics: const AlwaysScrollableScrollPhysics(),
// //           itemBuilder: (context, index) {
// //             // 3. Mazeed safety check takay invalid index access na ho
// //             if (index >= videoList.length || index < 0) {
// //               return const SizedBox.shrink();
// //             }

// //             final data = videoList[index];

// //             return Stack(
// //               // Har video ke liye unique key takay state save rahe
// //               key: ValueKey(data.id),
// //               children: [
// //                 // --- VIDEO PLAYER ---
// //                 VideoPlayerItem(videoUrl: data.videoUrl, videoId: data.id),

// //                 // --- SIDE ACTIONS ---
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
// //                       // --- 3 Dots Icon (Sirf apni video par show hoga) ---
// // if (video.uid == FirebaseAuth.instance.currentUser!.uid)
// //   Column(
// //     children: [
// //       IconButton(
// //         icon: const Icon(Icons.more_horiz, color: Colors.white, size: 30),
// //         onPressed: () => _showDeleteOptions(context, video.id),
// //       ),
// //       const Text("More", style: TextStyle(color: Colors.white, fontSize: 12)),
// //     ],
// //   ),

// // // --- Function to show Bottom Sheet ---
// // void _showDeleteOptions(BuildContext context, String videoId) {
// //   final controller = Get.find<ProfileController>(tag: targetUid);

// //   showModalBottomSheet(
// //     context: context,
// //     shape: const RoundedRectangleBorder(
// //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
// //     ),
// //     builder: (context) {
// //       return Container(
// //         padding: const EdgeInsets.symmetric(vertical: 20),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             const Text("Options", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
// //             const Divider(),
// //             ListTile(
// //               leading: const Icon(Icons.delete_outline, color: Colors.red),
// //               title: const Text("Delete Video", style: TextStyle(color: Colors.red)),
// //               onPressed: () {
// //                 // Confirmation Dialog
// //                 Get.defaultDialog(
// //                   title: "Delete!",
// //                   middleText: "Are you sure you want to delete this video?",
// //                   textConfirm: "Yes",
// //                   textCancel: "No",
// //                   confirmTextColor: Colors.white,
// //                   onConfirm: () => controller.deleteVideo(videoId),
// //                 );
// //               },
// //             ),
// //             ListTile(
// //               leading: const Icon(Icons.cancel_outlined),
// //               title: const Text("Cancel"),
// //               onPressed: () => Get.back(),
// //             ),
// //           ],
// //         ),
// //       );
// //     },
// //   );
// // }
// //                     ],
// //                   ),
// //                 ),

// //                 // --- USER INFO ---
// //                 Positioned(
// //                   bottom: 30,
// //                   left: 15,
// //                   right: 80,
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         "@${data.username}",
// //                         style: const TextStyle(
// //                           color: Colors.white,
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 16,
// //                         ),
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

// //   // Profile Section Widget
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
// //                   snapshot.data == true) {
// //                 return const SizedBox.shrink();
// //               }
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

// //   // Action Icon Button Widget
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
//     // Controller ko initial index ke sath setup karein
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
//         // 1. Agar list khali ho jaye to foran wapas profile par bhejein
//         if (videoList.isEmpty) {
//           Future.microtask(() => Get.back());
//           return const SizedBox.shrink();
//         }

//         return PageView.builder(
//           // 2. ValueKey lagane se Flutter ko pata chalega ke list modify hui hai
//           key: ValueKey(videoList.length),
//           controller: pageController,
//           scrollDirection: Axis.vertical,
//           itemCount: videoList.length,
//           physics: const AlwaysScrollableScrollPhysics(),
//           itemBuilder: (context, index) {
//             // 3. Mazeed safety check takay invalid index access na ho
//             if (index >= videoList.length || index < 0) {
//               return const SizedBox.shrink();
//             }

//             final data = videoList[index];

//             return Stack(
//               // Har video ke liye unique key takay state save rahe
//               key: ValueKey(data.id),
//               children: [
//                 // --- VIDEO PLAYER ---
//                 VideoPlayerItem(videoUrl: data.videoUrl, videoId: data.id),

//                 // --- SIDE ACTIONS ---
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

//                       const SizedBox(height: 20),

//                       // --- 3 Dots Icon (Sirf apni video par show hoga) ---
//                       if (data.uid == FirebaseAuth.instance.currentUser!.uid)
//                         _buildActionItem(
//                           icon: Icons.more_horiz,
//                           label: "More",
//                           onTap: () =>
//                               _showDeleteOptions(context, data.id, data.uid),
//                         ),
//                     ],
//                   ),
//                 ),

//                 // --- USER INFO ---
//                 Positioned(
//                   bottom: 30,
//                   left: 15,
//                   right: 80,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "@${data.username}",
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 16,
//                         ),
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

//   // --- Function to show Bottom Sheet ---
//   void _showDeleteOptions(
//     BuildContext context,
//     String videoId,
//     String targetUid,
//   ) {
//     // Controller ko tag ke sath dhoondhein takay delete function mil sakay
//     final controller = Get.find<ProfileController>(tag: targetUid);

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.symmetric(vertical: 20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text(
//                 "Options",
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//               ),
//               const Divider(),
//               ListTile(
//                 leading: const Icon(Icons.delete_outline, color: Colors.red),
//                 title: const Text(
//                   "Delete Video",
//                   style: TextStyle(color: Colors.red),
//                 ),
//                 onTap: () {
//                   Get.back(); // Bottom sheet close karein
//                   Get.defaultDialog(
//                     title: "Delete Video",
//                     middleText: "Are you sure you want to delete this video?",
//                     textConfirm: "Delete",
//                     textCancel: "Cancel",
//                     confirmTextColor: Colors.white,
//                     buttonColor: Colors.red,
//                     onConfirm: () {
//                       controller.deleteVideo(videoId);
//                       Get.back(); // Dialog close karein
//                     },
//                   );
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.cancel_outlined),
//                 title: const Text("Cancel"),
//                 onTap: () => Get.back(),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Profile Section Widget
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

//   // Action Icon Button Widget
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
                      const SizedBox(height: 20),

                      // More Options (Privacy & Delete)
                      if (data.uid == FirebaseAuth.instance.currentUser!.uid)
                        _buildActionItem(
                          icon: Icons.more_horiz,
                          label: "More",
                          onTap: () => _showOptionsBottomSheet(context, data),
                        ),
                    ],
                  ),
                ),

                // User Info Section
                Positioned(
                  bottom: 30,
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
                          // Privacy Icon if video is private
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

  void _showOptionsBottomSheet(BuildContext context, VideoModel video) {
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

              // Privacy Toggle Option
              ListTile(
                leading: Icon(
                  isCurrentlyPrivate ? Icons.public : Icons.lock_outline,
                  color: Colors.black87,
                ),
                title: Text(
                  isCurrentlyPrivate ? "Make Public" : "Make Private",
                ),
                onTap: () =>
                    controller.toggleVideoPrivacy(video.id, isCurrentlyPrivate),
              ),

              // Delete Option
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

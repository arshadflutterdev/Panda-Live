// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/Follower_Following_Friends_Screens/following_main_screen.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/Follower_Following_Friends_Screens/friends_main_class.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/followers_main_class.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_screen_controller.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_widget.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/profile_related_video_screen.dart/video_details.dart';
// import 'package:pandlive/App/AppUi/ReelsVideo/Reels_Models.dart/reels_model.dart';

// class ProfileScreen extends StatelessWidget {
//   final String uid;
//   ProfileScreen({super.key, required this.uid});

//   @override
//   Widget build(BuildContext context) {
//     // Controller initialization with tag to handle multiple profiles
//     final controller = Get.put(ProfileController(uid), tag: uid);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Profile"),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         return DefaultTabController(
//           length: 3,
//           child: NestedScrollView(
//             headerSliverBuilder: (context, innerBoxIsScrolled) {
//               return [
//                 SliverToBoxAdapter(
//                   child: Column(
//                     children: [
//                       ProfileHeaderWidget(targetUid: controller.targetUid),
//                       const SizedBox(height: 10),
//                       // Stats Row
//                       // Stats Row
//                       Obx(
//                         () => Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             GestureDetector(
//                               onTap: () => Get.to(
//                                 () => FriendsListScreen(targetUid: uid),
//                               ),
//                               child: _buildStatColumn(
//                                 "Friends",
//                                 controller.friendsCount.value,
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () => Get.to(
//                                 () => FollowingListScreen(targetUid: uid),
//                               ),
//                               child: _buildStatColumn(
//                                 "Following",
//                                 controller.followingCount.value,
//                               ),
//                             ),
//                             GestureDetector(
//                               onTap: () => Get.to(
//                                 () => FollowersListScreen(targetUid: uid),
//                               ),
//                               child: _buildStatColumn(
//                                 "Followers",
//                                 controller.followerCount.value,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ), // Obx yahan khatam ho raha hai
//                       const SizedBox(height: 10),
//                     ],
//                   ),
//                 ),

//                 // Pinned TabBar (TikTok Style)
//                 SliverPersistentHeader(
//                   pinned: true,
//                   delegate: SliverTabBarDelegate(
//                     const TabBar(
//                       indicatorColor: Colors.black,
//                       labelColor: Colors.black,
//                       unselectedLabelColor: Colors.grey,
//                       indicatorWeight: 2,
//                       tabs: [
//                         Tab(
//                           icon: Icon(Icons.grid_on, size: 35),
//                         ), // User's Own Videos
//                         Tab(
//                           icon: Icon(Icons.favorite_border, size: 35),
//                         ), // Liked Videos
//                         Tab(
//                           icon: Icon(Icons.bookmark_border, size: 35),
//                         ), // Favorite Videos
//                       ],
//                     ),
//                   ),
//                 ),
//               ];
//             },
//             body: TabBarView(
//               children: [
//                 _buildVideoGrid("myVideos", controller),
//                 _buildVideoGrid("likedVideos", controller),
//                 _buildVideoGrid("favorites", controller),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   Widget _buildStatColumn(String label, int count) {
//     return Column(
//       children: [
//         Text(
//           "$count",
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
//       ],
//     );
//   }

//   // --- FIXED & DYNAMIC VIDEO GRID ---
//   Widget _buildVideoGrid(String type, ProfileController controller) {
//     return Obx(() {
//       List<VideoModel> currentList = [];

//       // Type ke mutabiq list select karein
//       if (type == "myVideos") {
//         currentList = controller.userVideos;
//       } else if (type == "likedVideos") {
//         currentList = controller.likedVideos;
//       } else if (type == "favorites") {
//         currentList = controller.favoriteVideos;
//       }

//       if (currentList.isEmpty) {
//         return Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 type == "myVideos"
//                     ? Icons.video_library_outlined
//                     : type == "likedVideos"
//                     ? Icons.favorite_outline
//                     : Icons.bookmark_outline,
//                 size: 50,
//                 color: Colors.grey,
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 "No videos found",
//                 style: TextStyle(color: Colors.grey[600]),
//               ),
//             ],
//           ),
//         );
//       }

//       return GridView.builder(
//         padding: const EdgeInsets.all(2),
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           crossAxisSpacing: 2,
//           mainAxisSpacing: 2,
//           childAspectRatio: 0.75,
//         ),
//         itemCount: currentList.length,
//         itemBuilder: (context, index) {
//           final video = currentList[index];

//           return GestureDetector(
//             onTap: () {
//               // Yahan click par video detail screen kholne ka logic lagayein
//               // Get.to(() => VideoDetailScreen(video: video));
//               Get.to(
//                 () => VideoDetailScreen(
//                   videoList:
//                       currentList, // 'currentList' tab ke mutabiq liked/user/fav hogi
//                   initialIndex: index, // User ne kis video pe click kiya
//                 ),
//                 transition: Transition.fade,
//               );
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.black,
//                 image: video.thumbnail.isNotEmpty
//                     ? DecorationImage(
//                         image: NetworkImage(video.thumbnail),
//                         fit: BoxFit.cover,
//                       )
//                     : null,
//               ),
//               child: Stack(
//                 children: [
//                   // Shadow overlay for readability
//                   Positioned.fill(
//                     child: Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             Colors.transparent,
//                             Colors.black.withOpacity(0.4),
//                           ],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     bottom: 4,
//                     left: 4,
//                     child: Row(
//                       children: [
//                         const Icon(
//                           Icons.play_arrow_outlined,
//                           color: Colors.white,
//                           size: 16,
//                         ),
//                         const SizedBox(width: 2),
//                         Text(
//                           "${video.views.length}",
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/Follower_Following_Friends_Screens/following_main_screen.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/Follower_Following_Friends_Screens/friends_main_class.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/followers_main_class.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_screen_controller.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_widget.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/profile_related_video_screen.dart/video_details.dart';
import 'package:pandlive/App/AppUi/ReelsVideo/Reels_Models.dart/reels_model.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;
  ProfileScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    // Controller initialization with tag to handle multiple profiles
    final controller = Get.put(ProfileController(uid), tag: uid);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      ProfileHeaderWidget(targetUid: controller.targetUid),
                      const SizedBox(height: 10),
                      // Stats Row
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () => Get.to(
                                () => FriendsListScreen(targetUid: uid),
                              ),
                              child: _buildStatColumn(
                                "Friends",
                                controller.friendsCount.value,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.to(
                                () => FollowingListScreen(targetUid: uid),
                              ),
                              child: _buildStatColumn(
                                "Following",
                                controller.followingCount.value,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.to(
                                () => FollowersListScreen(targetUid: uid),
                              ),
                              child: _buildStatColumn(
                                "Followers",
                                controller.followerCount.value,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                // Pinned TabBar (TikTok Style)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: SliverTabBarDelegate(
                    const TabBar(
                      indicatorColor: Colors.black,
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorWeight: 2,
                      tabs: [
                        Tab(
                          icon: Icon(Icons.grid_on, size: 35),
                        ), // User's Own Videos
                        Tab(
                          icon: Icon(Icons.favorite_border, size: 35),
                        ), // Liked Videos
                        Tab(
                          icon: Icon(Icons.bookmark_border, size: 35),
                        ), // Favorite Videos
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                _buildVideoGrid("myVideos", controller),
                _buildVideoGrid("likedVideos", controller),
                _buildVideoGrid("favorites", controller),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          "$count",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  // --- FIXED & DYNAMIC VIDEO GRID ---
  Widget _buildVideoGrid(String type, ProfileController controller) {
    return Obx(() {
      List<VideoModel> currentList = [];

      // Type ke mutabiq list select karein
      if (type == "myVideos") {
        currentList = controller.userVideos;
      } else if (type == "likedVideos") {
        currentList = controller.likedVideos;
      } else if (type == "favorites") {
        currentList = controller.favoriteVideos;
      }

      if (currentList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                type == "myVideos"
                    ? Icons.video_library_outlined
                    : type == "likedVideos"
                    ? Icons.favorite_outline
                    : Icons.bookmark_outline,
                size: 50,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              Text(
                "No videos found",
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(2),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
          childAspectRatio: 0.75,
        ),
        itemCount: currentList.length,
        itemBuilder: (context, index) {
          final video = currentList[index];

          return GestureDetector(
            onTap: () {
              Get.to(
                () => VideoDetailScreen(
                  videoList: currentList,
                  initialIndex: index,
                ),
                transition: Transition.fade,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                image: video.thumbnail.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(video.thumbnail),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  // Shadow overlay for readability
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                  // --- LOCK ICON (Top Right Corner) ---
                  if (video.isPrivate == true)
                    const Positioned(
                      top: 5,
                      right: 5,
                      child: Icon(Icons.lock, color: Colors.white70, size: 16),
                    ),

                  Positioned(
                    bottom: 4,
                    left: 4,
                    child: Row(
                      children: [
                        const Icon(
                          Icons.play_arrow_outlined,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          "${video.views.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

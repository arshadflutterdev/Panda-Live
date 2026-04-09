// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_screen_controller.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_widget.dart';

// class ProfileScreen extends StatelessWidget {
//   final String uid;
//   ProfileScreen({required this.uid});

//   @override
//   Widget build(BuildContext context) {
//     // Controller unique tag k sath initialize karen
//     final controller = Get.put(ProfileController(uid), tag: uid);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text("Profile"),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         foregroundColor: Colors.black,
//         elevation: 0,
//       ),
//       body: Obx(() {
//         if (controller.isLoading.value)
//           return Center(child: CircularProgressIndicator());

//         return DefaultTabController(
//           length: 2,
//           child: NestedScrollView(
//             headerSliverBuilder: (context, innerBoxIsScrolled) {
//               return [
//                 SliverToBoxAdapter(
//                   child: Column(
//                     children: [
//                       ProfileHeaderWidget(
//                         name: controller.user.value?.name ?? 'User',
//                         image: controller.user.value?.image ?? '',
//                         shortId: controller.user.value?.shortId ?? 0,
//                         isVerified: controller.user.value?.isVerified ?? false,
//                       ),
//                       const SizedBox(height: 20),
//                       // Stats Row
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           _buildStatColumn(
//                             "Friends",
//                             controller.friendsCount.value,
//                           ),
//                           _buildStatColumn(
//                             "Following",
//                             controller.followingCount.value,
//                           ),
//                           _buildStatColumn(
//                             "Followers",
//                             controller.followerCount.value,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),
//                     ],
//                   ),
//                 ),
//                 // Pinned TabBar (TikTok style)
//                 SliverPersistentHeader(
//                   pinned: true,
//                   delegate: SliverTabBarDelegate(
//                     TabBar(
//                       indicatorColor: Colors.black,
//                       labelColor: Colors.black,
//                       unselectedLabelColor: Colors.grey,
//                       tabs: [
//                         Tab(icon: Icon(Icons.grid_on)),
//                         Tab(icon: Icon(Icons.favorite_border)),
//                       ],
//                     ),
//                   ),
//                 ),
//               ];
//             },
//             body: TabBarView(
//               children: [
//                 _buildVideoGrid("myVideos"),
//                 _buildVideoGrid("likedVideos"),
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
//           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//         ),
//         Text(label, style: TextStyle(color: Colors.grey, fontSize: 12)),
//       ],
//     );
//   }

//   Widget _buildVideoGrid(String type) {
//     return GridView.builder(
//       padding: EdgeInsets.all(2),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 2,
//         mainAxisSpacing: 2,
//         childAspectRatio: 0.7,
//       ),
//       itemCount: 12, // Dummy count
//       itemBuilder: (context, index) => Container(color: Colors.grey[300]),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_screen_controller.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_widget.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;
  ProfileScreen({required this.uid});

  @override
  Widget build(BuildContext context) {
    // Controller initialization
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
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // ProfileScreen ke andar jahan ProfileHeaderWidget call ho raha hai
                      ProfileHeaderWidget(
                        // Purane parameters (name, image, etc.) nikal den
                        user: controller.user.value!,
                      ),
                      const SizedBox(height: 20),
                      // Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatColumn(
                            "Friends",
                            controller.friendsCount.value,
                          ),
                          _buildStatColumn(
                            "Following",
                            controller.followingCount.value,
                          ),
                          _buildStatColumn(
                            "Followers",
                            controller.followerCount.value,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // Pinned TabBar
              ];
            },
            body: TabBarView(
              children: [
                _buildVideoGrid("myVideos"),
                _buildVideoGrid("likedVideos"),
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

  Widget _buildVideoGrid(String type) {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 0.7,
      ),
      itemCount: 12, // Dummy count
      itemBuilder: (context, index) => Container(color: Colors.grey[300]),
    );
  }
} // <--- ProfileScreen class yahan khatam ho rahi hai

// --- YEH CLASSES BAAHAR HONI CHAHIYEIN ---

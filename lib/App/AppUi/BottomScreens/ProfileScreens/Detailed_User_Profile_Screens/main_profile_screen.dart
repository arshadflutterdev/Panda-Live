import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_screen_controller.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_widget.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;
  ProfileScreen({super.key, required this.uid});

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

        // Length ko 3 kiya taakay Favorites bhi add ho sakay
        return DefaultTabController(
          length: 3,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      ProfileHeaderWidget(targetUid: controller.targetUid),
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
                        Tab(icon: Icon(Icons.grid_on)), // My Videos
                        Tab(icon: Icon(Icons.favorite_border)), // Liked Videos
                        Tab(
                          icon: Icon(Icons.bookmark_border),
                        ), // Favorite Videos
                      ],
                    ),
                  ),
                ),
              ];
            },
            // Body mein teeno screens ka structure
            body: TabBarView(
              children: [
                _buildVideoGrid("myVideos"),
                _buildVideoGrid("likedVideos"),
                _buildVideoGrid("favorites"),
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

  // Improved Grid Design
  Widget _buildVideoGrid(String type) {
    return GridView.builder(
      padding: const EdgeInsets.all(2),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2,
        mainAxisSpacing: 2,
        childAspectRatio: 0.75, // TikTok standard portrait ratio
      ),
      itemCount: 15, // Filhal dummy count
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            // Yahan thumbnail lagayenge baad mein
          ),
          child: const Stack(
            children: [
              Positioned(
                bottom: 4,
                left: 4,
                child: Row(
                  children: [
                    Icon(
                      Icons.play_arrow_outlined,
                      color: Colors.white,
                      size: 14,
                    ),
                    Text(
                      "120",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

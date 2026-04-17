// import 'package:flutter/material.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_model.dart';

// // Fixes the 'minExtent' and 'maxExtent' error
// class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar tabBar;
//   SliverTabBarDelegate(this.tabBar);

//   @override
//   double get minExtent => tabBar.preferredSize.height;

//   @override
//   double get maxExtent => tabBar.preferredSize.height;

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     return Container(color: Colors.white, child: tabBar);
//   }

//   @override
//   bool shouldRebuild(SliverTabBarDelegate oldDelegate) => false;
// }

// // // User Info Header
// // User Info Header
// class ProfileHeaderWidget extends StatelessWidget {
//   final String name;
//   final String image;
//   final int shortId;
//   final bool isVerified;
//   final UserProfileModel user; // Direct model pass ho raha hai

//   const ProfileHeaderWidget({
//     super.key,
//     required this.name,
//     required this.image,
//     required this.shortId,
//     required this.isVerified,
//     required this.user,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const SizedBox(height: 20),
//         Stack(
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundColor: Colors.grey[200], // Placeholder color
//               backgroundImage: image.isNotEmpty
//                   ? NetworkImage(image)
//                   : const AssetImage('assets/images/default_user.png')
//                         as ImageProvider,
//             ),
//             if (isVerified)
//               const Positioned(
//                 bottom: 5,
//                 right: 5,
//                 child: Icon(Icons.verified, color: Colors.blue, size: 24),
//               ),
//           ],
//         ),
//         const SizedBox(height: 10),
//         Text(
//           "@$name",
//           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
//         ),
//         Text("ID: $shortId", style: const TextStyle(color: Colors.grey)),

//         // Agar aap model se mazeed data (bio etc) show krna chahein to yahan kr skte hain
//         if (user.bio.isNotEmpty)
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
//             child: Text(
//               user.bio,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 14),
//             ),
//           ),
//       ],
//     );
//   }
// }
// // class ProfileHeaderWidget extends StatelessWidget {
// //   final String name;
// //   final String image;
// //   final int shortId;
// //   final bool isVerified;
// //   final UserProfileModel user; // Direct model pass karein

// //   const ProfileHeaderWidget({
// //     required this.name,
// //     required this.image,
// //     required this.shortId,
// //     required this.isVerified,
// //     required this.user,
// //   });

// //   @override
// //   Widget build(BuildContext context) {
// //     return Column(
// //       children: [
// //         const SizedBox(height: 20),
// //         Stack(
// //           children: [
// //             CircleAvatar(
// //               radius: 50,
// //               backgroundColor: Colors.grey[200], // Placeholder color
// //               backgroundImage: image.isNotEmpty
// //                   ? NetworkImage(image)
// //                   : const AssetImage('assets/images/default_user.png')
// //                         as ImageProvider,
// //             ),
// //             if (isVerified)
// //               Positioned(
// //                 bottom: 5,
// //                 right: 5,
// //                 child: Icon(Icons.verified, color: Colors.blue, size: 24),
// //               ),
// //           ],
// //         ),
// //         const SizedBox(height: 10),
// //         Text(
// //           "@$name",
// //           style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
// //         ),
// //         Text("ID: $shortId", style: TextStyle(color: Colors.grey)),
// //       ],
// //     );
// //   }
// // }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/Edit_Main_Profile_Screen/edit_main_profile_screen.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_model.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_screen_controller.dart';

// Fixes the 'minExtent' and 'maxExtent' error
class SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(SliverTabBarDelegate oldDelegate) => false;
}

// User Info Header
class ProfileHeaderWidget extends StatelessWidget {
  final String targetUid; // User object ki jagah UID pass karein

  const ProfileHeaderWidget({super.key, required this.targetUid});

  @override
  Widget build(BuildContext context) {
    // Controller ko dhoondein tag ke zariye
    final controller = Get.find<ProfileController>(tag: targetUid);

    return Obx(() {
      // Agar user data abhi tak load nahi hua
      if (controller.user.value == null) return const SizedBox();

      final user = controller.user.value!;

      return Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: user.image.isNotEmpty
                ? CachedNetworkImageProvider(
                    user.image,
                  ) // Ye local cache se uthaye ga
                : const AssetImage('assets/images/default_user.png')
                      as ImageProvider,
          ),

          const SizedBox(height: 10),
          // ProfileHeaderWidget ke andar build method mein Name wali Row ko aise update karein:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "@${user.name}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              if (user.isVerified)
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Icon(Icons.verified, color: Colors.blue, size: 20),
                ),

              // --- Edit Button Logic ---
              if (targetUid == FirebaseAuth.instance.currentUser!.uid)
                IconButton(
                  icon: const Icon(
                    Icons.edit_note,
                    size: 22,
                    color: Colors.black54,
                  ),
                  onPressed: () => Get.to(() => const EditProfileScreen()),
                ),
            ],
          ),

          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       "@${user.name}",
          //       style: const TextStyle(
          //         fontWeight: FontWeight.bold,
          //         fontSize: 18,
          //       ),
          //     ),
          //     if (user.isVerified)
          //       const Padding(
          //         padding: EdgeInsets.only(left: 4),
          //         child: Icon(Icons.verified, color: Colors.blue, size: 20),
          //       ),
          //   ],
          // ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 40),
              Flexible(
                child: Text(
                  user.bio.isNotEmpty ? user.bio : "Add your bio",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                onPressed: () => _showEditBioDialog(context, controller, user),
              ),
            ],
          ),
        ],
      );
    });
  }

  void _showEditBioDialog(
    BuildContext context,
    ProfileController controller,
    UserProfileModel user,
  ) {
    final TextEditingController bioController = TextEditingController(
      text: user.bio,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Bio"),
        content: TextField(
          controller: bioController,
          autofocus: true,
          maxLength: 100,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateBio(bioController.text.trim());
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}

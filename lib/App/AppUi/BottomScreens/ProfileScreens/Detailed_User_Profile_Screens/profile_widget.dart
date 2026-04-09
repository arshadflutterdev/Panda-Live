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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final UserProfileModel user;

  const ProfileHeaderWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Profile Image
        CircleAvatar(
          radius: 50,
          backgroundImage: user.image.isNotEmpty
              ? NetworkImage(user.image)
              : const AssetImage('assets/images/default_user.png')
                    as ImageProvider,
        ),
        const SizedBox(height: 10),
        // User Name & Verified Icon
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "@${user.name}",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            if (user.isVerified)
              const Padding(
                padding: EdgeInsets.only(left: 4),
                child: Icon(Icons.verified, color: Colors.blue, size: 20),
              ),
          ],
        ),
        const SizedBox(height: 12),
        // Bio Section with Edit Button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 40), // Spacing to balance the icon button
            Flexible(
              child: Text(
                user.bio.isNotEmpty ? user.bio : "Add your bio",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
              onPressed: () => _showEditBioDialog(context),
            ),
          ],
        ),
      ],
    );
  }

  // Edit Bio Dialog function
  void _showEditBioDialog(BuildContext context) {
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
          decoration: const InputDecoration(
            hintText: "Enter your bio (e.g. Buy)",
            counterText: "",
          ),
          maxLength: 100,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // Find the controller using the tag and update
              Get.find<ProfileController>(
                tag: user.uid,
              ).updateBio(bioController.text.trim());
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}

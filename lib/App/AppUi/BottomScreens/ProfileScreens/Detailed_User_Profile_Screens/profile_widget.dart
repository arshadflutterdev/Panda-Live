// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/Edit_Main_Profile_Screen/edit_main_profile_screen.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_model.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_screen_controller.dart';

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

// // User Info Header
// class ProfileHeaderWidget extends StatelessWidget {
//   final String targetUid; // User object ki jagah UID pass karein

//   const ProfileHeaderWidget({super.key, required this.targetUid});

//   @override
//   Widget build(BuildContext context) {
//     // Controller ko dhoondein tag ke zariye
//     final controller = Get.find<ProfileController>(tag: targetUid);

//     return Obx(() {
//       // Agar user data abhi tak load nahi hua
//       if (controller.user.value == null) return const SizedBox();

//       final user = controller.user.value!;

//       return Column(
//         children: [
//           const SizedBox(height: 10),
//           CircleAvatar(
//             radius: 50,
//             backgroundImage: user.image.isNotEmpty
//                 ? CachedNetworkImageProvider(
//                     user.image,
//                   ) // Ye local cache se uthaye ga
//                 : const AssetImage('assets/images/default_user.png')
//                       as ImageProvider,
//           ),

//           const SizedBox(height: 10),
//           // ProfileHeaderWidget ke andar build method mein Name wali Row ko aise update karein:
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "@${user.name}",
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               if (user.isVerified)
//                 const Padding(
//                   padding: EdgeInsets.only(left: 4),
//                   child: Icon(Icons.verified, color: Colors.blue, size: 20),
//                 ),

//               // --- Edit Button Logic ---
//               if (targetUid == FirebaseAuth.instance.currentUser!.uid)
//                 IconButton(
//                   icon: const Icon(
//                     Icons.edit_note,
//                     size: 22,
//                     color: Colors.black54,
//                   ),
//                   onPressed: () => Get.to(() => const EditProfileScreen()),
//                 ),
//             ],
//           ),

//           // --- Bio Section ---
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(width: 10), // Spacing for alignment
//               Flexible(
//                 child: Text(
//                   // Agar bio khali hai to "No bio yet" show karega
//                   user.bio.isNotEmpty ? user.bio : "No bio yet",
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(fontSize: 14, color: Colors.black87),
//                 ),
//               ),

//               // --- Edit Icon Condition ---
//               // Sirf tab show hoga jab profile apni hogi
//               if (targetUid == FirebaseAuth.instance.currentUser!.uid)
//                 IconButton(
//                   icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
//                   onPressed: () =>
//                       _showEditBioDialog(context, controller, user),
//                 )
//               else
//                 const SizedBox(width: 10), // Balance spacing if no icon
//             ],
//           ),
//         ],
//       );
//     });
//   }

//   void _showEditBioDialog(
//     BuildContext context,
//     ProfileController controller,
//     UserProfileModel user,
//   ) {
//     final TextEditingController bioController = TextEditingController(
//       text: user.bio,
//     );

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Edit Bio"),
//         content: TextField(
//           controller: bioController,
//           autofocus: true,
//           maxLength: 100,
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               controller.updateBio(bioController.text.trim());
//               Navigator.pop(context);
//             },
//             child: const Text("Save"),
//           ),
//         ],
//       ),
//     );
//   }
// }
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
    final String currentUid = FirebaseAuth.instance.currentUser!.uid;

    return Obx(() {
      // Agar user data abhi tak load nahi hua
      if (controller.user.value == null) return const SizedBox();

      final user = controller.user.value!;

      return Column(
        children: [
          const SizedBox(height: 10),
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
              if (targetUid == currentUid)
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

          // --- Bio Section ---
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10), // Spacing for alignment
              Flexible(
                child: Text(
                  // Agar bio khali hai to "No bio yet" show karega
                  user.bio.isNotEmpty ? user.bio : "No bio yet",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ),

              // --- Edit Icon Condition ---
              // Sirf tab show hoga jab profile apni hogi
              if (targetUid == currentUid)
                IconButton(
                  icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                  onPressed: () =>
                      _showEditBioDialog(context, controller, user),
                )
              else
                const SizedBox(width: 10), // Balance spacing if no icon
            ],
          ),

          const SizedBox(height: 20),

          // --- Real-time Follow/Edit Button Logic ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: targetUid == currentUid
                ? SizedBox(
                    width: double.infinity,
                    height: 42,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: () => Get.to(() => const EditProfileScreen()),
                      child: const Text(
                        "Edit profile",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  )
                : Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: controller.isFollowing.value
                                ? Colors.grey[200]
                                : Colors.redAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () => controller.toggleFollow(),
                          child: Text(
                            controller.isFollowing.value
                                ? "Unfollow"
                                : "Follow",
                            style: TextStyle(
                              color: controller.isFollowing.value
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          ),
          const SizedBox(height: 10),
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

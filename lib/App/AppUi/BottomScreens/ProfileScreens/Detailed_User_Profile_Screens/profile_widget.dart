import 'package:flutter/material.dart';
import 'package:pandlive/App/AppUi/BottomScreens/ProfileScreens/Detailed_User_Profile_Screens/profile_model.dart';
import 'package:url_launcher/url_launcher.dart';

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

// // User Info Header
// User Info Header

class ProfileHeaderWidget extends StatelessWidget {
  final String name;
  final String image;
  final int shortId;
  final bool isVerified;
  final UserProfileModel user;

  const ProfileHeaderWidget({
    super.key,
    required this.name,
    required this.image,
    required this.shortId,
    required this.isVerified,
    required this.user,
  });

  // Link open karne ka function
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url.startsWith('http') ? url : 'https://$url');
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        // Profile Image
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200],
              backgroundImage: image.isNotEmpty
                  ? NetworkImage(image)
                  : const AssetImage('assets/images/default_user.png')
                        as ImageProvider,
            ),
            if (isVerified)
              const Positioned(
                bottom: 5,
                right: 5,
                child: Icon(Icons.verified, color: Colors.blue, size: 24),
              ),
          ],
        ),
        const SizedBox(height: 10),
        // Name
        Text(
          "@$name",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),

        const SizedBox(height: 5),

        // ID ya "Buy" Text Section
        // Agar bio khali nahi hai to bio dikhayen (jaisa aapne "Buy" likha tha), warna shortId
        Text(
          user.bio.isNotEmpty ? user.bio : "ID: $shortId",
          style: const TextStyle(color: Colors.black87, fontSize: 14),
        ),

        const SizedBox(height: 10),

        // Clickable Link Section
        if (user.youtubeLink.isNotEmpty)
          GestureDetector(
            onTap: () => _launchURL(user.youtubeLink),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.link, size: 18, color: Colors.blue),
                  const SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      user.youtubeLink,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

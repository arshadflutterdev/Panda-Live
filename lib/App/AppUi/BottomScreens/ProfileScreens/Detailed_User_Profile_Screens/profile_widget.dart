import 'package:flutter/material.dart';

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
  final String name;
  final String image;
  final int shortId;
  final bool isVerified;

  const ProfileHeaderWidget({
    required this.name,
    required this.image,
    required this.shortId,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Stack(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[200], // Placeholder color
              backgroundImage: image.isNotEmpty
                  ? NetworkImage(image)
                  : const AssetImage('assets/images/default_user.png')
                        as ImageProvider,
            ),
            if (isVerified)
              Positioned(
                bottom: 5,
                right: 5,
                child: Icon(Icons.verified, color: Colors.blue, size: 24),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          "@$name",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Text("ID: $shortId", style: TextStyle(color: Colors.grey)),
      ],
    );
  }
}

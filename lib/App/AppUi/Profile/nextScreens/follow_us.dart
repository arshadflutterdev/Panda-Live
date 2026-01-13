import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';

class FollowUs extends StatelessWidget {
  const FollowUs({super.key});

  // final String facebookUrl = "https://www.facebook.com/";
  // final String youtubeUrl = "https://www.youtube.com/";

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: const Text("Follow Us"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Card(
            elevation: 5,
            color: Colors.white,
            child: ListTile(
              leading: Image.asset(AppImages.facebook, height: 30, width: 30),
              title: const Text("Facebook"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ),
          Card(
            elevation: 5,
            color: Colors.white,
            child: ListTile(
              leading: Image.asset(AppImages.yt, height: 30, width: 30),
              title: const Text("YouTube"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

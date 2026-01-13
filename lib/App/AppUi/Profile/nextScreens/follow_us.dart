import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';

class FollowUs extends StatelessWidget {
  const FollowUs({super.key});

  // Replace these URLs with your actual pages
  final String facebookUrl = "https://www.facebook.com/";
  final String youtubeUrl = "https://www.youtube.com/";

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildButton({
    required String label,
    required String image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(image, height: 30, width: 30),
            const SizedBox(width: 15),
            Text(label, style: AppStyle.btext.copyWith(fontSize: 16)),
            const Spacer(),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.black38,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Follow Us"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildButton(
            label: "Facebook",
            image: AppImages.facebook, // Make sure you have this asset
            onTap: () => _launchURL(facebookUrl),
          ),
          _buildButton(
            label: "YouTube",
            image: AppImages.google, // Make sure you have this asset
            onTap: () => _launchURL(youtubeUrl),
          ),
        ],
      ),
    );
  }
}

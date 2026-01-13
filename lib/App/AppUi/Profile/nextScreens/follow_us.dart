import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';
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
    bool isArabic = Get.locale?.languageCode == "ar";
    final localization = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text(
          localization.followus,
          style: isArabic
              ? AppStyle.arabictext.copyWith(fontSize: 26)
              : TextStyle(),
        ),
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
              title: Text(
                isArabic ? "فيسبوك" : "Facebook",
                style: isArabic
                    ? AppStyle.arabictext.copyWith(fontSize: 22)
                    : TextStyle(),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ),
          Card(
            elevation: 5,
            color: Colors.white,
            child: ListTile(
              leading: Image.asset(AppImages.yt, height: 30, width: 30),
              title: Text(
                isArabic ? "يوتيوب" : "YouTube",
                style: isArabic
                    ? AppStyle.arabictext.copyWith(fontSize: 22)
                    : TextStyle(),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen> {
  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    bool isArabic = Get.locale?.languageCode == "ar";
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Gap(height * 0.20),
          Center(
            child: Image(
              image: AssetImage(AppImages.notfollow),
              height: height * 0.30,
              width: width,
            ),
          ),
          Text(
            isArabic
                ? "لم تتابع بعد، تعال للمتابعة"
                : "You haven't followed yet, come to follow",
          ),
        ],
      ),
    );
  }
}

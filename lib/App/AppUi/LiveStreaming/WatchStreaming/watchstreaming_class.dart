import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';

class WatchstreamingClass extends StatefulWidget {
  const WatchstreamingClass({super.key});

  @override
  State<WatchstreamingClass> createState() => _WatchstreamingClassState();
}

class _WatchstreamingClassState extends State<WatchstreamingClass> {
  final arg = Get.arguments as Map<String, dynamic>? ?? {};
  String get images => arg["images"] ?? "";
  String get namess => arg["names"] ?? "";
  String get arnames => arg["arabicnam"] ?? "";
  String get country => arg["country"] ?? "";
  String get view => arg["views"] ?? "";

  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    bool isArabic = Get.locale?.languageCode == "ar";
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage(images)),
        ),
        child: Stack(
          children: [
            Positioned(
              child: Row(
                children: [
                  CircleAvatar(radius: 20, backgroundImage: AssetImage(images)),
                  Text(isArabic ? arnames : namess),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

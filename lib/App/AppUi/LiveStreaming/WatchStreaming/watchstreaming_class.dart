import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

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
              top: height * 0.040,
              left: 10,

              child: Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(images),
                      ),
                      Gap(5),
                      Text(
                        isArabic ? arnames : namess,
                        style: isArabic
                            ? AppStyle.arabictext.copyWith(fontSize: 20)
                            : TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                      ),
                      Image(image: AssetImage(country), height: 18, width: 18),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

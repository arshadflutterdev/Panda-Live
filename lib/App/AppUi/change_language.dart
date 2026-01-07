import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  RxInt selectedlanguage = 1.obs;
  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Image(fit: BoxFit.cover, image: AssetImage(AppImages.halfbg)),
          Gap(height * 0.15),
          Obx(
            () => selectedlanguage.value == 1
                ? Text("Change App Language", style: AppStyle.logo)
                : Text(
                    "تغيير لغة التطبيق",
                    style: AppStyle.arabictext.copyWith(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          Gap(height * 0.040),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(width * 0.45, height * 0.060),
                    backgroundColor: selectedlanguage.value == 1
                        ? AppColours.blues
                        : Colors.black,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  onPressed: () {
                    selectedlanguage.value = 1;
                    Get.snackbar(
                      backgroundColor: Colors.black,
                      colorText: Colors.white,
                      "English",
                      "Your selected langauge is English",
                    );
                  },
                  child: Text(
                    "English",
                    style: AppStyle.btext.copyWith(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),

              Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(width * 0.45, height * 0.060),
                    backgroundColor: selectedlanguage.value == 2
                        ? AppColours.blues
                        : Colors.black,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  onPressed: () {
                    selectedlanguage.value = 2;
                    Get.snackbar(
                      "",
                      "",
                      colorText: Colors.white,
                      backgroundColor: Colors.black,

                      titleText: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "عربي",
                          style: AppStyle.arabictext.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),

                      messageText: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "اللغة التي اخترتها هي العربية",
                          style: AppStyle.arabictext.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "عربي",
                    style: AppStyle.btext.copyWith(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(height * .050),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "I have read and agreed the",
                style: TextStyle(color: Colors.black),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.terms);
                },
                child: Text(
                  "PandaLive terms of Services",
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

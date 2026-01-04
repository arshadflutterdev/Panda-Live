import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class AuthOptions extends StatefulWidget {
  const AuthOptions({super.key});

  @override
  State<AuthOptions> createState() => _AuthOptionsState();
}

class _AuthOptionsState extends State<AuthOptions> {
  //here is list of images
  RxList imagess = [].obs;
  RxBool checkValue = false.obs;
  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Gap(height * 0.20),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: height * 0.082,
                  width: width * 0.20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(AppImages.logo),
                    ),
                  ),
                ),
                Gap(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("PandaLive", style: AppStyle.logo),

                    Text("Live. Stream. Connect."),
                  ],
                ),
              ],
            ),
            Gap(height * 0.10),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  // Icon(CupertinoIcons.goog)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    child: Image(
                      height: 30,
                      width: 40,
                      image: AssetImage(AppImages.google),
                    ),
                  ),
                  Gap(width * 0.080),
                  Text(
                    "Login with Google",
                    style: AppStyle.btext.copyWith(color: Colors.blue),
                  ),
                ],
              ),
            ),

            Gap(15),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  // Icon(CupertinoIcons.goog)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    child: Image(
                      height: 30,
                      width: 40,
                      image: AssetImage(AppImages.facebook),
                    ),
                  ),
                  Gap(width * 0.050),
                  Text(
                    "Login with Facebook",
                    style: AppStyle.btext.copyWith(color: Colors.blue),
                  ),
                ],
              ),
            ),
            Gap(height * 0.080),
            Image(image: AssetImage(AppImages.or)),
            Gap(height * 0.030),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(backgroundImage: AssetImage(AppImages.email)),
                Gap(20),
                CircleAvatar(backgroundImage: AssetImage(AppImages.phone)),
              ],
            ),
            Gap(height * 0.10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () => Checkbox(
                    shape: CircleBorder(),
                    activeColor: Colors.green,
                    checkColor: Colors.white,

                    value: checkValue.value,
                    onChanged: (newvalue) {
                      checkValue.value = newvalue ?? false;
                    },
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("I have read and agreed the"),
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
          ],
        ),
      ),
    );
  }
}

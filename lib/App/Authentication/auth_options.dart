import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/App/Widgets/DialogBox/terms_dialog.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class AuthOptions extends StatefulWidget {
  const AuthOptions({super.key});

  @override
  State<AuthOptions> createState() => _AuthOptionsState();
}

class _AuthOptionsState extends State<AuthOptions> {
  RxBool checkValue = false.obs;
  RxList imagess = [
    AppImages.girl1,
    AppImages.girl2,
    AppImages.girl3,
    AppImages.girl4,
    AppImages.girl5,
    AppImages.girl6,
    AppImages.girl7,
    AppImages.girl8,
    AppImages.girl9,
  ].obs;

  RxInt currentimage = 0.obs;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Pre-cache images for smoother transitions (optional but recommended)
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      currentimage.value = (currentimage.value + 1) % imagess.length;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  //here below to show dialogebox
  bool isNavigate = false;
  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);

    return Scaffold(
      backgroundColor: Colors.black, // Set to black to avoid white flashes
      body: Obx(
        () => AnimatedSwitcher(
          duration: const Duration(
            seconds: 2,
          ), // Adjust for a slower, smoother blend
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          // This builder ensures the images are stacked on top of each other
          layoutBuilder: (Widget? currentChild, List<Widget> previousChildren) {
            return Stack(
              children: <Widget>[
                ...previousChildren,
                if (currentChild != null) currentChild,
              ],
            );
          },
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(opacity: animation, child: child);
          },
          child: Container(
            // The Key is vital to tell Flutter the child has changed
            key: ValueKey<int>(currentimage.value),
            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(imagess[currentimage.value]),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Gap(height * 0.20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: height * 0.090,
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
                            Text(
                              "PandaLive",
                              style: AppStyle.logo.copyWith(
                                color: Colors.white,
                              ),
                            ),

                            Text(
                              "Live. Stream. Connect.",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Gap(height * 0.10),
                    GestureDetector(
                      onTap: () {
                        if (checkValue.value == true) {
                          Get.toNamed(AppRoutes.createprofile);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => TermsDialog(
                              onAccept: () {
                                Get.back();
                                Get.toNamed(AppRoutes.createprofile);
                              },
                            ),
                          );
                        }
                      },

                      child: Container(
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
                              style: AppStyle.btext.copyWith(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // here is image
                    Gap(15),
                    GestureDetector(
                      onTap: () {
                        if (checkValue.value == true) {
                          Get.toNamed(AppRoutes.createprofile);
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => TermsDialog(
                              onAccept: () {
                                Get.back();
                                Get.toNamed(AppRoutes.createprofile);
                              },
                            ),
                          );
                        }
                      },

                      child: Container(
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
                              style: AppStyle.btext.copyWith(
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(height * 0.080),
                    Image(image: AssetImage(AppImages.or)),
                    Gap(height * 0.030),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (checkValue.value == true) {
                              Get.toNamed(AppRoutes.emailauth);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => TermsDialog(
                                  onAccept: () {
                                    Get.back();
                                    Get.toNamed(AppRoutes.emailauth);
                                  },
                                ),
                              );
                            }
                          },

                          child: CircleAvatar(
                            backgroundImage: AssetImage(AppImages.email),
                          ),
                        ),
                        Gap(20),
                        GestureDetector(
                          onTap: () {
                            if (checkValue.value == true) {
                              Get.toNamed(AppRoutes.userauth);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => TermsDialog(
                                  onAccept: () {
                                    Get.back();
                                    Get.toNamed(AppRoutes.userauth);
                                  },
                                ),
                              );
                            }
                          },

                          child: CircleAvatar(
                            backgroundImage: AssetImage(AppImages.userId),
                          ),
                        ),

                        Gap(20),
                        GestureDetector(
                          onTap: () {
                            if (checkValue.value == true) {
                              Get.toNamed(AppRoutes.phoneauth);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => TermsDialog(
                                  onAccept: () {
                                    Get.back();
                                    Get.toNamed(AppRoutes.phoneauth);
                                  },
                                ),
                              );
                            }
                          },

                          child: CircleAvatar(
                            backgroundImage: AssetImage(AppImages.phone),
                          ),
                        ),
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
                            Text(
                              "I have read and agreed the",
                              style: TextStyle(color: Colors.white),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

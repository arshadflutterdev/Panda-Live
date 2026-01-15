import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/App/Widgets/Buttons/elevatedbutton0.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  TextEditingController smsController = TextEditingController();
  TextEditingController passController = TextEditingController();
  RxBool isSMSEmtpy = false.obs;
  RxBool isCodeEmpty = false.obs;
  RxInt seconds = 120.obs;
  RxBool canResend = false.obs;
  bool isArabic = Get.locale?.languageCode == "ar";
  Timer? timr;
  RxBool isSecure = true.obs;
  final _formkey = GlobalKey<FormState>();
  void starttimer() {
    seconds.value = 120;
    timr?.cancel();

    timr = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (seconds.value > 0) {
        seconds.value--;
      } else {
        // Get.back();
        t.cancel();
      }
    });
  }

  String formatTime(int totalseconds) {
    final minutes = (totalseconds ~/ 60).toString().padLeft(2, "0");
    final seconds = (totalseconds % 60).toString().padLeft(2, "0");
    return "$minutes:$seconds";
  }

  void resendemail() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final email = Get.arguments["email"];
    try {
      final user = firebaseAuth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        starttimer();
        Get.snackbar(
          colorText: Colors.white,
          backgroundColor: Colors.black,

          "Resended",
          "Verification link sent again.",
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    starttimer();
  }

  void dispose() {
    timr?.cancel();
    super.dispose();
  }

  RxBool isLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    final arg = Get.arguments;
    final userid = "";
    final username = "";
    final email = "";
    if (arg != null && arg is Map<String, dynamic>) {
      final userid = arg["userId"] ?? "";
      final username = arg["userName"] ?? "";
      print("here is email user name $username");
      final email = arg["email"] ?? "";
    } else {
      print("No arguments found");
    }

    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    final localization = AppLocalizations.of(context)!;
    // double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Container(
              height: height * 0.27,
              width: width,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(AppImages.halfbg),
                ),
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 6,
                  ),
                  child: IconButton(
                    onPressed: () async {
                      final user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        try {
                          await user.delete();
                        } catch (e) {
                          print("deleting user ${e.toString()}");
                        }
                      }
                      if (!mounted) return;

                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 2,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gap(height * 0.5),
                      Text(
                        localization.verifyemail,
                        style: isArabic
                            ? AppStyle.arabictext.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              )
                            : AppStyle.btext.copyWith(fontSize: 22),
                      ),
                      Row(
                        children: [
                          Text(
                            localization.verificationlink,
                            style: isArabic
                                ? AppStyle.arabictext.copyWith(
                                    color: Colors.black54,
                                  )
                                : TextStyle(color: Colors.black54),
                          ),
                          Gap(2),
                          Text(email.toString()),
                        ],
                      ),
                      Gap(height * 0.030),

                      Form(
                        key: _formkey,
                        child: Column(
                          children: [
                            Obx(
                              () => MyTextFormField(
                                validator: (value) {
                                  if (passController.text.isEmpty) {
                                    return localization.createpassword;
                                  } else if (passController.text.length < 8) {
                                    return localization.code8digits;
                                  }
                                  return null;
                                },
                                obscure: isSecure.value,
                                controller: passController,
                                keyboard: TextInputType.text,
                                hintext: localization.createpassword,
                                onChanged: (newValue) {
                                  isCodeEmpty.value = newValue.isNotEmpty;
                                },
                                suffix: SizedBox(
                                  height: 20,
                                  width: width * 0.27,

                                  child: Row(
                                    children: [
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          passController.clear();
                                        },
                                        icon: isCodeEmpty.value
                                            ? Icon(
                                                Icons.close,
                                                color: Colors.black54,
                                              )
                                            : SizedBox.shrink(),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          isSecure.value = !isSecure.value;
                                        },
                                        icon: isSecure.value
                                            ? Image(
                                                height: 25,

                                                image: AssetImage(
                                                  AppImages.eyesoff,
                                                ),
                                              )
                                            : Image(
                                                height: 25,
                                                image: AssetImage(
                                                  AppImages.eyeson,
                                                ),
                                              ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                localization.setpassword,
                                style: isArabic
                                    ? AppStyle.arabictext.copyWith(
                                        color: Colors.black54,
                                      )
                                    : TextStyle(color: Colors.black54),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Obx(
                        () => seconds.value != 0
                            ? Text(
                                "Resend available in ${formatTime(seconds.value)}",
                              )
                            : TextButton(
                                onPressed: resendemail,
                                child: Text("Resend verification email"),
                              ),
                      ),
                      Gap(height * 0.030),
                      Center(
                        child: MyElevatedButton(
                          width: width,
                          btext: Obx(
                            () => isLoading.value
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text(
                                    localization.buttonnext,
                                    style: isArabic
                                        ? AppStyle.arabictext.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          )
                                        : AppStyle.btext.copyWith(
                                            color: Colors.white,
                                          ),
                                  ),
                          ),
                          onPressed: () async {
                            if (_formkey.currentState!.validate()) {
                              isLoading.value = true;
                              await FirebaseAuth.instance.currentUser!.reload();
                              final user = FirebaseAuth.instance.currentUser;
                              if (user != null && user.emailVerified) {
                                isLoading.value = false;
                                await user.updatePassword(
                                  passController.text.trim(),
                                );
                                Get.offAllNamed(
                                  AppRoutes.createprofile,
                                  arguments: {
                                    "userId": userid,
                                    "username": username,
                                    "userpass": passController.text,
                                  },
                                );
                              } else {
                                isLoading.value = false;
                                Get.snackbar(
                                  "Email not verified",
                                  "Please verify your email",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }

                              isLoading.value = false;
                            }
                          },
                        ),
                      ),
                      Gap(height * 0.010),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              localization.readAndAgree,
                              style: isArabic
                                  ? AppStyle.arabictext
                                  : TextStyle(color: Colors.black),
                            ),
                          ),

                          GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.terms);
                            },
                            child: Text(
                              localization.pterms,
                              style: isArabic
                                  ? AppStyle.arabictext.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.blue,
                                    )
                                  : TextStyle(color: Colors.blueAccent),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/App/Widgets/Buttons/elevatedbutton0.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
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
  RxInt seconds = 60.obs;
  RxBool canResend = false.obs;
  bool isArabic = Get.locale?.languageCode == "ar";
  Timer? timr;
  RxBool isSecure = true.obs;
  final _formkey = GlobalKey<FormState>();
  void starttimer() {
    seconds.value = 60;
    canResend.value = false;
    timr = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (seconds.value > 0) {
        seconds.value--;
      } else {
        canResend.value = true;
        // Get.back();
        t.cancel();
      }
    });
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
    final arg = Get.arguments as Map<String, dynamic>;
    final userid = arg["userId"];
    final username = arg["userName"];
    final email = arg["email"];

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
                      await FirebaseAuth.instance.currentUser!.delete();
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
                          Text(email),
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
                                "Resend available in ${seconds.value.toString()}",
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
                                Get.toNamed(AppRoutes.createprofile);
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

                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed(AppRoutes.loginemail);
                          },
                          child: Text(localization.alreadyaccount),
                        ),
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

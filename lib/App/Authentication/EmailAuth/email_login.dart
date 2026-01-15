import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({super.key});

  @override
  State<EmailLogin> createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  RxBool isCodeEmpty = false.obs;
  RxBool isSecure = true.obs;
  RxBool isLoading = false.obs;
  bool isArabic = Get.locale?.languageCode == "ar";
  RxBool isEmailEmpty = false.obs;
  //function to login
  Future<void> loginwithemail() async {
    final email = emailController.text.trim();
    final password = passController.text.trim();
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    try {
      UserCredential usercredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User? user = usercredential.user;
      if (user != null) {
        Get.toNamed(AppRoutes.bottomnav);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        Get.snackbar(
          titleText: Text(
            isArabic ? "لم يتم العثور على الحساب" : "Account Not Found",
            style: isArabic
                ? AppStyle.arabictext.copyWith(color: Colors.white)
                : TextStyle(color: Colors.white),
          ),
          messageText: Text(
            isArabic
                ? "عفواً! لم يتم تسجيل هذا البريد الإلكتروني بعد."
                : "Oops! This email is not registered yet.",
            style: isArabic
                ? AppStyle.arabictext.copyWith(color: Colors.white)
                : TextStyle(color: Colors.white),
          ),

          "",
          "",
          backgroundColor: Colors.red,
        );
      } else if (e.code == "wrong-password") {
        Get.snackbar(
          titleText: Text(
            isArabic ? "كلمة المرور غير صحيحة" : "Incorrect Password",
            style: isArabic
                ? AppStyle.arabictext.copyWith(color: Colors.white)
                : TextStyle(color: Colors.white),
          ),
          messageText: Text(
            isArabic
                ? "كلمة المرور التي أدخلتها غير صحيحة. يرجى المحاولة مرة أخرى."
                : "The password you entered is incorrect. Please try again.",
            style: isArabic
                ? AppStyle.arabictext.copyWith(color: Colors.white)
                : TextStyle(color: Colors.white),
          ),
          "",
          "",
          backgroundColor: Colors.red,
        );
      } else {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = AppHeightwidth.screenWidth(context);
    double height = AppHeightwidth.screenHeight(context);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: false,
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Form(
                    key: _formkey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(height * 0.050),
                          Obx(
                            () => MyTextFormField(
                              keyboard: TextInputType.emailAddress,
                              validator: (value) {
                                if (emailController.text.isEmpty) {
                                  return localization.enteremail;
                                } else if (!emailController.text.contains(
                                  "@gmail.com",
                                )) {
                                  return localization.validemail;
                                }
                                return null;
                              },
                              controller: emailController,
                              hintext: localization.enteremail,
                              onChanged: (newValue) {
                                isEmailEmpty.value = newValue.isNotEmpty;
                              },
                              suffix: isEmailEmpty.value
                                  ? IconButton(
                                      onPressed: () {
                                        emailController.clear();
                                        isEmailEmpty.value = false;
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.black54,
                                      ),
                                    )
                                  : null,
                            ),
                          ),
                          Gap(10),
                          Text(
                            localization.enter8pass,
                            style: isArabic ? AppStyle.arabictext : TextStyle(),
                          ),
                          Gap(height * 0.005),
                          Obx(
                            () => MyTextFormField(
                              validator: (value) {
                                if (passController.text.isEmpty) {
                                  return localization.enteryourpass;
                                } else if (passController.text.length < 8) {
                                  return localization.code8digits;
                                }
                                return null;
                              },
                              obscure: isSecure.value,
                              controller: passController,
                              keyboard: TextInputType.text,
                              hintext: localization.enteryourpass,
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
                            alignment: Alignment.bottomRight,
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(AppRoutes.resetpassword);
                              },
                              child: Text(
                                localization.forgetpass,
                                style: isArabic
                                    ? AppStyle.arabictext.copyWith(
                                        color: AppColours.blues,
                                      )
                                    : TextStyle(color: AppColours.blues),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Gap(height * 0.020),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColours.blues,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        fixedSize: Size(width * 0.60, 45),
                      ),
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          isLoading.value = true;
                          await loginwithemail();
                          isLoading.value = false;
                        }
                      },
                      child: Obx(
                        () => isLoading.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                localization.buttonnext,
                                style: isArabic
                                    ? AppStyle.arabictext.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color: Colors.white,
                                      )
                                    : AppStyle.btext.copyWith(
                                        color: Colors.white,
                                      ),
                              ),
                      ),
                    ),
                  ),
                  Gap(height * 0.030),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          localization.readAndAgree,
                          style: isArabic
                              ? AppStyle.arabictext.copyWith(
                                  color: Colors.black,
                                )
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
                              ? AppStyle.arabictext.copyWith(color: Colors.blue)
                              : TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

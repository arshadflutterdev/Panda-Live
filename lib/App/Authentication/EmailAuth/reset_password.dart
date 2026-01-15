import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Authentication/EmailAuth/EmailAuthControllers/resetpassword_controller.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/App/Widgets/Buttons/elevatedbutton0.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  RxBool isSMSEmtpy = false.obs;
  RxBool isCodeEmpty = false.obs;
  bool isArabic = Get.locale?.languageCode == "ar";
  RxInt seconds = 60.obs;
  RxBool isloading = false.obs;
  Timer? timr;
  RxBool isSecure = true.obs;
  final _formkey = GlobalKey<FormState>();

  RxBool isEmailEmpty = false.obs;
  final ResetpasswordController resetpassword = Get.find();

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    timr?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    // double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
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
                      localization.resetpass,
                      style: isArabic
                          ? AppStyle.arabictext.copyWith(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            )
                          : AppStyle.btext.copyWith(fontSize: 22),
                    ),
                    Text(
                      isArabic
                          ? "لا تقلق! سنساعدك على إعادة تعيين كلمة المرور عبر البريد الإلكتروني."
                          : "Don’t worry! We’ll help you reset your password via email.",
                      style: isArabic
                          ? AppStyle.arabictext.copyWith(color: Colors.black54)
                          : TextStyle(color: Colors.black54),
                    ),
                    Gap(height * 0.030),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Obx(
                            () => MyTextFormField(
                              keyboard: TextInputType.emailAddress,
                              validator: (value) {
                                if (resetpassword
                                    .emailController
                                    .text
                                    .isEmpty) {
                                  return localization.enteremail;
                                } else if (!resetpassword.emailController.text
                                    .contains("@gmail.com")) {
                                  return localization.validemail;
                                }
                                return null;
                              },
                              controller: resetpassword.emailController,
                              hintext: localization.enteremail,
                              onChanged: (newValue) {
                                isEmailEmpty.value = newValue.isNotEmpty;
                              },
                              suffix: isEmailEmpty.value
                                  ? IconButton(
                                      onPressed: () {
                                        resetpassword.emailController.clear();
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
                        ],
                      ),
                    ),
                    Gap(height * 0.030),
                    Center(
                      child: MyElevatedButton(
                        width: width,
                        btext: Obx(
                          () => isloading.value
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  localization.reset,
                                  style: isArabic
                                      ? AppStyle.arabictext.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        )
                                      : AppStyle.btext.copyWith(
                                          color: Colors.white,
                                        ),
                                ),
                        ),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            isloading.value = true;
                            await resetpassword.resetPassword();
                            isloading.value = false;
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
                                ? AppStyle.arabictext.copyWith(
                                    color: Colors.black54,
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
                                ? AppStyle.arabictext.copyWith(
                                    color: Colors.blueAccent,
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
    );
  }
}

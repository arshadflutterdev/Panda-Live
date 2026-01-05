import 'dart:async';

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

class PhoneResetPassword extends StatefulWidget {
  const PhoneResetPassword({super.key});

  @override
  State<PhoneResetPassword> createState() => _PhoneResetPasswordState();
}

class _PhoneResetPasswordState extends State<PhoneResetPassword> {
  TextEditingController smsController = TextEditingController();
  TextEditingController passController = TextEditingController();
  RxBool isSMSEmtpy = false.obs;
  RxBool isCodeEmpty = false.obs;
  RxInt seconds = 60.obs;
  Timer? timr;
  RxBool isSecure = true.obs;
  final _formkey = GlobalKey<FormState>();
  void starttimer() {
    timr = Timer.periodic(Duration(seconds: 1), (Timer t) {
      if (seconds.value > 0) {
        seconds.value--;
      } else {
        t.cancel();
      }
    });
  }

  void otp() {
    Timer(Duration(seconds: 3), () {
      Get.snackbar(
        "Code",
        "128025 is your code",
        backgroundColor: AppColours.blues,
        colorText: Colors.white,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    starttimer();
    otp();
  }

  void dispose() {
    timr?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      "Reset Password",
                      style: AppStyle.btext.copyWith(fontSize: 22),
                    ),
                    Text(
                      "verification code send to +966 ******345 ",
                      style: TextStyle(color: Colors.black54),
                    ),
                    Gap(height * 0.030),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Obx(
                            () => MyTextFormField(
                              validator: (value) {
                                if (smsController.text.isEmpty) {
                                  return "Type Code";
                                } else if (!smsController.text.contains(
                                  "128025",
                                )) {
                                  return "Code Incorrect";
                                }
                                return null;
                              },
                              controller: smsController,
                              keyboard: TextInputType.number,
                              hintext: "Type 6 digits code",
                              onChanged: (newValue) {
                                isSMSEmtpy.value = newValue.isNotEmpty;
                              },
                              suffix: IconButton(
                                onPressed: () {
                                  smsController.clear();
                                },
                                icon: isSMSEmtpy.value
                                    ? Icon(Icons.close, color: Colors.black54)
                                    : SizedBox.shrink(),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Obx(() {
                                if (seconds.value > 0) {
                                  return Text(
                                    "${seconds.value}s letterResend SMS",
                                  );
                                } else {
                                  return TextButton(
                                    onPressed: () {
                                      seconds.value = 60;
                                      starttimer();

                                      Get.snackbar(
                                        backgroundColor: AppColours.blues,

                                        "Resend",
                                        "SMS resend successfully",
                                        colorText: Colors.white,
                                      );
                                      Timer(Duration(seconds: 5), () {
                                        otp();
                                      });
                                    },
                                    child: Text(
                                      "Resend SMS",
                                      style: TextStyle(color: AppColours.blues),
                                    ),
                                  );
                                }
                              }),
                              Gap(4),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: TextButton(
                              onPressed: () {
                                Get.offAllNamed(AppRoutes.authoptions);
                              },
                              child: Text(
                                "Try another method?",
                                style: TextStyle(color: AppColours.blues),
                              ),
                            ),
                          ),

                          Obx(
                            () => MyTextFormField(
                              validator: (value) {
                                if (passController.text.isEmpty) {
                                  return "Create Your Password";
                                } else if (passController.text.length < 8) {
                                  return "Password must be 8 digits";
                                }
                                return null;
                              },
                              obscure: isSecure.value,
                              controller: passController,
                              keyboard: TextInputType.number,
                              hintext: "Create New Password",
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
                              "Set 6-8 digits code with letters&numbers",
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gap(height * 0.030),
                    Center(
                      child: MyElevatedButton(
                        width: width,
                        btext: "Next",
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            Get.toNamed(AppRoutes.bottomnav);
                          }
                          Get.snackbar(
                            "Password Reset",
                            "Your Password reset successfully",
                            colorText: Colors.white,
                            backgroundColor: AppColours.blues,
                          );
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
                            "I have read and agreed the",
                            style: TextStyle(color: Colors.black),
                          ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

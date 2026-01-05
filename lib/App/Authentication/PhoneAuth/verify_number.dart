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

class VerifyNumber extends StatefulWidget {
  const VerifyNumber({super.key});

  @override
  State<VerifyNumber> createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {
  TextEditingController smsController = TextEditingController();
  TextEditingController passController = TextEditingController();
  RxBool isSMSEmtpy = false.obs;
  RxBool isCodeEmpty = false.obs;
  RxInt seconds = 60.obs;
  Timer? timr;
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

  @override
  void initState() {
    super.initState();
    starttimer();
  }

  void dispose() {
    timr?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(AppImages.bgimage),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 20,
                    left: 0,
                    child: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(bottom: keyboardHeight + 5),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(height * 0.35),

                    Text(
                      "Login With Phone number",
                      style: AppStyle.btext.copyWith(fontSize: 22),
                    ),
                    Text(
                      "verification code send to SMS +966 ******34",
                      style: TextStyle(color: Colors.black54),
                    ),
                    Gap(height * 0.030),
                    Form(
                      key: _formkey,
                      child: Column(
                        children: [
                          Obx(
                            () => MyTextFormField(
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
                          Row(
                            children: [
                              Text(
                                "Chnage the way?",
                                style: TextStyle(color: Colors.black54),
                              ),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Resend Watsapp?",
                                  style: TextStyle(color: AppColours.blues),
                                ),
                              ),
                            ],
                          ),

                          Obx(
                            () => MyTextFormField(
                              controller: passController,
                              keyboard: TextInputType.number,
                              hintext: "Create Password",
                              onChanged: (newValue) {
                                isCodeEmpty.value = newValue.isNotEmpty;
                              },
                              suffix: IconButton(
                                onPressed: () {
                                  passController.clear();
                                },
                                icon: isCodeEmpty.value
                                    ? Icon(Icons.close, color: Colors.black54)
                                    : SizedBox.shrink(),
                              ),
                            ),
                          ),

                          Text(
                            "Set 6-8 digits code with letters&numbers",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    Gap(height * 0.030),
                    Center(
                      child: MyElevatedButton(
                        width: width,
                        btext: "Next",
                        onPressed: () {},
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

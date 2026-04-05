import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/BottomScreens/homescreen.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/App/Widgets/Buttons/elevatedbutton0.dart';
import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';

class VerifyNumber extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  final int? resendToken;

  const VerifyNumber({
    super.key,
    required this.verificationId,
    required this.phoneNumber,
    this.resendToken,
  });

  @override
  State<VerifyNumber> createState() => _VerifyNumberState();
}

class _VerifyNumberState extends State<VerifyNumber> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isSecure = true.obs;
  RxInt seconds = 60.obs;
  Timer? _timer;

  bool get isArabic => Get.locale?.languageCode == "ar";

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void startTimer() {
    seconds.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds.value > 0) {
        seconds.value--;
      } else {
        timer.cancel();
      }
    });
  }

  void resendOTP() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phoneNumber,
        forceResendingToken: widget.resendToken,
        verificationCompleted: (_) {},
        verificationFailed: (e) {
          Get.snackbar(
            "Error",
            e.message ?? "Failed to resend OTP",
            backgroundColor: AppColours.blues,
            colorText: Colors.white,
          );
        },
        codeSent: (verificationId, resendToken) {
          Get.snackbar(
            "OTP Sent",
            "A new OTP has been sent.",
            backgroundColor: AppColours.blues,
            colorText: Colors.white,
          );
          startTimer();
        },
        codeAutoRetrievalTimeout: (_) {},
        timeout: const Duration(seconds: 60),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Unexpected error occurred. Try again.",
        backgroundColor: AppColours.blues,
        colorText: Colors.white,
      );
    }
  }

  Future<void> verifyOTP() async {
    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic> arg = Get.arguments ?? {};
    final String vId = widget.verificationId.isNotEmpty
        ? widget.verificationId
        : (arg["verificationId"] ?? "");
    final String pNum = widget.phoneNumber.isNotEmpty
        ? widget.phoneNumber
        : (arg["phoneNumber"] ?? "");

    try {
      isLoading.value = true;

      final credential = PhoneAuthProvider.credential(
        verificationId: vId,
        smsCode: otpController.text.trim(),
      );

      // Sign in the user
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      // Check if it's a new user or existing
      bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      isLoading.value = false;

      if (isNewUser) {
        // CASE 1: Naya User hai -> Create Profile screen par bhejein
        final shortUserId = Random().nextInt(900000) + 100000;
        Get.offAllNamed(
          AppRoutes.createprofile,
          arguments: {
            "userId": userCredential.user?.uid,
            "shortId": shortUserId,
            "phoneNumber": pNum,
          },
        );
      } else {
        // CASE 2: Purana User hai -> Direct Home/BottomNav par bhejein
        Get.offAllNamed(AppRoutes.bottomnav);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Invalid OTP or Connection Issue.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  // Future<void> verifyOTP() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   // 1. Arguments ko safely pakrein
  //   final Map<String, dynamic> arg = Get.arguments ?? {};

  //   // Phone number aur verification ID agar constructor se na milein to arguments se lein
  //   final String vId = widget.verificationId.isNotEmpty
  //       ? widget.verificationId
  //       : (arg["verificationId"] ?? "");
  //   final String pNum = widget.phoneNumber.isNotEmpty
  //       ? widget.phoneNumber
  //       : (arg["phoneNumber"] ?? "");

  //   final String userid = arg["userId"]?.toString() ?? "";
  //   final String username = arg["userName"]?.toString() ?? "";

  //   try {
  //     isLoading.value = true;

  //     // 2. Variable use karein jo upar define kiye hain
  //     final credential = PhoneAuthProvider.credential(
  //       verificationId: vId,
  //       smsCode: otpController.text.trim(),
  //     );

  //     await FirebaseAuth.instance.signInWithCredential(credential);

  //     // Success logic
  //     final shortUserId = Random().nextInt(900000) + 100000;

  //     isLoading.value = false;

  //     // 3. Agli screen pe sara data bhej dein
  //     Get.offAllNamed(
  //       AppRoutes.createprofile,
  //       arguments: {
  //         "userId": userid,
  //         "username": username,
  //         "userpass": passwordController
  //             .text, // OTP ki jagah password bhejein jo user ne create kiya h
  //         "shortId": shortUserId,
  //         "phoneNumber": pNum,
  //       },
  //     );
  //   } catch (e) {
  //     isLoading.value = false;
  //     Get.snackbar(
  //       "Error",
  //       "Invalid OTP or Connection Issue.",
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final width = AppHeightwidth.screenWidth(context);
    final height = AppHeightwidth.screenHeight(context);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          // Top Image + Back Button
          Container(
            height: height * 0.27,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(AppImages.halfbg),
              ),
            ),
            child: Align(
              alignment: isArabic ? Alignment.topRight : Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 6,
                ),
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.loginwithphone,
                    style: isArabic
                        ? AppStyle.arabictext.copyWith(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          )
                        : AppStyle.btext.copyWith(fontSize: 22),
                  ),
                  Text(
                    "${localization.phonecodesend} ${widget.phoneNumber}",
                    style: isArabic
                        ? AppStyle.arabictext.copyWith(color: Colors.black54)
                        : const TextStyle(color: Colors.black54),
                  ),
                  const Gap(20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // OTP Field
                        MyTextFormField(
                          controller: otpController,
                          keyboard: TextInputType.number,
                          hintext: localization.hint6ditis,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return localization.hint6ditis;
                            }
                            if (value.length != 6) {
                              return localization.codeincorrect;
                            }
                            return null;
                          },
                        ),

                        Gap(10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() {
                              if (seconds.value > 0) {
                                return Text(
                                  "${seconds.value}s ${localization.lettersend}",
                                );
                              } else {
                                return TextButton(
                                  onPressed: resendOTP,
                                  child: Text(
                                    localization.resms,
                                    style: TextStyle(color: AppColours.blues),
                                  ),
                                );
                              }
                            }),
                          ],
                        ),

                        const Gap(10),

                        // Password Field
                        // Obx(
                        //   () => MyTextFormField(
                        //     controller: passwordController,
                        //     hintext: localization.createpassword,
                        //     obscure: isSecure.value,
                        //     validator: (value) {
                        //       if (value == null || value.isEmpty) {
                        //         return localization.createpassword;
                        //       }
                        //       if (value.length < 8) {
                        //         return localization.code8digits;
                        //       }
                        //       return null;
                        //     },
                        //     suffix: SizedBox(
                        //       height: 20,
                        //       width: width * 0.27,
                        //       child: Row(
                        //         children: [
                        //           IconButton(
                        //             padding: EdgeInsets.zero,
                        //             icon: const Icon(
                        //               Icons.close,
                        //               color: Colors.black54,
                        //             ),
                        //             onPressed: () => passwordController.clear(),
                        //           ),
                        //           IconButton(
                        //             padding: EdgeInsets.zero,
                        //             icon: isSecure.value
                        //                 ? Image.asset(
                        //                     AppImages.eyesoff,
                        //                     height: 30,
                        //                   )
                        //                 : Image.asset(
                        //                     AppImages.eyeson,
                        //                     height: 30,
                        //                   ),
                        //             onPressed: () =>
                        //                 isSecure.value = !isSecure.value,
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //     keyboard: TextInputType.number,
                        //   ),
                        // ),
                        // Align(
                        //   alignment: isArabic
                        //       ? Alignment.topRight
                        //       : Alignment.topLeft,
                        //   child: Text(
                        //     localization.setpassword,
                        //     style: TextStyle(color: Colors.black54),
                        //   ),
                        // ),
                        // const Gap(30),

                        // Verify Button
                        Center(
                          child: MyElevatedButton(
                            width: width,
                            btext: Obx(
                              () => isLoading.value
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      localization.buttonnext,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                            onPressed: verifyOTP,
                          ),
                        ),
                        const Gap(10),

                        // Terms
                        Center(
                          child: Column(
                            children: [
                              Text(
                                localization.readAndAgree,
                                style: isArabic
                                    ? AppStyle.arabictext
                                    : const TextStyle(color: Colors.black),
                              ),
                              GestureDetector(
                                onTap: () => Get.toNamed(AppRoutes.terms),
                                child: Text(
                                  localization.pterms,
                                  style: TextStyle(
                                    color: AppColours.blues,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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

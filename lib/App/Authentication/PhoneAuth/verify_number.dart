// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:pandlive/App/AppUi/BottomScreens/homescreen.dart';
// import 'package:pandlive/App/Routes/app_routes.dart';
// import 'package:pandlive/App/Widgets/Buttons/elevatedbutton0.dart';
// import 'package:pandlive/App/Widgets/TextFields/textfield.dart';
// import 'package:pandlive/Utils/Constant/app_colours.dart';
// import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
// import 'package:pandlive/Utils/Constant/app_images.dart';
// import 'package:pandlive/Utils/Constant/app_style.dart';
// import 'package:pandlive/l10n/app_localizations.dart';

// class VerifyNumber extends StatefulWidget {
//   final String verificationId;
//   const VerifyNumber({
//     super.key,
//     required this.verificationId,
//     int? resendToken,
//     required String phoneNumber,
//   });

//   @override
//   State<VerifyNumber> createState() => _VerifyNumberState();
// }

// class _VerifyNumberState extends State<VerifyNumber> {
//   TextEditingController smsController = TextEditingController();
//   TextEditingController passController = TextEditingController();
//   RxBool isSMSEmtpy = false.obs;
//   RxBool isCodeEmpty = false.obs;
//   RxInt seconds = 60.obs;
//   RxBool isloading = false.obs;
//   Timer? timr;
//   RxBool isSecure = true.obs;
//   final _formkey = GlobalKey<FormState>();
//   void starttimer() {
//     timr = Timer.periodic(Duration(seconds: 1), (Timer t) {
//       if (seconds.value > 0) {
//         seconds.value--;
//       } else {
//         t.cancel();
//       }
//     });
//   }

//   void otp() {
//     Timer(Duration(seconds: 3), () {
//       Get.snackbar(
//         AppLocalizations.of(context)!.code,
//         AppLocalizations.of(context)!.isyourcode,
//         backgroundColor: AppColours.blues,
//         colorText: Colors.white,
//       );
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     starttimer();
//     otp();
//   }

//   void dispose() {
//     timr?.cancel();
//     super.dispose();
//   }

//   bool isArabic = Get.locale?.languageCode == "ar";

//   @override
//   Widget build(BuildContext context) {
//     double height = AppHeightwidth.screenHeight(context);
//     double width = AppHeightwidth.screenWidth(context);
//     final localization = AppLocalizations.of(context)!;
//     // double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       resizeToAvoidBottomInset: true,
//       body: Column(
//         children: [
//           Container(
//             height: height * 0.27,
//             width: width,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               image: DecorationImage(
//                 fit: BoxFit.cover,
//                 image: AssetImage(AppImages.halfbg),
//               ),
//             ),
//             child: Align(
//               alignment: isArabic ? Alignment.topRight : Alignment.topLeft,
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   vertical: 12,
//                   horizontal: 6,
//                 ),
//                 child: IconButton(
//                   onPressed: () {
//                     Get.back();
//                   },
//                   icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: SingleChildScrollView(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 2,
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Gap(height * 0.5),
//                     Text(
//                       localization.loginwithphone,
//                       style: isArabic
//                           ? AppStyle.arabictext.copyWith(
//                               fontSize: 24,
//                               fontWeight: FontWeight.w600,
//                             )
//                           : AppStyle.btext.copyWith(fontSize: 22),
//                     ),
//                     Text(
//                       localization.phonecodesend,
//                       style: isArabic
//                           ? AppStyle.arabictext.copyWith(color: Colors.black54)
//                           : TextStyle(color: Colors.black54),
//                     ),
//                     Gap(height * 0.030),
//                     Form(
//                       key: _formkey,
//                       child: Column(
//                         children: [
//                           Obx(
//                             () => MyTextFormField(
//                               validator: (value) {
//                                 if (smsController.text.isEmpty) {
//                                   return localization.hint6ditis;
//                                 } else if (!smsController.text.contains(
//                                   "258012",
//                                 )) {
//                                   return localization.codeincorrect;
//                                 }
//                                 return null;
//                               },
//                               controller: smsController,
//                               keyboard: TextInputType.number,
//                               hintext: localization.hint6ditis,
//                               onChanged: (newValue) {
//                                 isSMSEmtpy.value = newValue.isNotEmpty;
//                               },
//                               suffix: IconButton(
//                                 onPressed: () {
//                                   smsController.clear();
//                                 },
//                                 icon: isSMSEmtpy.value
//                                     ? Icon(Icons.close, color: Colors.black54)
//                                     : SizedBox.shrink(),
//                               ),
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Obx(() {
//                                 if (seconds.value > 0) {
//                                   return Text(
//                                     "${seconds.value}s ${localization.lettersend}",
//                                   );
//                                 } else {
//                                   return TextButton(
//                                     onPressed: () {
//                                       seconds.value = 60;
//                                       starttimer();

//                                       Get.snackbar(
//                                         backgroundColor: AppColours.blues,

//                                         localization.resms,
//                                         localization.smssended,
//                                         colorText: Colors.white,
//                                       );
//                                       Timer(Duration(seconds: 5), () {
//                                         otp();
//                                       });
//                                     },
//                                     child: Text(
//                                       localization.resms,
//                                       style: isArabic
//                                           ? AppStyle.arabictext.copyWith(
//                                               color: AppColours.blues,
//                                             )
//                                           : TextStyle(color: AppColours.blues),
//                                     ),
//                                   );
//                                 }
//                               }),
//                               Gap(4),
//                             ],
//                           ),
//                           Align(
//                             alignment: isArabic
//                                 ? Alignment.bottomRight
//                                 : Alignment.bottomLeft,
//                             child: TextButton(
//                               onPressed: () {
//                                 Get.offAllNamed(AppRoutes.authoptions);
//                               },
//                               child: Text(
//                                 localization.tryanother,
//                                 style: isArabic
//                                     ? AppStyle.arabictext.copyWith(
//                                         color: AppColours.blues,
//                                       )
//                                     : TextStyle(color: AppColours.blues),
//                               ),
//                             ),
//                           ),

//                           Obx(
//                             () => MyTextFormField(
//                               validator: (value) {
//                                 if (passController.text.isEmpty) {
//                                   return localization.createpassword;
//                                 } else if (passController.text.length < 8) {
//                                   return localization.code8digits;
//                                 }
//                                 return null;
//                               },
//                               obscure: isSecure.value,
//                               controller: passController,
//                               keyboard: TextInputType.text,
//                               hintext: localization.createpassword,
//                               onChanged: (newValue) {
//                                 isCodeEmpty.value = newValue.isNotEmpty;
//                               },
//                               suffix: SizedBox(
//                                 height: 20,
//                                 width: width * 0.27,

//                                 child: Row(
//                                   children: [
//                                     IconButton(
//                                       padding: EdgeInsets.zero,
//                                       onPressed: () {
//                                         passController.clear();
//                                       },
//                                       icon: isCodeEmpty.value
//                                           ? Icon(
//                                               Icons.close,
//                                               color: Colors.black54,
//                                             )
//                                           : SizedBox.shrink(),
//                                     ),
//                                     IconButton(
//                                       padding: EdgeInsets.zero,
//                                       onPressed: () {
//                                         isSecure.value = !isSecure.value;
//                                       },
//                                       icon: isSecure.value
//                                           ? Image(
//                                               height: 30,

//                                               image: AssetImage(
//                                                 AppImages.eyesoff,
//                                               ),
//                                             )
//                                           : Image(
//                                               height: 30,
//                                               image: AssetImage(
//                                                 AppImages.eyeson,
//                                               ),
//                                             ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),

//                           Align(
//                             alignment: isArabic
//                                 ? Alignment.topRight
//                                 : Alignment.topLeft,
//                             child: Text(
//                               localization.setpassword,
//                               style: isArabic
//                                   ? AppStyle.arabictext.copyWith(
//                                       color: Colors.black54,
//                                     )
//                                   : TextStyle(color: Colors.black54),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Gap(height * 0.030),
//                     Center(
//                       child: MyElevatedButton(
//                         width: width,
//                         btext: Obx(
//                           () => isloading.value
//                               ? CircularProgressIndicator(color: Colors.white)
//                               : Text(
//                                   localization.buttonnext,
//                                   style: isArabic
//                                       ? AppStyle.arabictext.copyWith(
//                                           fontSize: 22,
//                                           fontWeight: FontWeight.w600,
//                                           color: Colors.white,
//                                         )
//                                       : AppStyle.btext.copyWith(
//                                           color: Colors.white,
//                                         ),
//                                 ),
//                         ),

//                         onPressed: () async {
//                           try {
//                             PhoneAuthCredential credential =
//                                 PhoneAuthProvider.credential(
//                                   verificationId: widget.verificationId,
//                                   smsCode: smsController.text.toString(),
//                                 );
//                             await FirebaseAuth.instance
//                                 .signInWithCredential(credential)
//                                 .then((Value) {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => Homescreen(),
//                                     ),
//                                   );
//                                 });
//                           } catch (e) {}
//                         },

//                         // onPressed: () {
//                         //   if (_formkey.currentState!.validate()) {
//                         //     isloading.value = true;
//                         //     Timer(Duration(seconds: 2), () {
//                         //       isloading.value = false;
//                         //       Get.toNamed(AppRoutes.createprofile);
//                         //     });
//                         //   }
//                         // },
//                       ),
//                     ),
//                     Gap(height * 0.010),
//                     Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Center(
//                           child: Text(
//                             localization.readAndAgree,
//                             style: isArabic
//                                 ? AppStyle.arabictext
//                                 : TextStyle(color: Colors.black),
//                           ),
//                         ),

//                         GestureDetector(
//                           onTap: () {
//                             Get.toNamed(AppRoutes.terms);
//                           },
//                           child: Text(
//                             localization.pterms,
//                             style: isArabic
//                                 ? AppStyle.arabictext.copyWith(
//                                     fontWeight: FontWeight.w600,
//                                     color: Colors.blue,
//                                   )
//                                 : TextStyle(color: Colors.blueAccent),
//                           ),
//                         ),
//                       ],
//                     ),

//                     Align(
//                       alignment: Alignment.center,
//                       child: TextButton(
//                         onPressed: () {
//                           Get.toNamed(AppRoutes.phonelogin);
//                         },
//                         child: Text(localization.alreadyaccount),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
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

    try {
      isLoading.value = true;
      final credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: otpController.text.trim(),
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      isLoading.value = false;

      Get.offAll(() => Homescreen());
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        "Error",
        "Invalid OTP. Try again.",
        backgroundColor: AppColours.blues,
        colorText: Colors.white,
      );
    }
  }

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
                        const Gap(10),
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
                            TextButton(
                              onPressed: () =>
                                  Get.toNamed(AppRoutes.phonelogin),
                              child: Text(localization.tryanother),
                            ),
                          ],
                        ),
                        const Gap(20),

                        // Password Field
                        Obx(
                          () => MyTextFormField(
                            controller: passwordController,
                            hintext: localization.createpassword,
                            obscure: isSecure.value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return localization.createpassword;
                              }
                              if (value.length < 8) {
                                return localization.code8digits;
                              }
                              return null;
                            },
                            suffix: SizedBox(
                              height: 20,
                              width: width * 0.27,
                              child: Row(
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.black54,
                                    ),
                                    onPressed: () => passwordController.clear(),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: isSecure.value
                                        ? Image.asset(
                                            AppImages.eyesoff,
                                            height: 30,
                                          )
                                        : Image.asset(
                                            AppImages.eyeson,
                                            height: 30,
                                          ),
                                    onPressed: () =>
                                        isSecure.value = !isSecure.value,
                                  ),
                                ],
                              ),
                            ),
                            keyboard: TextInputType.number,
                          ),
                        ),
                        Align(
                          alignment: isArabic
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          child: Text(
                            localization.setpassword,
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        const Gap(30),

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

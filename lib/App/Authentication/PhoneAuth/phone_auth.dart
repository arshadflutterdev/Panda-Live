import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_intl_phone_field/flutter_intl_phone_field.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Authentication/PhoneAuth/verify_number.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({super.key});

  @override
  State<PhoneAuth> createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  RxBool isloading = false.obs;
  TextEditingController phoneController = TextEditingController();
  bool isArabic = Get.locale?.languageCode == "ar";
  final _formkey = GlobalKey<FormState>();
  //below function signinwithphone
  Future<void> signinwithphone() async {
    final auth = FirebaseAuth.instance;
    auth.setLanguageCode(Get.locale?.languageCode ?? 'en'); // Locale fix

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            final userCredential = await auth.signInWithCredential(credential);
            if (userCredential.user != null) {
              Get.toNamed(AppRoutes.verifynumber);
            }
          } catch (e) {
            debugPrint("Auto sign-in failed: $e");
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          String message = "Something went wrong. Try again.";
          switch (e.code) {
            case 'invalid-phone-number':
              message = "Invalid phone number format.";
              break;
            case 'too-many-requests':
              message = "Too many requests. Try later.";
              break;
            case 'network-request-failed':
              message = "Network error. Check internet.";
              break;
            case 'quota-exceeded':
              message = "SMS quota exceeded. Try later.";
              break;
          }
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(message)));
          debugPrint("Phone auth failed: ${e.code} - ${e.message}");
        },
        codeSent: (verificationId, resendToken) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VerifyNumber(
                verificationId: verificationId,
                phoneNumber: phoneController.text,
                resendToken: resendToken,
              ),
            ),
          );
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      debugPrint("verifyPhoneNumber exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Unexpected error occurred.")),
      );
    }
  }

  // Future<UserCredential?> signinwithphone() async {
  //   final auth = FirebaseAuth.instance;
  //   try {
  //     await auth.verifyPhoneNumber(
  //       phoneNumber: phoneController.text,
  //       verificationCompleted: (PhoneAuthCredential credential) async {
  //         await auth.signInWithCredential(credential);
  //         Get.toNamed(AppRoutes.verifynumber);
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         if (e.code == "invalid-phone-number") {
  //           print('The provided phone number is not valid.');
  //         }
  //         print(e.toString());
  //       },
  //       codeSent: (String verificationId, int? resendToken) async {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => VerifyNumber(
  //               verificationId: verificationId,
  //               phoneNumber: phoneController.text.toString(),
  //             ),
  //           ),
  //         );
  //       },
  //       timeout: Duration(seconds: 60),
  //       codeAutoRetrievalTimeout: (verificationId) {},
  //     );
  //   } catch (e) {}
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(AppImages.bgimage),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(height * 0.010),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
                ),
              ),
              Gap(height * 0.25),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                child: Text(
                  localization.enterphone,
                  style: isArabic
                      ? AppStyle.arabictext.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        )
                      : AppStyle.btext,
                ),
              ),

              Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntlPhoneField(
                    initialCountryCode: "SA",
                    showDropdownIcon: false,
                    decoration: InputDecoration(
                      hintText: localization.enterphone,
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColours.blues),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onChanged: (phone) {
                      phoneController.text = phone.completeNumber; // +92 format
                    },
                    validator: (phone) {
                      if (phone == null || phone.number.isEmpty) {
                        return localization.enterphone;
                      }
                      return null;
                    },
                  ),
                ),
              ),

              // Form(
              //   key: _formkey,
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: IntlPhoneField(
              //       showDropdownIcon: false,
              //       initialCountryCode: "SA",

              //       decoration: InputDecoration(
              //         hint: Text(
              //           localization.enterphone,
              //           style: isArabic
              //               ? AppStyle.arabictext.copyWith(
              //                   fontSize: 18,
              //                   color: Colors.black54,
              //                 )
              //               : TextStyle(fontSize: 16, color: Colors.black54),
              //         ),

              //         filled: true,
              //         fillColor: Colors.grey.shade200,
              //         border: OutlineInputBorder(
              //           borderSide: BorderSide(color: Colors.grey.shade200),
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //         errorBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color: Colors.red),
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //         enabledBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color: Colors.grey.shade200),
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderSide: BorderSide(color: AppColours.blues),
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
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
                      isloading.value = true;
                      await signinwithphone();
                      isloading.value = false;

                      phoneController.clear();
                    }
                  },
                  child: Obx(
                    () => isloading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            localization.buttonnext,
                            style: isArabic
                                ? AppStyle.arabictext.copyWith(
                                    fontSize: 22,
                                    color: Colors.white,
                                  )
                                : AppStyle.btext.copyWith(color: Colors.white),
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
    );
  }
}

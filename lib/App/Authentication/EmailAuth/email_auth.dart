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

class EmailAuth extends StatefulWidget {
  const EmailAuth({super.key});

  @override
  State<EmailAuth> createState() => _EmailAuthState();
}

class _EmailAuthState extends State<EmailAuth> {
  RxBool isloading = false.obs;
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isEmailEmpty = false.obs;
  bool isArabic = Get.locale?.languageCode == "ar";

  //here is function to signinwith email
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<void> createaccountwithemail() async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: "temprory123",
          );

      User? user = userCredential.user;
      if (user != null) {
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }
        Get.toNamed(
          AppRoutes.verifyemail,
          arguments: {
            "userId": user.uid,
            "userName": user.displayName,
            "email": user.email,
          },
        );
        Get.snackbar(
          "",
          "",
          titleText: Text(
            isArabic
                ? "تم إرسال تأكيد البريد الإلكتروني"
                : "Email Verification Sent",
            style: isArabic
                ? AppStyle.arabictext.copyWith(color: Colors.white)
                : TextStyle(color: Colors.white),
          ),
          messageText: Text(
            isArabic
                ? "لقد أرسلنا بريدًا إلكترونيًا للتأكيد إلى صندوق بريدك الوارد. يرجى مراجعته وتأكيد حسابك."
                : "We've sent a verification email to your inbox. Please check it and verify your account.",
            style: isArabic
                ? AppStyle.arabictext.copyWith(color: Colors.white)
                : TextStyle(color: Colors.white),
          ),

          backgroundColor: Colors.black,
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar(
          colorText: Colors.white,
          backgroundColor: Colors.black,
          titleText: Text(
            isArabic ? "موجود بالفعل" : "Already exists",
            style: isArabic
                ? AppStyle.arabictext.copyWith(color: Colors.white)
                : TextStyle(color: Colors.white),
          ),
          messageText: Text(
            isArabic
                ? "الحساب موجود بالفعل لهذا البريد الإلكتروني."
                : "he account already exists for that email.",
            style: isArabic
                ? AppStyle.arabictext.copyWith(color: Colors.white)
                : TextStyle(color: Colors.white),
          ),
          "",
          "",
        );
      }
    }
  }

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
                  localization.createaccountwithemail,
                  style: isArabic
                      ? AppStyle.arabictext.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        )
                      : AppStyle.btext,
                ),
              ),
              Gap(8),
              Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Obx(
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
                              icon: Icon(Icons.close, color: Colors.black54),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.loginemail);
                },
                child: Text(
                  localization.alreadyaccount,
                  style: isArabic
                      ? AppStyle.arabictext.copyWith(
                          fontSize: 18,
                          color: Colors.black,
                        )
                      : AppStyle.btext.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                ),
              ),
              Gap(height * 0.020),
              Center(
                child: MyElevatedButton(
                  width: width,
                  btext: Obx(
                    () => isloading.value
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text(
                            localization.buttonnext,
                            style: isArabic
                                ? AppStyle.arabictext.copyWith(
                                    fontSize: 25,
                                    color: Colors.white,
                                  )
                                : AppStyle.btext.copyWith(color: Colors.white),
                          ),
                  ),
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      isloading.value = true;
                      await createaccountwithemail();
                      isloading.value = false;
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

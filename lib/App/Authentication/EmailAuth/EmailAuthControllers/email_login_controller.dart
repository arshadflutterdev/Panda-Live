import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';

class EmailLoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool isArabic = Get.locale?.languageCode == "ar";
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
      } else if (e.code == "invalid-credential") {
        Get.snackbar(
          titleText: Text(
            isArabic ? "فشل تسجيل الدخول" : "Login Failed",
            style: isArabic
                ? AppStyle.arabictext.copyWith(color: Colors.white)
                : TextStyle(color: Colors.white),
          ),
          messageText: Text(
            isArabic
                ? "البريد الإلكتروني أو كلمة المرور غير صحيحة أو منتهية الصلاحية."
                : "Email or password is incorrect or expired.",
            style: isArabic
                ? AppStyle.arabictext.copyWith(color: Colors.white)
                : TextStyle(color: Colors.white),
          ),

          "",
          "",
          backgroundColor: Colors.red,
        );
      } else if (e.code == "too-many-requests") {
        Get.snackbar(
          titleText: Text(
            isArabic ? "محاولات كثيرة جداً" : "Too Many Attempts",
            style: isArabic
                ? AppStyle.arabictext.copyWith(color: Colors.white)
                : TextStyle(color: Colors.white),
          ),
          messageText: Text(
            isArabic
                ? "لقد حاولت مرات كثيرة جداً. حاول مرة أخرى لاحقاً."
                : "You have tried too many times. Try again later.",
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
}

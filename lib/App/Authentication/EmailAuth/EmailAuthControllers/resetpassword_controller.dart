import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:pandlive/App/Routes/app_routes.dart';

class ResetpasswordController extends GetxController {
  TextEditingController emailController = TextEditingController();
  bool isArabic = Get.locale?.languageCode == "ar";
  Future<void> resetPassword() async {
    final auth = FirebaseAuth.instance;
    final email = emailController.text.trim();
    try {
      auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        isArabic ? "تم الإرسال" : "Email Sent",
        isArabic
            ? "تم إرسال رابط إعادة تعيين كلمة المرور"
            : "Password reset link sent to your email",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );

      // ✅ Auto back after 2 seconds
      Future.delayed(const Duration(seconds: 5), () {
        Get.offAllNamed(
          AppRoutes.loginemail,
          arguments: "password_reset_success",
        );
      });
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        isArabic ? "حدث خطأ" : "Error",
        isArabic
            ? "تعذر إرسال رابط إعادة التعيين"
            : "Unable to send reset link",
        colorText: Colors.red,
        backgroundColor: Colors.blue,
      );
      print(e.toString());
    }
  }
}

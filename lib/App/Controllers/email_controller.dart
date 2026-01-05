import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class EmailController extends GetxController {
  final emailController = TextEditingController();
  var isEmailNotEmpty = false.obs;
  void onEmailChanges(String value) {
    isEmailNotEmpty.value = false;
  }

  void ClearEmail() {
    emailController.clear();
    isEmailNotEmpty.value = false;
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}

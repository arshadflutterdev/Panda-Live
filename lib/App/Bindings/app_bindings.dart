import 'package:get/get.dart';
import 'package:pandlive/App/Authentication/EmailAuth/EmailAuthControllers/emailauth_controller.dart';
import 'package:pandlive/App/Authentication/GoogleAuth/google_auth_controller.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoogleAuthController>(() => GoogleAuthController());
    Get.lazyPut<EmailauthController>(() => EmailauthController());
  }
}

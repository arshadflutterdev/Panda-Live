import 'package:get/get.dart';
import 'package:pandlive/App/AppUi/Profile/nextScreens/CreateProfileScreen/profile_store_controller.dart';
import 'package:pandlive/App/Authentication/EmailAuth/EmailAuthControllers/email_login_controller.dart';
import 'package:pandlive/App/Authentication/EmailAuth/EmailAuthControllers/emailauth_controller.dart';
import 'package:pandlive/App/Authentication/EmailAuth/EmailAuthControllers/resetpassword_controller.dart';
import 'package:pandlive/App/Authentication/GoogleAuth/google_auth_controller.dart';

class AuthBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GoogleAuthController>(() => GoogleAuthController());
    Get.lazyPut<EmailauthController>(() => EmailauthController());
    Get.lazyPut<EmailLoginController>(() => EmailLoginController());
    Get.lazyPut<ResetpasswordController>(() => ResetpasswordController());
    Get.lazyPut<ProfileStoreController>(() => ProfileStoreController());
  }
}

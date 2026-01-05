import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:pandlive/App/AppUi/Profile/create_profile.dart';
import 'package:pandlive/App/AppUi/splash_screen.dart';
import 'package:pandlive/App/AppUi/terms_services.dart';
import 'package:pandlive/App/Authentication/PhoneAuth/verify_number.dart';
import 'package:pandlive/App/Authentication/auth_options.dart';
import 'package:pandlive/App/Authentication/EmailAuth/email_auth.dart';
import 'package:pandlive/App/Authentication/PhoneAuth/phone_auth.dart';
import 'package:pandlive/App/Authentication/UserIdAuth/userid_auth.dart';

class AppRoutes {
  static const splash = "/";
  static const authoptions = "/AuthOptions";
  static const terms = "/TermsOfServiceScreen";
  static const emailauth = "/EmailAuth";
  static const userauth = "/UseridAuth";
  static const phoneauth = "/PhoneAuth";
  static const verifynumber = "/VerifyNumber";
  static const createprofile = "/CreateProfile";

  static final routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: authoptions, page: () => AuthOptions()),
    GetPage(name: terms, page: () => TermsOfServiceScreen()),
    GetPage(name: emailauth, page: () => EmailAuth()),
    GetPage(name: userauth, page: () => UseridAuth()),
    GetPage(name: phoneauth, page: () => PhoneAuth()),
    GetPage(name: verifynumber, page: () => VerifyNumber()),
    GetPage(name: createprofile, page: () => CreateProfile()),
  ];
}

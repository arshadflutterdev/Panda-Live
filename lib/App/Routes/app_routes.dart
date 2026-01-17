import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:pandlive/App/AppUi/BottomNavBar/bottomnavbar.dart';
import 'package:pandlive/App/AppUi/BottomScreens/updates_screen.dart';
import 'package:pandlive/App/AppUi/BottomScreens/homescreen.dart';
import 'package:pandlive/App/AppUi/BottomScreens/profile_screen.dart';
import 'package:pandlive/App/AppUi/LiveStreaming/GoLiveStream/golive_screen.dart';
import 'package:pandlive/App/AppUi/LiveStreaming/WatchStreaming/watchstreaming_class.dart';
import 'package:pandlive/App/AppUi/Profile/nextScreens/CreateProfileScreen/create_profile.dart';
import 'package:pandlive/App/AppUi/Profile/nextScreens/follow_us.dart';
import 'package:pandlive/App/AppUi/Profile/nextScreens/help_screen.dart';
import 'package:pandlive/App/AppUi/Profile/nextScreens/logout_screen.dart';
import 'package:pandlive/App/AppUi/Profile/nextScreens/my_level_screen.dart';
import 'package:pandlive/App/AppUi/change_language.dart';
import 'package:pandlive/App/AppUi/splash_screen.dart';
import 'package:pandlive/App/AppUi/terms_services.dart';
import 'package:pandlive/App/Authentication/EmailAuth/email_login.dart';
import 'package:pandlive/App/Authentication/EmailAuth/reset_password.dart';
import 'package:pandlive/App/Authentication/EmailAuth/verify_email.dart';
import 'package:pandlive/App/Authentication/PhoneAuth/phone_login.dart';
import 'package:pandlive/App/Authentication/PhoneAuth/resetpassword_phone.dart';
import 'package:pandlive/App/Authentication/PhoneAuth/verify_number.dart';
import 'package:pandlive/App/Authentication/auth_options.dart';
import 'package:pandlive/App/Authentication/EmailAuth/email_auth.dart';
import 'package:pandlive/App/Authentication/PhoneAuth/phone_auth.dart';
import 'package:pandlive/App/Authentication/UserIdAuth/userid_auth.dart';
import 'package:pandlive/App/Bindings/app_bindings.dart';

class AppRoutes {
  static const splash = "/";
  static const authoptions = "/AuthOptions";
  static const terms = "/TermsOfServiceScreen";
  static const emailauth = "/EmailAuth";
  static const userauth = "/UseridAuth";
  static const phoneauth = "/PhoneAuth";
  static const verifynumber = "/VerifyNumber";
  static const createprofile = "/CreateProfile";
  static const verifyemail = "/VerifyEmail";
  static const loginemail = "/EmailLogin";
  static const resetpassword = "/ResetPassword";
  static const phonelogin = "/PhoneLogin";
  static const phonereset = "/PhoneResetPassword";
  static const bottomnav = "/Bottomnavbar";
  static const language = "/ChangeLanguage";
  static const home = "/Homescreen";
  static const updates = "/UpdatesScreen";
  static const profile = "/ProfileScreen";
  static const watchstream = "/WatchstreamingClass";
  static const help = "/HelpScreen";
  static const followus = "/FollowUs";
  static const level = "/MyLevelScreen";
  static const logout = "/LogoutScreen";
  static const golive = "/GoliveScreen";

  static final routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(
      binding: AuthBindings(),
      name: authoptions,
      page: () => AuthOptions(),
    ),
    GetPage(name: terms, page: () => TermsOfServiceScreen()),
    GetPage(name: emailauth, page: () => EmailAuth()),
    GetPage(name: userauth, page: () => UseridAuth()),
    GetPage(name: phoneauth, page: () => PhoneAuth()),
    GetPage(name: verifynumber, page: () => PhoneAuth()),
    GetPage(name: createprofile, page: () => CreateProfile()),
    GetPage(name: verifyemail, page: () => VerifyEmail()),
    GetPage(
      binding: AuthBindings(),
      name: loginemail,
      page: () => EmailLogin(),
    ),
    GetPage(
      binding: AuthBindings(),
      name: resetpassword,
      page: () => ResetPassword(),
    ),
    GetPage(name: phonelogin, page: () => PhoneLogin()),
    GetPage(name: phonereset, page: () => PhoneResetPassword()),
    GetPage(name: bottomnav, page: () => Bottomnavbar()),
    GetPage(name: language, page: () => ChangeLanguage()),
    //screen from bottom to next
    GetPage(name: home, page: () => Homescreen()),
    GetPage(name: updates, page: () => UpdatesScreen()),
    GetPage(name: profile, page: () => ProfileScreen()),
    GetPage(name: watchstream, page: () => WatchstreamingClass()),
    GetPage(name: golive, page: () => GoliveScreen()),
    //in profile screen navigates
    GetPage(name: help, page: () => HelpScreen()),
    GetPage(name: level, page: () => MyLevelScreen()),
    GetPage(name: followus, page: () => FollowUs()),
    GetPage(name: logout, page: () => LogoutScreen()),
  ];
}

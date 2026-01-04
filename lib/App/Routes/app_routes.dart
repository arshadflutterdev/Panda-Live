import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:pandlive/App/AppUi/splash_screen.dart';
import 'package:pandlive/App/AppUi/terms_services.dart';
import 'package:pandlive/App/Authentication/auth_options.dart';

class AppRoutes {
  static const splash = "/";
  static const authoptions = "/AuthOptions";
  // static const terms = "TermsOfServiceScreen";

  static final routes = [
    GetPage(name: splash, page: () => SplashScreen()),
    GetPage(name: authoptions, page: () => AuthOptions()),
    // GetPage(name: terms, page: () => TermsOfServiceScreen()),
  ];
}

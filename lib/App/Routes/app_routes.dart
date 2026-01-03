import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:pandlive/App/AppUi/splash_screen.dart';

class AppRoutes {
  static const splash = "/";

  static final routes = [GetPage(name: splash, page: () => SplashScreen())];
}

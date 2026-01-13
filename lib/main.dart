// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

// import 'package:get/get.dart';
// import 'package:pandlive/App/Routes/app_routes.dart';
// import 'package:pandlive/Utils/Constant/app_style.dart';
// import 'package:pandlive/l10n/app_localizations.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       locale: Locale("en"),
//       fallbackLocale: Locale("ar"),
//       debugShowCheckedModeBanner: false,
//       supportedLocales: AppLocalizations.supportedLocales,
//       localizationsDelegates: [
//         AppLocalizations.delegate, // ✅ ADD THIS
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],

//       initialRoute: AppRoutes.splash,
//       getPages: AppRoutes.routes,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Load the saved language from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  String? savedLang = prefs.getString("language_code");

  // 2. Determine initial locale (Defaults to English if null)
  Locale initialLocale = Locale(savedLang ?? "en");

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp(initialLocale: initialLocale));
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Use the locale we loaded from SharedPreferences
      locale: initialLocale,

      // Fallback should usually be English in case a translation is missing
      fallbackLocale: const Locale("en"),

      debugShowCheckedModeBanner: false,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
      title: 'PandLive',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/firebase_options.dart';
import 'package:pandlive/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      home: JoinadnWatch(),
    );
  }
}

//join live and watch stream
class JoinadnWatch extends StatefulWidget {
  const JoinadnWatch({super.key});

  @override
  State<JoinadnWatch> createState() => _JoinadnWatchState();
}

class _JoinadnWatchState extends State<JoinadnWatch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.golive);
              },
              child: Text("Start Live"),
            ),
            Gap(20),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.watchstream);
              },
              child: Text("Watch Live"),
            ),
          ],
        ),
      ),
    );
  }
}

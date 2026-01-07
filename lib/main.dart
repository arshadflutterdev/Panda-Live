import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  final flocalization = FlutterLocalization.instance;
  await flocalization.ensureInitialized();
  flocalization.init(
    mapLocales: [
      MapLocale('en', {'title': 'Welcome'}),
      MapLocale('ur', {'title': 'خوش آمدید'}),
      MapLocale('ar', {'title': 'مرحبا'}),
    ],
    initLanguageCode: 'en',
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FlutterLocalization flocalization = FlutterLocalization.instance;
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      supportedLocales: flocalization.supportedLocales,
      localizationsDelegates: flocalization.localizationsDelegates,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.routes,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
    );
  }
}

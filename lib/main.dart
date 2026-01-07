// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

// import 'package:get/get.dart';
// import 'package:pandlive/App/Routes/app_routes.dart';
// import 'package:pandlive/App/Services/Localization/app_localization.dart';
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
//       debugShowCheckedModeBanner: false,
//       localizationsDelegates: [
//         AppLocalizations.delegate, // ✅ ADD THIS
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: [Locale("en"), Locale("ar")],

//       // initialRoute: AppRoutes.splash,
//       // getPages: AppRoutes.routes,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//       ),
//       home: ChangeLanguage(),
//     );
//   }
// }

// class ChangeLanguage extends StatefulWidget {
//   const ChangeLanguage({super.key});

//   @override
//   State<ChangeLanguage> createState() => _ChangeLanguageState();
// }

// class _ChangeLanguageState extends State<ChangeLanguage> {
//   @override
//   Widget build(BuildContext context) {
//     final localizations = AppLocalizations.of(context)!;

//     return Scaffold(
//       appBar: AppBar(title: Text(localizations.helloWorld)),
//       body: Column(
//         children: [
//           Center(
//             child: TextButton(
//               onPressed: () {
//                 changeLocal(context, Locale("ar"));
//               },
//               child: Text(localizations.helloWorld, style: AppStyle.logo),
//             ),
//           ),
//           Center(
//             child: TextButton(
//               onPressed: () {
//                 changeLocal(context, Locale("en"));
//               },
//               child: Text(localizations.helloWorld, style: AppStyle.logo),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// void changeLocal(BuildContext context, Locale newLocale) {
//   Navigator.of(context).pushReplacement(
//     MaterialPageRoute(
//       builder: (context) => Localizations.override(
//         locale: newLocale,
//         context: context,
//         child: ChangeLanguage(),
//       ),
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

// ✅ IMPORTANT: correct generated localization import

import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      // ✅ Default & fallback locale
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),

      // ✅ Localization delegates
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      // ✅ Supported locales from gen-l10n
      supportedLocales: AppLocalizations.supportedLocales,

      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),

      home: const ChangeLanguage(),
    );
  }
}

class ChangeLanguage extends StatelessWidget {
  const ChangeLanguage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.helloWorld)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(localizations.helloWorld, style: AppStyle.logo),

            const SizedBox(height: 20),

            // ✅ English button
            ElevatedButton(
              onPressed: () {
                Get.updateLocale(const Locale('en'));
              },
              child: const Text('English'),
            ),

            const SizedBox(height: 10),

            // ✅ Arabic button
            ElevatedButton(
              onPressed: () {
                Get.updateLocale(const Locale('ar'));
              },
              child: const Text('Arabic'),
            ),
          ],
        ),
      ),
    );
  }
}

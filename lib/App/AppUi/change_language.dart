// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pandlive/App/Routes/app_routes.dart';
// import 'package:pandlive/App/Services/Localization/localization_services.dart';
// import 'package:pandlive/Utils/Constant/app_colours.dart';
// import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
// import 'package:pandlive/Utils/Constant/app_images.dart';
// import 'package:pandlive/Utils/Constant/app_style.dart';
// import 'package:pandlive/l10n/app_localizations.dart';

// class ChangeLanguage extends StatefulWidget {
//   const ChangeLanguage({super.key});

//   @override
//   State<ChangeLanguage> createState() => _ChangeLanguageState();
// }

// class _ChangeLanguageState extends State<ChangeLanguage> {
//   bool isarabic = Get.locale?.languageCode == "ar";
//   RxInt selectedlanguage = 1.obs;
//   @override
//   Widget build(BuildContext context) {
//     double height = AppHeightwidth.screenHeight(context);
//     double width = AppHeightwidth.screenWidth(context);
//     final localization = AppLocalizations.of(context)!;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Image(fit: BoxFit.cover, image: AssetImage(AppImages.halfbg)),
//           Gap(height * 0.15),
//           Text(
//             localization.changeAppLanguage,
//             style: isarabic
//                 ? AppStyle.arabictext.copyWith(fontSize: 35)
//                 : AppStyle.logo.copyWith(fontSize: 30),
//           ),
//           Gap(height * 0.040),
//           Directionality(
//             textDirection: TextDirection.ltr,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,

//                 children: [
//                   Obx(
//                     () => ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: Size(width * 0.40, 60),
//                         backgroundColor: selectedlanguage.value == 1
//                             ? AppColours.blues
//                             : Colors.black,
//                         shape: ContinuousRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),

//                       onPressed: () {
//                         selectedlanguage.value = 1;
//                         Get.updateLocale(Locale("en"));

//                         Get.snackbar(
//                           backgroundColor: Colors.black,
//                           colorText: Colors.white,
//                           "English",
//                           "Your selected language is english",
//                         );
//                       },
//                       child: Text(
//                         "English",
//                         style: AppStyle.btext.copyWith(
//                           color: Colors.white,
//                           fontSize: 25,
//                         ),
//                       ),
//                     ),
//                   ),

//                   Obx(
//                     () => ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         minimumSize: Size(width * 0.40, 60),
//                         backgroundColor: selectedlanguage.value == 2
//                             ? AppColours.blues
//                             : Colors.black,
//                         shape: ContinuousRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),

//                       onPressed: () {
//                         Get.updateLocale(Locale("ar"));
//                         selectedlanguage.value = 2;

//                         Get.snackbar(
//                           "",
//                           "",
//                           colorText: Colors.white,
//                           backgroundColor: Colors.black,

//                           titleText: Align(
//                             alignment: Alignment.topRight,
//                             child: Text(
//                               "عربي",

//                               style: AppStyle.arabictext.copyWith(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),

//                           messageText: Align(
//                             alignment: Alignment.topRight,
//                             child: Text(
//                               "اللغة التي اخترتها هي العربية",
//                               style: AppStyle.arabictext.copyWith(
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                       child: Text(
//                         "عربي",
//                         style: AppStyle.btext.copyWith(
//                           color: Colors.white,
//                           fontSize: 25,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Gap(height * .050),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 localization.readAndAgree,
//                 style: isarabic
//                     ? AppStyle.arabictext
//                     : TextStyle(color: Colors.black),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Get.toNamed(AppRoutes.terms);
//                 },
//                 child: Text(
//                   localization.termsOfService,
//                   style: isarabic
//                       ? AppStyle.arabictext.copyWith(color: Colors.black)
//                       : TextStyle(color: Colors.blue),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/Utils/Constant/app_colours.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_images.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({super.key});

  @override
  State<ChangeLanguage> createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  // Save language selection to SharedPreferences
  Future<void> savelang(String langcode) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString("language_code", langcode);
  }

  // Getter to check current language for conditional styling
  bool get isarabic => Get.locale?.languageCode == "ar";

  // Observable for button selection state
  late RxInt selectedlanguage;

  @override
  void initState() {
    super.initState();
    // Initialize based on current locale: 2 for Arabic, 1 for English (default)
    selectedlanguage = (Get.locale?.languageCode == "ar" ? 2 : 1).obs;
  }

  @override
  Widget build(BuildContext context) {
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    final localization = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Image(fit: BoxFit.cover, image: AssetImage(AppImages.halfbg)),
          Gap(height * 0.15),
          Text(
            localization.changeAppLanguage,
            style: isarabic
                ? AppStyle.arabictext.copyWith(fontSize: 35)
                : AppStyle.logo.copyWith(fontSize: 30),
          ),
          Gap(height * 0.040),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(width * 0.40, 60),
                        backgroundColor: selectedlanguage.value == 1
                            ? AppColours.blues
                            : Colors.black,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        selectedlanguage.value = 1;
                        Get.updateLocale(const Locale("en"));
                        await savelang("en"); // Save choice
                        setState(() {}); // Update non-reactive text styles

                        Get.snackbar(
                          backgroundColor: Colors.black,
                          colorText: Colors.white,
                          "English",
                          "Your selected language is English",
                        );
                      },
                      child: Text(
                        "English",
                        style: AppStyle.btext.copyWith(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                  Obx(
                    () => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(width * 0.40, 60),
                        backgroundColor: selectedlanguage.value == 2
                            ? AppColours.blues
                            : Colors.black,
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        selectedlanguage.value = 2;
                        Get.updateLocale(const Locale("ar"));
                        await savelang("ar"); // Save choice
                        setState(() {}); // Update non-reactive text styles

                        Get.snackbar(
                          "",
                          "",
                          colorText: Colors.white,
                          backgroundColor: Colors.black,
                          titleText: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "عربي",
                              style: AppStyle.arabictext.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          messageText: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "اللغة التي اخترتها هي العربية",
                              style: AppStyle.arabictext.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "عربي",
                        style: AppStyle.btext.copyWith(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap(height * .050),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                localization.readAndAgree,
                style: isarabic
                    ? AppStyle.arabictext
                    : const TextStyle(color: Colors.black),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(AppRoutes.terms);
                },
                child: Text(
                  localization.termsOfService,
                  style: isarabic
                      ? AppStyle.arabictext.copyWith(color: Colors.black)
                      : const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

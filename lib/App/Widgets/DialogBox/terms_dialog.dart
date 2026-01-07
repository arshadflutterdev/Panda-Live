import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pandlive/App/Routes/app_routes.dart';
import 'package:pandlive/Utils/Constant/app_heightwidth.dart';
import 'package:pandlive/Utils/Constant/app_style.dart';
import 'package:pandlive/l10n/app_localizations.dart';

class TermsDialog extends StatelessWidget {
  final VoidCallback onAccept;
  const TermsDialog({super.key, required this.onAccept});

  @override
  Widget build(BuildContext context) {
    bool isArabic = Get.locale?.languageCode == "ar";
    final localization = AppLocalizations.of(context)!;
    double height = AppHeightwidth.screenHeight(context);
    double width = AppHeightwidth.screenWidth(context);
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: Container(
        height: isArabic ? height * 0.25 : height * 0.21,
        width: width * 0.10,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Gap(5),
            Text(
              localization.terms,
              style: isArabic
                  ? AppStyle.arabictext.copyWith(fontSize: 24)
                  : AppStyle.tagline,
            ),
            Gap(5),

            Text(
              localization.agreement,
              style: isArabic ? AppStyle.arabictext : TextStyle(),
            ),
            Gap(3),
            GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.terms);
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: localization.pterms,
                  style: isArabic
                      ? AppStyle.arabictext.copyWith(
                          fontSize: 20,
                          color: Colors.blue,
                        )
                      : TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 18,
                          decoration: TextDecoration.underline,
                        ),
                  children: [
                    TextSpan(
                      text: "\n${localization.service}",
                      style: isArabic ? AppStyle.arabictext : TextStyle(),
                    ),
                    TextSpan(
                      text: localization.and,
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: localization.policy,
                      style: isArabic ? AppStyle.arabictext : TextStyle(),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,

              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: FittedBox(
                    child: Text(
                      localization.bcancel,
                      style: isArabic
                          ? AppStyle.arabictext.copyWith(
                              color: Colors.grey,
                              fontSize: 20,
                            )
                          : AppStyle.btext.copyWith(color: Colors.grey),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onAccept,
                  child: FittedBox(
                    child: Text(
                      localization.baccept,
                      style: isArabic
                          ? AppStyle.arabictext.copyWith(
                              color: Colors.grey,
                              fontSize: 20,
                            )
                          : AppStyle.btext.copyWith(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pandlive/l10n/app_localizations.dart';

class LocalizationService {
  /// Change locale using GetX
  static void changeLocale(BuildContext context, Locale newLocale) {
    Get.updateLocale(newLocale);
  }

  /// Helper to get localized strings
  static AppLocalizations localizations(BuildContext context) {
    return AppLocalizations.of(context)!;
  }
}

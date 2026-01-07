// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get changeAppLanguage => 'تغيير لغة التطبيق';

  @override
  String get english => 'إنجليزي';

  @override
  String get arabic => 'عربي';

  @override
  String get termsOfService => 'شروط خدمة PandaLive';

  @override
  String get readAndAgree => 'لقد قرأت ووافقت على';

  @override
  String get languageSelectedEnglish => 'اللغة التي اخترتها هي الإنجليزية';

  @override
  String get languageSelectedArabic => 'اللغة التي اخترتها هي العربية';
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @changeAppLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change App Language'**
  String get changeAppLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'PandaLive Terms of Services'**
  String get termsOfService;

  /// No description provided for @readAndAgree.
  ///
  /// In en, this message translates to:
  /// **'I have read and agreed the'**
  String get readAndAgree;

  /// No description provided for @languageSelectedEnglish.
  ///
  /// In en, this message translates to:
  /// **'Your selected language is English'**
  String get languageSelectedEnglish;

  /// No description provided for @languageSelectedArabic.
  ///
  /// In en, this message translates to:
  /// **'اللغة التي اخترتها هي العربية'**
  String get languageSelectedArabic;

  /// No description provided for @google.
  ///
  /// In en, this message translates to:
  /// **'Login with Google'**
  String get google;

  /// No description provided for @facebook.
  ///
  /// In en, this message translates to:
  /// **'Login with Facebook'**
  String get facebook;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms of service'**
  String get terms;

  /// No description provided for @agreement.
  ///
  /// In en, this message translates to:
  /// **'user_agreement_contant'**
  String get agreement;

  /// No description provided for @pterms.
  ///
  /// In en, this message translates to:
  /// **'Panda Live Terms Of'**
  String get pterms;

  /// No description provided for @service.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get service;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get and;

  /// No description provided for @policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get policy;

  /// No description provided for @bcancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get bcancel;

  /// No description provided for @baccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get baccept;

  /// No description provided for @loginwithemail.
  ///
  /// In en, this message translates to:
  /// **'Login With Your Email'**
  String get loginwithemail;

  /// No description provided for @enteremail.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Your Email'**
  String get enteremail;

  /// No description provided for @validemail.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Valid Email'**
  String get validemail;

  /// No description provided for @buttonnext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get buttonnext;

  /// No description provided for @verifyemail.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyemail;

  /// No description provided for @vcodesended.
  ///
  /// In en, this message translates to:
  /// **'verification code send to arshad***gmail.com'**
  String get vcodesended;

  /// No description provided for @enter6digitcode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digits code send to your email'**
  String get enter6digitcode;

  /// No description provided for @hint6ditis.
  ///
  /// In en, this message translates to:
  /// **'Type 6 digits code'**
  String get hint6ditis;

  /// No description provided for @resms.
  ///
  /// In en, this message translates to:
  /// **'Resend SMS'**
  String get resms;

  /// No description provided for @tryanother.
  ///
  /// In en, this message translates to:
  /// **'Try another method?'**
  String get tryanother;

  /// No description provided for @createpassword.
  ///
  /// In en, this message translates to:
  /// **'Create Password'**
  String get createpassword;

  /// No description provided for @setpassword.
  ///
  /// In en, this message translates to:
  /// **'Set 6-8 digits code with letters&numbers'**
  String get setpassword;

  /// No description provided for @alreadyaccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an Account?'**
  String get alreadyaccount;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @isyourcode.
  ///
  /// In en, this message translates to:
  /// **'258012 is your code'**
  String get isyourcode;

  /// No description provided for @codeincorrect.
  ///
  /// In en, this message translates to:
  /// **'Code Incorrect'**
  String get codeincorrect;

  /// No description provided for @lettersend.
  ///
  /// In en, this message translates to:
  /// **'letterResend SMS'**
  String get lettersend;

  /// No description provided for @smssended.
  ///
  /// In en, this message translates to:
  /// **'SMS resend successfully'**
  String get smssended;

  /// No description provided for @code8digits.
  ///
  /// In en, this message translates to:
  /// **'Password must be 8 digits'**
  String get code8digits;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

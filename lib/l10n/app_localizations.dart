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

  /// No description provided for @completedata.
  ///
  /// In en, this message translates to:
  /// **'Complete personal data'**
  String get completedata;

  /// No description provided for @letknow.
  ///
  /// In en, this message translates to:
  /// **'Let everyone know you better'**
  String get letknow;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @nam.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nam;

  /// No description provided for @entername.
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get entername;

  /// No description provided for @shortnam.
  ///
  /// In en, this message translates to:
  /// **'Name too short'**
  String get shortnam;

  /// No description provided for @dob.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dob;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'DD-MM-YYYY'**
  String get date;

  /// No description provided for @adddob.
  ///
  /// In en, this message translates to:
  /// **'Add your date of birth'**
  String get adddob;

  /// No description provided for @contry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get contry;

  /// No description provided for @noalterd.
  ///
  /// In en, this message translates to:
  /// **'not to be altered once set'**
  String get noalterd;

  /// No description provided for @selectcontry.
  ///
  /// In en, this message translates to:
  /// **'Please select your country'**
  String get selectcontry;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @man.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get man;

  /// No description provided for @fmale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get fmale;

  /// No description provided for @sbmet.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get sbmet;

  /// No description provided for @selectgender.
  ///
  /// In en, this message translates to:
  /// **'Please select your gender'**
  String get selectgender;

  /// No description provided for @mubark.
  ///
  /// In en, this message translates to:
  /// **'Congratulations'**
  String get mubark;

  /// No description provided for @profiledone.
  ///
  /// In en, this message translates to:
  /// **'Your profile is done'**
  String get profiledone;

  /// No description provided for @enter8pass.
  ///
  /// In en, this message translates to:
  /// **'Please Enter 6-8 Digits Password'**
  String get enter8pass;

  /// No description provided for @enteryourpass.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Password'**
  String get enteryourpass;

  /// No description provided for @forgetpass.
  ///
  /// In en, this message translates to:
  /// **'Forget Password?'**
  String get forgetpass;

  /// No description provided for @resetpass.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetpass;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @passresetsuccess.
  ///
  /// In en, this message translates to:
  /// **'Your Password reset successfully'**
  String get passresetsuccess;

  /// No description provided for @loginwithid.
  ///
  /// In en, this message translates to:
  /// **'Login With Your_Id'**
  String get loginwithid;

  /// No description provided for @adduserid.
  ///
  /// In en, this message translates to:
  /// **'Please Add Your userId'**
  String get adduserid;

  /// No description provided for @uid6digits.
  ///
  /// In en, this message translates to:
  /// **'Please Enter Your 6 Digits userId'**
  String get uid6digits;

  /// No description provided for @hintid.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Id'**
  String get hintid;

  /// No description provided for @loginwithphone.
  ///
  /// In en, this message translates to:
  /// **'Login With Phone number'**
  String get loginwithphone;

  /// No description provided for @phonecodesend.
  ///
  /// In en, this message translates to:
  /// **'verification code send to +966 ******34'**
  String get phonecodesend;

  /// No description provided for @enterphone.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Phone Number'**
  String get enterphone;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @bnew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get bnew;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @visitors.
  ///
  /// In en, this message translates to:
  /// **'Visitors'**
  String get visitors;

  /// No description provided for @coins.
  ///
  /// In en, this message translates to:
  /// **'Coins'**
  String get coins;

  /// No description provided for @points.
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// No description provided for @invitefriend.
  ///
  /// In en, this message translates to:
  /// **'Invite a friend'**
  String get invitefriend;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @followus.
  ///
  /// In en, this message translates to:
  /// **'Follow Us'**
  String get followus;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @topic.
  ///
  /// In en, this message translates to:
  /// **'Topic'**
  String get topic;

  /// No description provided for @issuedetail.
  ///
  /// In en, this message translates to:
  /// **'Issue Details'**
  String get issuedetail;

  /// No description provided for @decribissue.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue in details...'**
  String get decribissue;

  /// No description provided for @uploadimage.
  ///
  /// In en, this message translates to:
  /// **'Upload Images'**
  String get uploadimage;

  /// No description provided for @submitissued.
  ///
  /// In en, this message translates to:
  /// **'Submit Issue'**
  String get submitissued;

  /// No description provided for @helpsupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpsupport;
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

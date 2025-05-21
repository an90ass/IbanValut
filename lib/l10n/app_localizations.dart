import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

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
    Locale('en'),
    Locale('tr')
  ];

  /// Simple greeting
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get hello;

  /// No description provided for @loginPage.
  ///
  /// In en, this message translates to:
  /// **'Login Screen'**
  String get loginPage;

  /// No description provided for @settingsScreen.
  ///
  /// In en, this message translates to:
  /// **'Settings Screen'**
  String get settingsScreen;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @homePage.
  ///
  /// In en, this message translates to:
  /// **'Home Page'**
  String get homePage;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome to IABN Vault, your secure and reliable solution for managing your IBANs.'**
  String get welcomeMessage;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get search;

  /// No description provided for @myIbans.
  ///
  /// In en, this message translates to:
  /// **'My IBANs'**
  String get myIbans;

  /// No description provided for @friendsIbans.
  ///
  /// In en, this message translates to:
  /// **'Friends IBANs'**
  String get friendsIbans;

  /// No description provided for @noIbansFound.
  ///
  /// In en, this message translates to:
  /// **'No IBANs found.'**
  String get noIbansFound;

  /// No description provided for @editIban.
  ///
  /// In en, this message translates to:
  /// **'Edit IBAN'**
  String get editIban;

  /// No description provided for @editFriendIban.
  ///
  /// In en, this message translates to:
  /// **'Edit Friends IBAN'**
  String get editFriendIban;

  /// No description provided for @friendNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Friend\'s Name'**
  String get friendNameLabel;

  /// No description provided for @bankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankName;

  /// No description provided for @ibanNumber.
  ///
  /// In en, this message translates to:
  /// **'IBAN Number'**
  String get ibanNumber;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @pleaseSelectBank.
  ///
  /// In en, this message translates to:
  /// **'Please select a bank'**
  String get pleaseSelectBank;

  /// No description provided for @pleaseEnterIban.
  ///
  /// In en, this message translates to:
  /// **'Please enter IBAN'**
  String get pleaseEnterIban;

  /// No description provided for @pleaseEnterBankName.
  ///
  /// In en, this message translates to:
  /// **'Please enter bank name'**
  String get pleaseEnterBankName;

  /// No description provided for @ibanUpdated.
  ///
  /// In en, this message translates to:
  /// **'IBAN updated successfully!'**
  String get ibanUpdated;

  /// No description provided for @ibanDeleted.
  ///
  /// In en, this message translates to:
  /// **'IBAN deleted successfully!'**
  String get ibanDeleted;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date Added'**
  String get dateLabel;

  /// No description provided for @ibanQrTitle.
  ///
  /// In en, this message translates to:
  /// **'IBAN QR Code'**
  String get ibanQrTitle;

  /// No description provided for @ibanCopied.
  ///
  /// In en, this message translates to:
  /// **'IBAN copied successfully!'**
  String get ibanCopied;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @addIbanPage.
  ///
  /// In en, this message translates to:
  /// **'Add IBAN Page'**
  String get addIbanPage;

  /// No description provided for @addIbanSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your IBAN details securely and easily.'**
  String get addIbanSubtitle;

  /// No description provided for @myIbanTab.
  ///
  /// In en, this message translates to:
  /// **'My IBAN'**
  String get myIbanTab;

  /// No description provided for @friendIbanTab.
  ///
  /// In en, this message translates to:
  /// **'Friend\'s IBAN'**
  String get friendIbanTab;

  /// No description provided for @addNewIban.
  ///
  /// In en, this message translates to:
  /// **'Add New IBAN'**
  String get addNewIban;

  /// No description provided for @ibanHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. TR0380000000608010167519'**
  String get ibanHint;

  /// No description provided for @saveIban.
  ///
  /// In en, this message translates to:
  /// **'Save IBAN'**
  String get saveIban;

  /// No description provided for @ibanSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save IBAN please try again'**
  String get ibanSaveFailed;

  /// No description provided for @ibanSaveSuccess.
  ///
  /// In en, this message translates to:
  /// **'IBAN saved successfully!'**
  String get ibanSaveSuccess;

  /// No description provided for @addFriendIban.
  ///
  /// In en, this message translates to:
  /// **'Add Friend\'s IBAN'**
  String get addFriendIban;

  /// No description provided for @friendNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Anas al'**
  String get friendNameHint;

  /// No description provided for @pleaseEnterFriendName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your friend\'s name'**
  String get pleaseEnterFriendName;

  /// No description provided for @alignQr.
  ///
  /// In en, this message translates to:
  /// **'Align the QR code within the frame'**
  String get alignQr;

  /// No description provided for @scanQRCode.
  ///
  /// In en, this message translates to:
  /// **'Scan QR Code'**
  String get scanQRCode;

  /// No description provided for @logedOut.
  ///
  /// In en, this message translates to:
  /// **'Loged out successfuly'**
  String get logedOut;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can login with your username and password.'**
  String get loginSubtitle;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @pleaseWait.
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment'**
  String get pleaseWait;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'I forgot my password'**
  String get forgotPassword;

  /// No description provided for @securityQuestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Security Question'**
  String get securityQuestionTitle;

  /// No description provided for @securityQuestionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please select and answer the question you entered when you signed up.'**
  String get securityQuestionSubtitle;

  /// No description provided for @chooseQuestion.
  ///
  /// In en, this message translates to:
  /// **'Choose a question'**
  String get chooseQuestion;

  /// No description provided for @questionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a question'**
  String get questionRequired;

  /// No description provided for @typeAnswer.
  ///
  /// In en, this message translates to:
  /// **'Type your answer'**
  String get typeAnswer;

  /// No description provided for @answerRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your answer'**
  String get answerRequired;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @resetAccount.
  ///
  /// In en, this message translates to:
  /// **'Reset Account'**
  String get resetAccount;

  /// No description provided for @newUsername.
  ///
  /// In en, this message translates to:
  /// **'New Username'**
  String get newUsername;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter a username'**
  String get enterUsername;

  /// No description provided for @newSecurityQuestion.
  ///
  /// In en, this message translates to:
  /// **'New Security Question'**
  String get newSecurityQuestion;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords doesn\'t match'**
  String get passwordsDontMatch;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed, please try again'**
  String get loginFailed;

  /// No description provided for @resetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account reset successful'**
  String get resetSuccess;

  /// No description provided for @resetFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset account'**
  String get resetFailed;

  /// No description provided for @questionFavFood.
  ///
  /// In en, this message translates to:
  /// **'What is your favorite food?'**
  String get questionFavFood;

  /// No description provided for @questionMotherMaiden.
  ///
  /// In en, this message translates to:
  /// **'What is your mother\'s maiden name?'**
  String get questionMotherMaiden;

  /// No description provided for @questionFirstPet.
  ///
  /// In en, this message translates to:
  /// **'What is the name of your first pet?'**
  String get questionFirstPet;

  /// No description provided for @questionBirthCity.
  ///
  /// In en, this message translates to:
  /// **'In what city were you born?'**
  String get questionBirthCity;

  /// No description provided for @loginbtn.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginbtn;

  /// No description provided for @signUpbtn.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpbtn;

  /// No description provided for @userRegisterSuccess.
  ///
  /// In en, this message translates to:
  /// **'User registered successfully.'**
  String get userRegisterSuccess;

  /// No description provided for @usernameExists.
  ///
  /// In en, this message translates to:
  /// **'Username already exists.'**
  String get usernameExists;

  /// No description provided for @registerFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registerFailed;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged in successfully.'**
  String get loginSuccess;

  /// No description provided for @loginInvalid.
  ///
  /// In en, this message translates to:
  /// **'Incorrect username or password.'**
  String get loginInvalid;

  /// No description provided for @securityQuestionMatched.
  ///
  /// In en, this message translates to:
  /// **'Security question matched!'**
  String get securityQuestionMatched;

  /// No description provided for @securityQuestionWrong.
  ///
  /// In en, this message translates to:
  /// **'Incorrect answer to the security question.'**
  String get securityQuestionWrong;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @editSuccess.
  ///
  /// In en, this message translates to:
  /// **'Your information updated successfully. Try to login again!'**
  String get editSuccess;

  /// No description provided for @editFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update user information.'**
  String get editFailed;

  /// No description provided for @signUpScreen.
  ///
  /// In en, this message translates to:
  /// **'Sign Up Screen'**
  String get signUpScreen;

  /// No description provided for @signUpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You can SignUp with your username and password.'**
  String get signUpSubtitle;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password is required'**
  String get confirmPasswordRequired;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @securityQuestion.
  ///
  /// In en, this message translates to:
  /// **'Security Question'**
  String get securityQuestion;

  /// No description provided for @selectSecurityQuestion.
  ///
  /// In en, this message translates to:
  /// **'Please select a security question'**
  String get selectSecurityQuestion;

  /// No description provided for @yourAnswer.
  ///
  /// In en, this message translates to:
  /// **'Your Answer'**
  String get yourAnswer;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @registrationSuccess.
  ///
  /// In en, this message translates to:
  /// **'User registered successfully.'**
  String get registrationSuccess;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Username already exists.'**
  String get registrationFailed;

  /// No description provided for @rememberAnswerNote.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget this answer, you will need it when recovering your account.'**
  String get rememberAnswerNote;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete IBAN'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this IBAN?'**
  String get confirmDeleteMessage;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @securityQuestionIncorrect.
  ///
  /// In en, this message translates to:
  /// **'Incorrect answer to the security question.'**
  String get securityQuestionIncorrect;

  /// No description provided for @userInfoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Your information updated successfully. Try to login again!'**
  String get userInfoUpdated;

  /// No description provided for @userInfoUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update user information.'**
  String get userInfoUpdateFailed;

  /// No description provided for @logOutBtn.
  ///
  /// In en, this message translates to:
  /// **'log Out'**
  String get logOutBtn;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'İngilizce'**
  String get english;

  /// No description provided for @turkish.
  ///
  /// In en, this message translates to:
  /// **'Türkçe'**
  String get turkish;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Düzenle'**
  String get update;

  /// No description provided for @anotherbank.
  ///
  /// In en, this message translates to:
  /// **'Another bank...'**
  String get anotherbank;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

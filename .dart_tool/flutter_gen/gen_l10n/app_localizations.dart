import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
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
    Locale('id')
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// A message with a single parameter
  ///
  /// In en, this message translates to:
  /// **'Hi {userName}'**
  String lblHi(String userName);

  /// No description provided for @lblLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get lblLogin;

  /// No description provided for @lblRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get lblRegister;

  /// No description provided for @lblForgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get lblForgotPassword;

  /// No description provided for @lblWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get lblWelcome;

  /// No description provided for @lblWellcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Buying and selling digital gold is fast and easy'**
  String get lblWellcomeDesc;

  /// No description provided for @lblEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get lblEmail;

  /// No description provided for @lblOr.
  ///
  /// In en, this message translates to:
  /// **'Or'**
  String get lblOr;

  /// No description provided for @lblPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get lblPhoneNumber;

  /// No description provided for @lblPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get lblPassword;

  /// No description provided for @lblWrongAccount.
  ///
  /// In en, this message translates to:
  /// **'Wrong Number, Email or Password'**
  String get lblWrongAccount;

  /// No description provided for @lblDontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account'**
  String get lblDontHaveAccount;

  /// No description provided for @lblCantBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Cant be empty'**
  String get lblCantBeEmpty;

  /// No description provided for @lblFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get lblFullName;

  /// No description provided for @lblTermsAndCondition.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get lblTermsAndCondition;

  /// No description provided for @lblPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get lblPrivacyPolicy;

  /// No description provided for @lblAgreeTo.
  ///
  /// In en, this message translates to:
  /// **'I agree to'**
  String get lblAgreeTo;

  /// No description provided for @lblLakuemasService.
  ///
  /// In en, this message translates to:
  /// **'of lakuemas service'**
  String get lblLakuemasService;

  /// No description provided for @lblAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'already have an account'**
  String get lblAlreadyHaveAccount;

  /// No description provided for @lblFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full name as per identity card'**
  String get lblFullNameHint;

  /// No description provided for @lblPhoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Active cell phone number'**
  String get lblPhoneNumberHint;

  /// No description provided for @lblEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get lblEmailHint;

  /// No description provided for @lblPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get lblPasswordHint;

  /// No description provided for @lblReferalHint.
  ///
  /// In en, this message translates to:
  /// **'Referral code (Optional)'**
  String get lblReferalHint;

  /// No description provided for @lblPhoneNumberError.
  ///
  /// In en, this message translates to:
  /// **'please insert a valid phone number'**
  String get lblPhoneNumberError;

  /// No description provided for @lblEmailError.
  ///
  /// In en, this message translates to:
  /// **'please insert a valid email'**
  String get lblEmailError;

  /// No description provided for @lblPasswordValidation.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get lblPasswordValidation;

  /// No description provided for @lblPasswordWrong.
  ///
  /// In en, this message translates to:
  /// **'wrong password'**
  String get lblPasswordWrong;

  /// No description provided for @lblForgotDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive password reset instructions'**
  String get lblForgotDesc;

  /// No description provided for @lblUnregisteredEmail.
  ///
  /// In en, this message translates to:
  /// **'unregistered email address'**
  String get lblUnregisteredEmail;

  /// No description provided for @lblSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get lblSend;

  /// No description provided for @lblBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get lblBack;

  /// No description provided for @lblPasswordChangeSent.
  ///
  /// In en, this message translates to:
  /// **'Password change instructions have been sent successfully'**
  String get lblPasswordChangeSent;

  /// No description provided for @lblPleaseCheckEmail.
  ///
  /// In en, this message translates to:
  /// **'Please check your e-mail'**
  String get lblPleaseCheckEmail;

  /// No description provided for @lblBackToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get lblBackToLogin;

  /// No description provided for @lblAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get lblAccount;

  /// No description provided for @lblAccountVerification.
  ///
  /// In en, this message translates to:
  /// **'Account Verification'**
  String get lblAccountVerification;

  /// No description provided for @lblPersonalData.
  ///
  /// In en, this message translates to:
  /// **'Personal Data'**
  String get lblPersonalData;

  /// No description provided for @lblSelfData.
  ///
  /// In en, this message translates to:
  /// **'Self Data'**
  String get lblSelfData;

  /// No description provided for @lblRmReferal.
  ///
  /// In en, this message translates to:
  /// **'RM Referral'**
  String get lblRmReferal;

  /// No description provided for @lblSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get lblSecurity;

  /// No description provided for @lblChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get lblChangePassword;

  /// No description provided for @lblSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get lblSettings;

  /// No description provided for @lblAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get lblAbout;

  /// No description provided for @lblUs.
  ///
  /// In en, this message translates to:
  /// **'Us'**
  String get lblUs;

  /// No description provided for @lblCloseAccount.
  ///
  /// In en, this message translates to:
  /// **'Close Account'**
  String get lblCloseAccount;

  /// No description provided for @lblUnverified.
  ///
  /// In en, this message translates to:
  /// **'Unverified'**
  String get lblUnverified;

  /// No description provided for @lblUnverifiedDesc.
  ///
  /// In en, this message translates to:
  /// **'Verify now to be able to use all Lakuemas features'**
  String get lblUnverifiedDesc;

  /// No description provided for @lblRegularMember.
  ///
  /// In en, this message translates to:
  /// **'Regular Member'**
  String get lblRegularMember;

  /// No description provided for @lblYourTotalGold.
  ///
  /// In en, this message translates to:
  /// **'Your Total Gold'**
  String get lblYourTotalGold;

  /// No description provided for @lblWorth.
  ///
  /// In en, this message translates to:
  /// **'Worth'**
  String get lblWorth;

  /// No description provided for @lblCreateAvatar.
  ///
  /// In en, this message translates to:
  /// **'Create Avatar'**
  String get lblCreateAvatar;

  /// No description provided for @lblGoldBalance.
  ///
  /// In en, this message translates to:
  /// **'Gold Balance'**
  String get lblGoldBalance;

  /// No description provided for @lblPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get lblPrice;

  /// No description provided for @lblPurchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Purchase Price'**
  String get lblPurchasePrice;

  /// No description provided for @lblSellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling Price'**
  String get lblSellingPrice;

  /// No description provided for @lblBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get lblBuy;

  /// No description provided for @lblGold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get lblGold;

  /// No description provided for @lblSell.
  ///
  /// In en, this message translates to:
  /// **'Sell'**
  String get lblSell;

  /// No description provided for @lblRedeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get lblRedeem;

  /// No description provided for @lblPhysicalPull.
  ///
  /// In en, this message translates to:
  /// **'Physical Pull'**
  String get lblPhysicalPull;

  /// No description provided for @lblAccountBalance.
  ///
  /// In en, this message translates to:
  /// **'Account Balance'**
  String get lblAccountBalance;

  /// No description provided for @lblLakuSave.
  ///
  /// In en, this message translates to:
  /// **'Laku Save'**
  String get lblLakuSave;

  /// No description provided for @lblEliteBonuses.
  ///
  /// In en, this message translates to:
  /// **'Elite Bonuses'**
  String get lblEliteBonuses;

  /// No description provided for @lblTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get lblTransfer;

  /// No description provided for @lblTrade.
  ///
  /// In en, this message translates to:
  /// **'Trade'**
  String get lblTrade;

  /// No description provided for @lblOthers.
  ///
  /// In en, this message translates to:
  /// **'Others'**
  String get lblOthers;

  /// No description provided for @lblAnd.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get lblAnd;

  /// No description provided for @lblGetLowerPrice.
  ///
  /// In en, this message translates to:
  /// **'get a lower price'**
  String get lblGetLowerPrice;

  /// No description provided for @lblHere.
  ///
  /// In en, this message translates to:
  /// **'here'**
  String get lblHere;

  /// No description provided for @lblNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get lblNews;

  /// No description provided for @lblUpcomingFeatures.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Features'**
  String get lblUpcomingFeatures;

  /// No description provided for @lblJoin.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get lblJoin;

  /// No description provided for @lblNotValid.
  ///
  /// In en, this message translates to:
  /// **'is not valid'**
  String get lblNotValid;

  /// No description provided for @lblOtpVerification.
  ///
  /// In en, this message translates to:
  /// **'OTP Verificaton'**
  String get lblOtpVerification;

  /// A message with a single parameter
  ///
  /// In en, this message translates to:
  /// **'You need to verify the OTP code to continue {verificationWhat}'**
  String lblOtpVerificationDesc(String verificationWhat);

  /// No description provided for @lblInputOtp.
  ///
  /// In en, this message translates to:
  /// **'Input OTP'**
  String get lblInputOtp;

  /// No description provided for @lblInputOtpDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6 digit code that was sent to'**
  String get lblInputOtpDesc;

  /// No description provided for @lblNumber.
  ///
  /// In en, this message translates to:
  /// **'number'**
  String get lblNumber;

  /// No description provided for @lblRemainingTime.
  ///
  /// In en, this message translates to:
  /// **'remaining time'**
  String get lblRemainingTime;

  /// No description provided for @lblVerification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get lblVerification;

  /// No description provided for @lblNotReceived.
  ///
  /// In en, this message translates to:
  /// **'Not Received'**
  String get lblNotReceived;

  /// No description provided for @lblContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get lblContactUs;

  /// No description provided for @lblSendOtpViaSms.
  ///
  /// In en, this message translates to:
  /// **'Send OTP Code via SMS'**
  String get lblSendOtpViaSms;

  /// No description provided for @lblSendOtpViaEmail.
  ///
  /// In en, this message translates to:
  /// **'Send OTP Code via Email'**
  String get lblSendOtpViaEmail;

  /// No description provided for @lblIncorrectOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Incorrect OTP code'**
  String get lblIncorrectOtpCode;

  /// No description provided for @lblInputPin.
  ///
  /// In en, this message translates to:
  /// **'Input PIN'**
  String get lblInputPin;

  /// No description provided for @lblCreateNewPin.
  ///
  /// In en, this message translates to:
  /// **'Create New PIN'**
  String get lblCreateNewPin;

  /// No description provided for @lblCreateNewPinDesc.
  ///
  /// In en, this message translates to:
  /// **'For security reasons, you are required to create a PIN containing a 6-digit number.'**
  String get lblCreateNewPinDesc;

  /// No description provided for @lblCreateNewPinConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Confirmation Your New PIN'**
  String get lblCreateNewPinConfirmation;

  /// No description provided for @lblCreateNewPinConfirmationDesc.
  ///
  /// In en, this message translates to:
  /// **'For security reasons, you are required to re-enter your new PIN'**
  String get lblCreateNewPinConfirmationDesc;

  /// No description provided for @lblPinNotMatch.
  ///
  /// In en, this message translates to:
  /// **'PIN not same'**
  String get lblPinNotMatch;

  /// No description provided for @lblSomethingWrong.
  ///
  /// In en, this message translates to:
  /// **'oops, something wrong, please try again'**
  String get lblSomethingWrong;

  /// No description provided for @lblSaveGoldDiligently.
  ///
  /// In en, this message translates to:
  /// **'Save Gold Diligently'**
  String get lblSaveGoldDiligently;

  /// No description provided for @lblGetLotsOfPrizes.
  ///
  /// In en, this message translates to:
  /// **'You can get lots of prizes'**
  String get lblGetLotsOfPrizes;

  /// No description provided for @lblStartSaving.
  ///
  /// In en, this message translates to:
  /// **'Start Saving'**
  String get lblStartSaving;

  /// No description provided for @lblCongrats.
  ///
  /// In en, this message translates to:
  /// **'Congrats'**
  String get lblCongrats;

  /// No description provided for @lblRegisterSuccess.
  ///
  /// In en, this message translates to:
  /// **'your lakuemas account is already active'**
  String get lblRegisterSuccess;

  /// No description provided for @lblPleaseLogBackIn.
  ///
  /// In en, this message translates to:
  /// **'Please log in using the details that have been registered'**
  String get lblPleaseLogBackIn;

  /// No description provided for @lblEliteMember.
  ///
  /// In en, this message translates to:
  /// **'Elite Member'**
  String get lblEliteMember;

  /// No description provided for @lblEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get lblEdit;

  /// No description provided for @lblGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get lblGender;

  /// No description provided for @lblPlaceOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Place Of Birth'**
  String get lblPlaceOfBirth;

  /// No description provided for @lblDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date Of Birth'**
  String get lblDateOfBirth;

  /// No description provided for @lblMaritalStatus.
  ///
  /// In en, this message translates to:
  /// **'Marital Status'**
  String get lblMaritalStatus;

  /// No description provided for @lblReligion.
  ///
  /// In en, this message translates to:
  /// **'Religion'**
  String get lblReligion;

  /// No description provided for @lblUsed.
  ///
  /// In en, this message translates to:
  /// **'used'**
  String get lblUsed;

  /// No description provided for @lblProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get lblProfile;

  /// No description provided for @lblAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get lblAddress;

  /// No description provided for @lblIncomeData.
  ///
  /// In en, this message translates to:
  /// **'Income Data'**
  String get lblIncomeData;

  /// No description provided for @lblYouHaveNotEntered.
  ///
  /// In en, this message translates to:
  /// **'You have not entered'**
  String get lblYouHaveNotEntered;

  /// No description provided for @lblFillNow.
  ///
  /// In en, this message translates to:
  /// **'Fill now'**
  String get lblFillNow;

  /// No description provided for @lblSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get lblSave;

  /// No description provided for @lblSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get lblSelect;

  /// No description provided for @lblWhichCityYouBorn.
  ///
  /// In en, this message translates to:
  /// **'In which city were you born?'**
  String get lblWhichCityYouBorn;

  /// No description provided for @lblWhatsYourFullName.
  ///
  /// In en, this message translates to:
  /// **'Whats your fullname?'**
  String get lblWhatsYourFullName;

  /// No description provided for @lblHomeAddress.
  ///
  /// In en, this message translates to:
  /// **'Home Address'**
  String get lblHomeAddress;

  /// No description provided for @lblProvince.
  ///
  /// In en, this message translates to:
  /// **'Province'**
  String get lblProvince;

  /// No description provided for @lblYourHomeProvince.
  ///
  /// In en, this message translates to:
  /// **'your home province'**
  String get lblYourHomeProvince;

  /// No description provided for @lblCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get lblCity;

  /// No description provided for @lblDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get lblDistrict;

  /// No description provided for @lblPostalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get lblPostalCode;

  /// No description provided for @lblYourPostalCode.
  ///
  /// In en, this message translates to:
  /// **'Your postal code'**
  String get lblYourPostalCode;

  /// No description provided for @lblYourAddress.
  ///
  /// In en, this message translates to:
  /// **'Your address'**
  String get lblYourAddress;

  /// No description provided for @lblMailingAddress.
  ///
  /// In en, this message translates to:
  /// **'Mailing Address'**
  String get lblMailingAddress;

  /// No description provided for @lblMatchHomeAddress.
  ///
  /// In en, this message translates to:
  /// **'Match the home address'**
  String get lblMatchHomeAddress;

  /// No description provided for @lblJob.
  ///
  /// In en, this message translates to:
  /// **'Job'**
  String get lblJob;

  /// No description provided for @lblIncomeType.
  ///
  /// In en, this message translates to:
  /// **'Income Type'**
  String get lblIncomeType;

  /// No description provided for @lblAccCreatePurpose.
  ///
  /// In en, this message translates to:
  /// **'Account Creation Purpose'**
  String get lblAccCreatePurpose;

  /// No description provided for @lblOldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old Password'**
  String get lblOldPassword;

  /// No description provided for @lblNewPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get lblNewPassword;

  /// No description provided for @lblNewPasswordConfirmation.
  ///
  /// In en, this message translates to:
  /// **'New Password Confirmation'**
  String get lblNewPasswordConfirmation;

  /// No description provided for @lblChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get lblChangePin;

  /// No description provided for @lblOldPin.
  ///
  /// In en, this message translates to:
  /// **'Old PIN'**
  String get lblOldPin;

  /// No description provided for @lblNewPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get lblNewPin;

  /// No description provided for @lblNewPinConfirmation.
  ///
  /// In en, this message translates to:
  /// **'New PIN Confirmation'**
  String get lblNewPinConfirmation;

  /// No description provided for @lblDataSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data Saved Successfully'**
  String get lblDataSavedSuccess;

  /// No description provided for @lblSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get lblSuccess;

  /// No description provided for @lblNotMatch.
  ///
  /// In en, this message translates to:
  /// **'not match'**
  String get lblNotMatch;

  /// No description provided for @lblPinValidation.
  ///
  /// In en, this message translates to:
  /// **'PIN must be 6 digits of number'**
  String get lblPinValidation;

  /// No description provided for @lblQuestionAround.
  ///
  /// In en, this message translates to:
  /// **'The Question Around'**
  String get lblQuestionAround;

  /// No description provided for @lblHowLongCloseAccount.
  ///
  /// In en, this message translates to:
  /// **'How long does the account closure process take?'**
  String get lblHowLongCloseAccount;

  /// No description provided for @lblWillGoldForfeitCloseAccount.
  ///
  /// In en, this message translates to:
  /// **'Will the Gold Balance be forfeited after the account is closed?'**
  String get lblWillGoldForfeitCloseAccount;

  /// No description provided for @lblReasonClosingAccount.
  ///
  /// In en, this message translates to:
  /// **'Reason For Closing The Account'**
  String get lblReasonClosingAccount;

  /// No description provided for @lblRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get lblRequired;

  /// No description provided for @lblWhyCloseAccount.
  ///
  /// In en, this message translates to:
  /// **'Why do you want to close your account?'**
  String get lblWhyCloseAccount;

  /// No description provided for @lblAccountDeletedCantRecovered.
  ///
  /// In en, this message translates to:
  /// **'Accounts that have been deleted cannot be recovered'**
  String get lblAccountDeletedCantRecovered;

  /// No description provided for @lblCloseMyAccount.
  ///
  /// In en, this message translates to:
  /// **'Close My Account'**
  String get lblCloseMyAccount;

  /// No description provided for @lblForgotYourPin.
  ///
  /// In en, this message translates to:
  /// **'Forgot Your PIN'**
  String get lblForgotYourPin;

  /// No description provided for @lblPriceNotification.
  ///
  /// In en, this message translates to:
  /// **'Price Notification'**
  String get lblPriceNotification;

  /// No description provided for @lblUpdateGoldPrice.
  ///
  /// In en, this message translates to:
  /// **'Update gold price'**
  String get lblUpdateGoldPrice;

  /// No description provided for @lblPromotionNotification.
  ///
  /// In en, this message translates to:
  /// **'Promotion Notification'**
  String get lblPromotionNotification;

  /// No description provided for @lblSpecialOffer.
  ///
  /// In en, this message translates to:
  /// **'Lakuemas special offers'**
  String get lblSpecialOffer;

  /// No description provided for @lblStepNPWPDesc.
  ///
  /// In en, this message translates to:
  /// **'Step 1 of 2: Fill in the NPWP and Start Photo'**
  String get lblStepNPWPDesc;

  /// No description provided for @lblDataNPWP.
  ///
  /// In en, this message translates to:
  /// **'Data NPWP'**
  String get lblDataNPWP;

  /// No description provided for @lblNumberNPWP.
  ///
  /// In en, this message translates to:
  /// **'NPWP Number'**
  String get lblNumberNPWP;

  /// No description provided for @lblFillNPWPNumber.
  ///
  /// In en, this message translates to:
  /// **'Fill in your NPWP number'**
  String get lblFillNPWPNumber;

  /// No description provided for @lblPhotoNPWP.
  ///
  /// In en, this message translates to:
  /// **'NPWP Photo'**
  String get lblPhotoNPWP;

  /// No description provided for @lblNotUploaded.
  ///
  /// In en, this message translates to:
  /// **'Not yet uploaded'**
  String get lblNotUploaded;

  /// No description provided for @lblProcess.
  ///
  /// In en, this message translates to:
  /// **'Processed'**
  String get lblProcess;

  /// No description provided for @lblViewPhoto.
  ///
  /// In en, this message translates to:
  /// **'View Photo'**
  String get lblViewPhoto;

  /// No description provided for @lblUploadNPWPDesc.
  ///
  /// In en, this message translates to:
  /// **'Make sure your photos are clear (not blurry), not upside down, and get enough light'**
  String get lblUploadNPWPDesc;

  /// No description provided for @lblNpwpOverlayDesc.
  ///
  /// In en, this message translates to:
  /// **'Make sure your NPWP is in the box area, there is sufficient lighting, and the writing on the NPWP can be read clearly'**
  String get lblNpwpOverlayDesc;

  /// No description provided for @lblTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get lblTakePhoto;

  /// No description provided for @lblPopUpConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure You Want To Save?'**
  String get lblPopUpConfirmTitle;

  /// No description provided for @lblPopUpConfirmDesc.
  ///
  /// In en, this message translates to:
  /// **'You cannot change data during the verification process. Make sure your data is correct!'**
  String get lblPopUpConfirmDesc;

  /// No description provided for @lblConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get lblConfirm;

  /// No description provided for @lblLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get lblLater;

  /// No description provided for @lblConfirmDataSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data Saved Successfully!'**
  String get lblConfirmDataSuccess;

  /// No description provided for @lblConfirmDataSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'We will verify your data for a maximum of 2x24 hours! Thank You.'**
  String get lblConfirmDataSuccessDesc;

  /// No description provided for @lblBankName.
  ///
  /// In en, this message translates to:
  /// **'Bank name'**
  String get lblBankName;

  /// No description provided for @lblHintChooseBank.
  ///
  /// In en, this message translates to:
  /// **'Choose the bank you use'**
  String get lblHintChooseBank;

  /// No description provided for @lblAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get lblAccountNumber;

  /// No description provided for @lblHintAccountNumber.
  ///
  /// In en, this message translates to:
  /// **'Fill in your account number'**
  String get lblHintAccountNumber;

  /// No description provided for @lblVerificationDurationDesc.
  ///
  /// In en, this message translates to:
  /// **'We will carry out a verification process a maximum of 2x24 hours after all data is complete.'**
  String get lblVerificationDurationDesc;

  /// No description provided for @lblKtpData.
  ///
  /// In en, this message translates to:
  /// **'KTP Data'**
  String get lblKtpData;

  /// No description provided for @lblSelfiePhoto.
  ///
  /// In en, this message translates to:
  /// **'Selfie Photo'**
  String get lblSelfiePhoto;

  /// No description provided for @lblNpwpData.
  ///
  /// In en, this message translates to:
  /// **'NPWP Data'**
  String get lblNpwpData;

  /// No description provided for @lblBankAccountData.
  ///
  /// In en, this message translates to:
  /// **'Bank Account Data'**
  String get lblBankAccountData;

  /// No description provided for @lblKtpPhoto.
  ///
  /// In en, this message translates to:
  /// **'KTP Photo'**
  String get lblKtpPhoto;

  /// A message with parameter
  ///
  /// In en, this message translates to:
  /// **'Step {from} of {to}: {description}'**
  String lblStepFromTo(String from, String to, String description);

  /// No description provided for @lblGuide.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get lblGuide;

  /// No description provided for @lblPhotoGuide.
  ///
  /// In en, this message translates to:
  /// **'Photo Guide'**
  String get lblPhotoGuide;

  /// No description provided for @lblPhotoGuideDescOne.
  ///
  /// In en, this message translates to:
  /// **'Make sure the KTP is not blurry and not covered by flashes of light (not too bright)'**
  String get lblPhotoGuideDescOne;

  /// No description provided for @lblPhotoGuideDescTwo.
  ///
  /// In en, this message translates to:
  /// **'Make sure the KTP position is in the middle of the frame & the data is clearly visible as a whole'**
  String get lblPhotoGuideDescTwo;

  /// No description provided for @lblPhotoGuideDescThree.
  ///
  /// In en, this message translates to:
  /// **'Use the original KTP, not a scanned or photocopied KTP'**
  String get lblPhotoGuideDescThree;

  /// No description provided for @lblRight.
  ///
  /// In en, this message translates to:
  /// **'Right'**
  String get lblRight;

  /// No description provided for @lblWrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get lblWrong;

  /// No description provided for @lblKtpOverlayDesc.
  ///
  /// In en, this message translates to:
  /// **'Make sure your KTP is in the box area, there is sufficient lighting, and the writing on the KTP can be read clearly'**
  String get lblKtpOverlayDesc;

  /// No description provided for @lblRetakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Retake Photo'**
  String get lblRetakePhoto;

  /// No description provided for @lblCheckPhoto.
  ///
  /// In en, this message translates to:
  /// **'Check Photo'**
  String get lblCheckPhoto;

  /// No description provided for @lblVerified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get lblVerified;

  /// No description provided for @lblOnProgress.
  ///
  /// In en, this message translates to:
  /// **'On Progress'**
  String get lblOnProgress;

  /// No description provided for @lblFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get lblFailed;

  /// No description provided for @lblAccountNumberIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Account number cannot be empty'**
  String get lblAccountNumberIsEmpty;

  /// No description provided for @lblSelfieGuideDescOne.
  ///
  /// In en, this message translates to:
  /// **'Take a selfie in a place or room that has good lighting'**
  String get lblSelfieGuideDescOne;

  /// No description provided for @lblSelfieGuideDescTwo.
  ///
  /// In en, this message translates to:
  /// **'Make sure the face are not blurred and clearly visible'**
  String get lblSelfieGuideDescTwo;

  /// No description provided for @lblSelfieGuideDescThree.
  ///
  /// In en, this message translates to:
  /// **'Make sure your face are in the frame provided'**
  String get lblSelfieGuideDescThree;

  /// No description provided for @lblNikMustBe16Digits.
  ///
  /// In en, this message translates to:
  /// **'NIK must be 16 digit of numbers'**
  String get lblNikMustBe16Digits;

  /// No description provided for @lblExitAppConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit the Lakuemas application?'**
  String get lblExitAppConfirm;

  /// No description provided for @lblYesExitApp.
  ///
  /// In en, this message translates to:
  /// **'Yes, exit from application'**
  String get lblYesExitApp;

  /// No description provided for @lblStayToTheApp.
  ///
  /// In en, this message translates to:
  /// **'Stay to the application'**
  String get lblStayToTheApp;

  /// No description provided for @lblEffectiveGoldBalance.
  ///
  /// In en, this message translates to:
  /// **'Effective Gold Balance'**
  String get lblEffectiveGoldBalance;

  /// No description provided for @lblCurrSellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Current Selling Price'**
  String get lblCurrSellingPrice;

  /// No description provided for @lblCurrBuyPrice.
  ///
  /// In en, this message translates to:
  /// **'Current Buy Price'**
  String get lblCurrBuyPrice;

  /// No description provided for @lblPurchaseAmount.
  ///
  /// In en, this message translates to:
  /// **'Purchase Amount'**
  String get lblPurchaseAmount;

  /// No description provided for @lblSellingAmount.
  ///
  /// In en, this message translates to:
  /// **'Selling Amount'**
  String get lblSellingAmount;

  /// No description provided for @lblMinimum.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get lblMinimum;

  /// No description provided for @lblFillAmount.
  ///
  /// In en, this message translates to:
  /// **'Fill Amount'**
  String get lblFillAmount;

  /// No description provided for @lblEqualsTo.
  ///
  /// In en, this message translates to:
  /// **'Equals To'**
  String get lblEqualsTo;

  /// No description provided for @lblNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get lblNext;

  /// A message with a single parameter
  ///
  /// In en, this message translates to:
  /// **'{object} fee included'**
  String lblIncludedPrice(String object);

  /// No description provided for @lblDesiredAmount.
  ///
  /// In en, this message translates to:
  /// **'Desired Amount'**
  String get lblDesiredAmount;

  /// No description provided for @lblDesiredGramation.
  ///
  /// In en, this message translates to:
  /// **'Desired Gramation'**
  String get lblDesiredGramation;

  /// No description provided for @lblFillGram.
  ///
  /// In en, this message translates to:
  /// **'Fill Gram'**
  String get lblFillGram;

  /// No description provided for @lblAmountGram.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get lblAmountGram;

  /// No description provided for @lblAmountNominal.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get lblAmountNominal;

  /// No description provided for @lblPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get lblPaymentMethods;

  /// No description provided for @lblUseAccountBalance.
  ///
  /// In en, this message translates to:
  /// **'Use Account Balance'**
  String get lblUseAccountBalance;

  /// No description provided for @lblYouHave.
  ///
  /// In en, this message translates to:
  /// **'You Have'**
  String get lblYouHave;

  /// No description provided for @lblOtherMethods.
  ///
  /// In en, this message translates to:
  /// **'Other Methods'**
  String get lblOtherMethods;

  /// No description provided for @lblCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get lblCouponCode;

  /// No description provided for @lblEnterCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Coupon Code'**
  String get lblEnterCouponCode;

  /// A message with a single parameter
  ///
  /// In en, this message translates to:
  /// **'Number Linked to {object}'**
  String lblNumberLinkedTo(String object);

  /// No description provided for @lblInputYourPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Input your phone number'**
  String get lblInputYourPhoneNumber;

  /// No description provided for @lblOrderDetails.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get lblOrderDetails;

  /// A message with a single parameter
  ///
  /// In en, this message translates to:
  /// **'Service Fee ({object})'**
  String lblServiceFee(String object);

  /// No description provided for @lblTaxRateClause22.
  ///
  /// In en, this message translates to:
  /// **'Tax Rate Clause 22'**
  String get lblTaxRateClause22;

  /// A message with a single parameter
  ///
  /// In en, this message translates to:
  /// **'Immediately fill in your NPWP to get a {object} tax deduction'**
  String lblFillYourNpwp(String object);

  /// No description provided for @lblTotalPayment.
  ///
  /// In en, this message translates to:
  /// **'Total Payment'**
  String get lblTotalPayment;

  /// No description provided for @lblCompletePayment.
  ///
  /// In en, this message translates to:
  /// **'Complete Payment'**
  String get lblCompletePayment;

  /// A message with a single parameter
  ///
  /// In en, this message translates to:
  /// **'Get {object} Bonus'**
  String lblGetBonus(String object);

  /// No description provided for @lblSaveGoldForFuture.
  ///
  /// In en, this message translates to:
  /// **'save gold for your future'**
  String get lblSaveGoldForFuture;

  /// No description provided for @lblCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get lblCheck;

  /// No description provided for @lblNoCouponAvailable.
  ///
  /// In en, this message translates to:
  /// **'Sorry, it seems there are no coupons available at this time.'**
  String get lblNoCouponAvailable;

  /// No description provided for @lblUseThisCoupon.
  ///
  /// In en, this message translates to:
  /// **'Use This Coupon'**
  String get lblUseThisCoupon;

  /// No description provided for @lblFinishPaymentInTime.
  ///
  /// In en, this message translates to:
  /// **'Finish payment in time'**
  String get lblFinishPaymentInTime;

  /// No description provided for @lblWaitingForPayment.
  ///
  /// In en, this message translates to:
  /// **'Waiting For Payment'**
  String get lblWaitingForPayment;

  /// No description provided for @lblOrderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order Number'**
  String get lblOrderNumber;

  /// No description provided for @lblTransactionDate.
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get lblTransactionDate;

  /// No description provided for @lblPaymentGuide.
  ///
  /// In en, this message translates to:
  /// **'Payment Guide'**
  String get lblPaymentGuide;

  /// No description provided for @lblIHaveTransferred.
  ///
  /// In en, this message translates to:
  /// **'I Have Transferred'**
  String get lblIHaveTransferred;

  /// No description provided for @lblPaymentDetail.
  ///
  /// In en, this message translates to:
  /// **'Payment Detail'**
  String get lblPaymentDetail;

  /// No description provided for @lblCheckingCoupon.
  ///
  /// In en, this message translates to:
  /// **'Checking Coupon'**
  String get lblCheckingCoupon;

  /// No description provided for @lblResendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get lblResendOtp;

  /// No description provided for @lblTermsConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get lblTermsConditions;

  /// No description provided for @lblCheckTermsConditions.
  ///
  /// In en, this message translates to:
  /// **'Check terms & conditions'**
  String get lblCheckTermsConditions;

  /// No description provided for @lblFaq.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get lblFaq;

  /// No description provided for @lblDoYouHaveReferal.
  ///
  /// In en, this message translates to:
  /// **'Do You Have a Referral Code?'**
  String get lblDoYouHaveReferal;

  /// No description provided for @lblHaveReferal.
  ///
  /// In en, this message translates to:
  /// **'Yes, I have a referral code'**
  String get lblHaveReferal;

  /// No description provided for @lblNotHaveReferal.
  ///
  /// In en, this message translates to:
  /// **'I don\'t have a referral code'**
  String get lblNotHaveReferal;

  /// No description provided for @lblSubcribeToElite.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to Lakuemas Elite'**
  String get lblSubcribeToElite;

  /// No description provided for @lblReferalCode.
  ///
  /// In en, this message translates to:
  /// **'Referral Code'**
  String get lblReferalCode;

  /// No description provided for @lblRegistLakuemasElite.
  ///
  /// In en, this message translates to:
  /// **'Register Lakuemas Elite'**
  String get lblRegistLakuemasElite;

  /// No description provided for @lblSubscriptionMethod.
  ///
  /// In en, this message translates to:
  /// **'Select Subscription Method'**
  String get lblSubscriptionMethod;

  /// No description provided for @lblActivationCode.
  ///
  /// In en, this message translates to:
  /// **'Activation Code'**
  String get lblActivationCode;

  /// No description provided for @lblSubscribeDIrect.
  ///
  /// In en, this message translates to:
  /// **'Subscribe Direct'**
  String get lblSubscribeDIrect;

  /// No description provided for @lblActivationCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter activation code'**
  String get lblActivationCodeHint;

  /// No description provided for @lblMonthlyAutoDebet.
  ///
  /// In en, this message translates to:
  /// **'Monthly Auto Debit'**
  String get lblMonthlyAutoDebet;

  /// No description provided for @lblExplanationActivationCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'What is an Activation Code?'**
  String get lblExplanationActivationCodeTitle;

  /// No description provided for @lblExplanationActivationCodeDesc.
  ///
  /// In en, this message translates to:
  /// **'The Activation Code is the code that you buy at our merchant or E-Commerce partner. \n\nEnter your Activation Code and your package will be automatically selected.'**
  String get lblExplanationActivationCodeDesc;

  /// No description provided for @lblChoosePackages.
  ///
  /// In en, this message translates to:
  /// **'Select Package'**
  String get lblChoosePackages;

  /// No description provided for @lblSuccessReferalTitle.
  ///
  /// In en, this message translates to:
  /// **'Congrats! Your referral code has been recorded successfully'**
  String get lblSuccessReferalTitle;

  /// No description provided for @lblSuccessReferalDesc.
  ///
  /// In en, this message translates to:
  /// **'You will get a 5% discount after the transaction has been processed!'**
  String get lblSuccessReferalDesc;

  /// No description provided for @lblFailureReferalTitle.
  ///
  /// In en, this message translates to:
  /// **'Referral code failed'**
  String get lblFailureReferalTitle;

  /// No description provided for @lblFailureReferalDesc.
  ///
  /// In en, this message translates to:
  /// **'Please double check your referral code then re-enter it'**
  String get lblFailureReferalDesc;

  /// No description provided for @lblContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get lblContinue;

  /// No description provided for @lblPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get lblPayment;

  /// No description provided for @lblChoosePaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose payment method'**
  String get lblChoosePaymentMethod;

  /// No description provided for @lblOrderDetail.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get lblOrderDetail;

  /// No description provided for @lblPackageType.
  ///
  /// In en, this message translates to:
  /// **'Package Type'**
  String get lblPackageType;

  /// No description provided for @lblActiveUntil.
  ///
  /// In en, this message translates to:
  /// **'Active Until'**
  String get lblActiveUntil;

  /// No description provided for @lblCost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get lblCost;

  /// No description provided for @lblPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get lblPaymentMethod;

  /// No description provided for @lblTransactionDone.
  ///
  /// In en, this message translates to:
  /// **'Transaction Done!'**
  String get lblTransactionDone;

  /// No description provided for @lblBackToBeranda.
  ///
  /// In en, this message translates to:
  /// **'Back To Beranda'**
  String get lblBackToBeranda;

  /// No description provided for @lblSuccessActivationCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Congrats! Activation Code Available'**
  String get lblSuccessActivationCodeTitle;

  /// No description provided for @lblSuccessActivationCodeDesc.
  ///
  /// In en, this message translates to:
  /// **'Please continue for the activation process'**
  String get lblSuccessActivationCodeDesc;

  /// No description provided for @lblFailureActivationCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Activation Code is Not Available'**
  String get lblFailureActivationCodeTitle;

  /// No description provided for @lblFailureActivationCodeDesc.
  ///
  /// In en, this message translates to:
  /// **'Please check the activation code again then input it again'**
  String get lblFailureActivationCodeDesc;

  /// No description provided for @lblSellGoldTimeWarning.
  ///
  /// In en, this message translates to:
  /// **'The sales process takes a maximum of 2x24 working days'**
  String get lblSellGoldTimeWarning;

  /// No description provided for @lblCompleteSales.
  ///
  /// In en, this message translates to:
  /// **'Complete Sales'**
  String get lblCompleteSales;

  /// No description provided for @lblUse.
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get lblUse;

  /// No description provided for @lblEnterRedeemCode.
  ///
  /// In en, this message translates to:
  /// **'Enter Redeem Code'**
  String get lblEnterRedeemCode;

  /// No description provided for @lblWritedownYourVoucherCode.
  ///
  /// In en, this message translates to:
  /// **'Write down your voucher code'**
  String get lblWritedownYourVoucherCode;

  /// No description provided for @lblWrongRedeemCode.
  ///
  /// In en, this message translates to:
  /// **'Sorry, your redeem code is wrong or not registered. Please re-enter'**
  String get lblWrongRedeemCode;

  /// No description provided for @lblAntam.
  ///
  /// In en, this message translates to:
  /// **'Antam'**
  String get lblAntam;

  /// No description provided for @lblLotus.
  ///
  /// In en, this message translates to:
  /// **'Lotus'**
  String get lblLotus;

  /// No description provided for @lblWithdrawalMethod.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal Method'**
  String get lblWithdrawalMethod;

  /// No description provided for @lblMeGoldDeposit.
  ///
  /// In en, this message translates to:
  /// **'My Gold Deposit'**
  String get lblMeGoldDeposit;

  /// No description provided for @lblAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get lblAll;

  /// No description provided for @lblStored.
  ///
  /// In en, this message translates to:
  /// **'Stored'**
  String get lblStored;

  /// No description provided for @lblWaitingApprove.
  ///
  /// In en, this message translates to:
  /// **'Waiting Approval'**
  String get lblWaitingApprove;

  /// No description provided for @lblEmptyLakuSaveDesc.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have gold yet!\nLet\'s start saving gold now!'**
  String get lblEmptyLakuSaveDesc;

  /// No description provided for @lblLearnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn more'**
  String get lblLearnMore;

  /// No description provided for @lblAddGoldSaving.
  ///
  /// In en, this message translates to:
  /// **'Add Gold Savings'**
  String get lblAddGoldSaving;

  /// No description provided for @lblSourceFunds.
  ///
  /// In en, this message translates to:
  /// **'Source of funds'**
  String get lblSourceFunds;

  /// No description provided for @lblMainAccount.
  ///
  /// In en, this message translates to:
  /// **'Main Account'**
  String get lblMainAccount;

  /// No description provided for @lblDetailDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit Details'**
  String get lblDetailDeposit;

  /// No description provided for @lblWeightGold.
  ///
  /// In en, this message translates to:
  /// **'The Weight of Gold You Have Entrusted'**
  String get lblWeightGold;

  /// No description provided for @lblYouGet.
  ///
  /// In en, this message translates to:
  /// **'You Get'**
  String get lblYouGet;

  /// No description provided for @lblCustodyPeriod.
  ///
  /// In en, this message translates to:
  /// **'Custody Period'**
  String get lblCustodyPeriod;

  /// No description provided for @lblExtendDeposit.
  ///
  /// In en, this message translates to:
  /// **'Do you want to extend the deposit automatically?'**
  String get lblExtendDeposit;

  /// No description provided for @lblAccNumberExtendDepo.
  ///
  /// In en, this message translates to:
  /// **'Renewal Destination Lakuemas Account Number'**
  String get lblAccNumberExtendDepo;

  /// No description provided for @lblExtendDepoInfo.
  ///
  /// In en, this message translates to:
  /// **'Your deposit will be extended according to the time period you enter'**
  String get lblExtendDepoInfo;

  /// No description provided for @lblExtendStatus.
  ///
  /// In en, this message translates to:
  /// **'Extension Status'**
  String get lblExtendStatus;

  /// No description provided for @lblDetailLakuDepo.
  ///
  /// In en, this message translates to:
  /// **'Detail Laku Deposit'**
  String get lblDetailLakuDepo;

  /// No description provided for @lblCapitalLease.
  ///
  /// In en, this message translates to:
  /// **'Capital Lease'**
  String get lblCapitalLease;

  /// No description provided for @lblRenewalAccNumber.
  ///
  /// In en, this message translates to:
  /// **'Renewal Destination Account Number'**
  String get lblRenewalAccNumber;

  /// No description provided for @lblCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get lblCancel;

  /// No description provided for @lblMaxApprove.
  ///
  /// In en, this message translates to:
  /// **'Maximum approval process 7 x 24 hours'**
  String get lblMaxApprove;

  /// No description provided for @lblGoldDeposit.
  ///
  /// In en, this message translates to:
  /// **'Gold Savings'**
  String get lblGoldDeposit;

  /// No description provided for @lblCapitalLeaseYear.
  ///
  /// In en, this message translates to:
  /// **'Capital Lease per Year'**
  String get lblCapitalLeaseYear;

  /// No description provided for @lblSaveDuration.
  ///
  /// In en, this message translates to:
  /// **'Save Duration'**
  String get lblSaveDuration;

  /// No description provided for @lblLakuSaveCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure To Cancel Gold Savings?'**
  String get lblLakuSaveCancelTitle;

  /// No description provided for @lblLakuSaveCancelDesc.
  ///
  /// In en, this message translates to:
  /// **'Your gold deposit will be cancelled. Gold will be returned to your Lakuemas balance.'**
  String get lblLakuSaveCancelDesc;

  /// No description provided for @lblLakuSaveCancelSuccess.
  ///
  /// In en, this message translates to:
  /// **'Gold Savings Successfully Cancelled'**
  String get lblLakuSaveCancelSuccess;

  /// No description provided for @lblYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get lblYes;

  /// No description provided for @lblNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get lblNo;

  /// No description provided for @lblDeposit.
  ///
  /// In en, this message translates to:
  /// **'Deposit'**
  String get lblDeposit;

  /// No description provided for @lblGoldAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter the Gold Amount'**
  String get lblGoldAmount;

  /// No description provided for @lblLakuemasAccount.
  ///
  /// In en, this message translates to:
  /// **'Destination Lakuemas Account'**
  String get lblLakuemasAccount;

  /// No description provided for @lblNewAccount.
  ///
  /// In en, this message translates to:
  /// **'New Account'**
  String get lblNewAccount;

  /// No description provided for @lblFavoriteAccount.
  ///
  /// In en, this message translates to:
  /// **'Favorite Account'**
  String get lblFavoriteAccount;

  /// No description provided for @lblNewNumberAccount.
  ///
  /// In en, this message translates to:
  /// **'Write down the new account number'**
  String get lblNewNumberAccount;

  /// No description provided for @lblAddToFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get lblAddToFavorite;

  /// No description provided for @lblNewsHint.
  ///
  /// In en, this message translates to:
  /// **'Write the message you want to convey...'**
  String get lblNewsHint;

  /// No description provided for @lblFindFavoriteAccount.
  ///
  /// In en, this message translates to:
  /// **'Find Favorite Account'**
  String get lblFindFavoriteAccount;

  /// No description provided for @lblDetailsTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer Details'**
  String get lblDetailsTransfer;

  /// No description provided for @lblDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get lblDestination;

  /// No description provided for @lblTransferAccNo.
  ///
  /// In en, this message translates to:
  /// **'Transfer Account No'**
  String get lblTransferAccNo;

  /// No description provided for @lblTotalTransfer.
  ///
  /// In en, this message translates to:
  /// **'Total Transfers'**
  String get lblTotalTransfer;

  /// No description provided for @lblTransferWarning.
  ///
  /// In en, this message translates to:
  /// **'Do not provide proof & payment data to any party except Lakuemas!'**
  String get lblTransferWarning;

  /// No description provided for @lblTransferTo.
  ///
  /// In en, this message translates to:
  /// **'Transfer to'**
  String get lblTransferTo;

  /// No description provided for @lblTransferWorth.
  ///
  /// In en, this message translates to:
  /// **'Worth Transfers'**
  String get lblTransferWorth;

  /// No description provided for @lblPay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get lblPay;

  /// No description provided for @lblYourSaleIsInProcess.
  ///
  /// In en, this message translates to:
  /// **'Your Sale is in Process'**
  String get lblYourSaleIsInProcess;

  /// No description provided for @lblYourBalanceStillInProcess.
  ///
  /// In en, this message translates to:
  /// **'Your balance is still in process'**
  String get lblYourBalanceStillInProcess;

  /// No description provided for @lblTotalSales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get lblTotalSales;

  /// No description provided for @lblGoldDetails.
  ///
  /// In en, this message translates to:
  /// **'Gold Details'**
  String get lblGoldDetails;

  /// No description provided for @lblYourIncome.
  ///
  /// In en, this message translates to:
  /// **'Your Income'**
  String get lblYourIncome;

  /// No description provided for @lblTotalGold.
  ///
  /// In en, this message translates to:
  /// **'Total Gold'**
  String get lblTotalGold;

  /// No description provided for @lblEvectiveGoldGram.
  ///
  /// In en, this message translates to:
  /// **'Effective Gold Balance Grams'**
  String get lblEvectiveGoldGram;

  /// No description provided for @lblEvectiveGoldDesc.
  ///
  /// In en, this message translates to:
  /// **'This is a gold balance that can be used for transactions in the Lakuemas application, such as Selling Gold, Saving Laku, etc.'**
  String get lblEvectiveGoldDesc;

  /// No description provided for @lblTotalGoldDesc.
  ///
  /// In en, this message translates to:
  /// **'This is the total gold asset in your Lakuemas account which consists of the Effective Gold Balance and the LakuSave Balance.'**
  String get lblTotalGoldDesc;

  /// No description provided for @lblAvgGoldPrice.
  ///
  /// In en, this message translates to:
  /// **'Average Gold Price'**
  String get lblAvgGoldPrice;

  /// No description provided for @lblGoldValue.
  ///
  /// In en, this message translates to:
  /// **'Gold Value'**
  String get lblGoldValue;

  /// No description provided for @lblCurrentSellPrice.
  ///
  /// In en, this message translates to:
  /// **'Current Selling Price'**
  String get lblCurrentSellPrice;

  /// No description provided for @lblMarkerSellValue.
  ///
  /// In en, this message translates to:
  /// **'Market Selling Value'**
  String get lblMarkerSellValue;

  /// No description provided for @lblIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get lblIncome;

  /// No description provided for @lblClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get lblClose;

  /// No description provided for @lblNotification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get lblNotification;

  /// No description provided for @lblGeneralInformation.
  ///
  /// In en, this message translates to:
  /// **'General Information'**
  String get lblGeneralInformation;

  /// No description provided for @lblTransaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get lblTransaction;

  /// No description provided for @lblSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get lblSupport;

  /// No description provided for @lblHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Lakuemas Help Center'**
  String get lblHelpCenter;

  /// No description provided for @lblFrequentlyAsked.
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked'**
  String get lblFrequentlyAsked;

  /// No description provided for @lblIsYourQuestionAnswered.
  ///
  /// In en, this message translates to:
  /// **'Is your question answered?'**
  String get lblIsYourQuestionAnswered;

  /// No description provided for @lblAskViaChat.
  ///
  /// In en, this message translates to:
  /// **'ask via chat'**
  String get lblAskViaChat;

  /// No description provided for @lblCopy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get lblCopy;

  /// No description provided for @lblSearchQuestion.
  ///
  /// In en, this message translates to:
  /// **'search for question or keywords'**
  String get lblSearchQuestion;

  /// No description provided for @lblLetsAsk.
  ///
  /// In en, this message translates to:
  /// **'Come on, let\'s ask to Lakuemas'**
  String get lblLetsAsk;

  /// No description provided for @lblYourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get lblYourName;

  /// No description provided for @lblOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get lblOptional;

  /// No description provided for @lblWrite.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get lblWrite;

  /// No description provided for @lblEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get lblEmailAddress;

  /// No description provided for @lblYourEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Your Email Address'**
  String get lblYourEmailAddress;

  /// No description provided for @lblWhatsYourQuestion.
  ///
  /// In en, this message translates to:
  /// **'Whats your question?'**
  String get lblWhatsYourQuestion;

  /// No description provided for @lblYourQuestion.
  ///
  /// In en, this message translates to:
  /// **'your question'**
  String get lblYourQuestion;

  /// No description provided for @lblSendingChat.
  ///
  /// In en, this message translates to:
  /// **'Sending Chat'**
  String get lblSendingChat;

  /// No description provided for @lblWeHaveReceivedYourMessage.
  ///
  /// In en, this message translates to:
  /// **'We Have Received Your Message'**
  String get lblWeHaveReceivedYourMessage;

  /// No description provided for @lblPleaseWaitAmoment.
  ///
  /// In en, this message translates to:
  /// **'Please wait a moment'**
  String get lblPleaseWaitAmoment;

  /// No description provided for @lblWeWillContactYouSoon.
  ///
  /// In en, this message translates to:
  /// **'we will contact you soon'**
  String get lblWeWillContactYouSoon;

  /// No description provided for @lblMessageFailedToSend.
  ///
  /// In en, this message translates to:
  /// **'Message Failed To Send'**
  String get lblMessageFailedToSend;

  /// No description provided for @lblSorry.
  ///
  /// In en, this message translates to:
  /// **'Sorry'**
  String get lblSorry;

  /// No description provided for @lblPleaseTryAgainLater.
  ///
  /// In en, this message translates to:
  /// **'Please try again later'**
  String get lblPleaseTryAgainLater;

  /// No description provided for @lblYouCanContactUsDirectly.
  ///
  /// In en, this message translates to:
  /// **'you can contact us directly'**
  String get lblYouCanContactUsDirectly;

  /// No description provided for @lblBuyGoldWithThisPromo.
  ///
  /// In en, this message translates to:
  /// **'Buy Gold With This Promo'**
  String get lblBuyGoldWithThisPromo;

  /// No description provided for @lblMyAccBalance.
  ///
  /// In en, this message translates to:
  /// **'My Account Balance'**
  String get lblMyAccBalance;

  /// No description provided for @lblHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get lblHistory;

  /// No description provided for @lblCashWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Cash Withdrawal'**
  String get lblCashWithdrawal;

  /// No description provided for @lblEmptyCashWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Currently you do not have Account Balance transactions that are still being processed'**
  String get lblEmptyCashWithdrawal;

  /// No description provided for @lblCashWithdrawalInfo.
  ///
  /// In en, this message translates to:
  /// **'Funds will be transferred to your bank account a maximum of 1x24 hours working days'**
  String get lblCashWithdrawalInfo;

  /// No description provided for @lblCashWithdrawalAmount.
  ///
  /// In en, this message translates to:
  /// **'Cash Withdrawal Amount'**
  String get lblCashWithdrawalAmount;

  /// A message with a single parameter
  ///
  /// In en, this message translates to:
  /// **'Minimum nominal IDR {minDenom} + admin fee IDR {fee} = IDR {totMinDenom}'**
  String lblMinCashWithdrawalAmount(String minDenom, String fee, String totMinDenom);

  /// No description provided for @lblHintCashWithdrawal.
  ///
  /// In en, this message translates to:
  /// **'Enter the Cash Withdrawal nominal'**
  String get lblHintCashWithdrawal;

  /// No description provided for @lblSelectAmount.
  ///
  /// In en, this message translates to:
  /// **'Select Nominal'**
  String get lblSelectAmount;

  /// No description provided for @lblWithdrawalAccBalance.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Account Balance'**
  String get lblWithdrawalAccBalance;

  /// No description provided for @lblCashWithdrawalDetails.
  ///
  /// In en, this message translates to:
  /// **'Cash Withdrawal Details'**
  String get lblCashWithdrawalDetails;

  /// No description provided for @lblEarnedTotal.
  ///
  /// In en, this message translates to:
  /// **'Earned Total'**
  String get lblEarnedTotal;

  /// No description provided for @lblDateFilter.
  ///
  /// In en, this message translates to:
  /// **'Date Filter'**
  String get lblDateFilter;

  /// No description provided for @lblApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get lblApply;

  /// No description provided for @lblFee.
  ///
  /// In en, this message translates to:
  /// **'Service Fee'**
  String get lblFee;

  /// No description provided for @lblBonuses.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get lblBonuses;

  /// No description provided for @lblMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get lblMe;

  /// No description provided for @lblEliteBonusesSumary.
  ///
  /// In en, this message translates to:
  /// **'Make transactions at Lakuemas to add points that can be exchanged for various attractive prizes'**
  String get lblEliteBonusesSumary;

  /// No description provided for @lblExpired.
  ///
  /// In en, this message translates to:
  /// **'Check Expiration Details'**
  String get lblExpired;

  /// No description provided for @lblReward.
  ///
  /// In en, this message translates to:
  /// **'Reward'**
  String get lblReward;

  /// No description provided for @lblEmptyReward.
  ///
  /// In en, this message translates to:
  /// **'Sorry, it seems there are no rewards available at this time.'**
  String get lblEmptyReward;

  /// No description provided for @lblDetailBonuses.
  ///
  /// In en, this message translates to:
  /// **'Bonus Details'**
  String get lblDetailBonuses;

  /// No description provided for @lblHowAddBonuses.
  ///
  /// In en, this message translates to:
  /// **'How to Add Bonuses'**
  String get lblHowAddBonuses;

  /// No description provided for @lblExpiredBonuses.
  ///
  /// In en, this message translates to:
  /// **'Expired Bonuses'**
  String get lblExpiredBonuses;

  /// No description provided for @lblArticle.
  ///
  /// In en, this message translates to:
  /// **'Article'**
  String get lblArticle;

  /// No description provided for @lblNewArticles.
  ///
  /// In en, this message translates to:
  /// **'New Articles'**
  String get lblNewArticles;

  /// No description provided for @lblValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid Until'**
  String get lblValidUntil;

  /// No description provided for @lblRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get lblRemove;

  /// No description provided for @lblTotalDiscount.
  ///
  /// In en, this message translates to:
  /// **'Total Discount'**
  String get lblTotalDiscount;

  /// No description provided for @lblOthersPromo.
  ///
  /// In en, this message translates to:
  /// **'Others Promo'**
  String get lblOthersPromo;

  /// No description provided for @lblLakuemasFeatures.
  ///
  /// In en, this message translates to:
  /// **'Lakuemas Features'**
  String get lblLakuemasFeatures;

  /// No description provided for @lblMonths.
  ///
  /// In en, this message translates to:
  /// **'Months'**
  String get lblMonths;

  /// No description provided for @lblYourAccountBalanceIsNotEnough.
  ///
  /// In en, this message translates to:
  /// **'Your Account Balance is not enough'**
  String get lblYourAccountBalanceIsNotEnough;

  /// No description provided for @lblYourAccountBalanceIsUsed.
  ///
  /// In en, this message translates to:
  /// **'Your Account Balance is Used'**
  String get lblYourAccountBalanceIsUsed;

  /// A message with a single parameter
  ///
  /// In en, this message translates to:
  /// **'Minimum amount is {object} gram'**
  String lblMinimumAmount(String object);

  /// No description provided for @lblGoldBalanceNotEnough.
  ///
  /// In en, this message translates to:
  /// **'Gold balance not enough'**
  String get lblGoldBalanceNotEnough;

  /// No description provided for @lblSavedSince.
  ///
  /// In en, this message translates to:
  /// **'Saved Since'**
  String get lblSavedSince;

  /// No description provided for @lblSavedBalance.
  ///
  /// In en, this message translates to:
  /// **'Saved Gold Balance'**
  String get lblSavedBalance;

  /// A message with a single parameter
  ///
  /// In en, this message translates to:
  /// **'See All {object}'**
  String lblSeeAll(String object);

  /// No description provided for @lblLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get lblLoading;

  /// No description provided for @lblLakuemasElite.
  ///
  /// In en, this message translates to:
  /// **'Lakuemas Elite'**
  String get lblLakuemasElite;

  /// No description provided for @lblAddActivePeriod.
  ///
  /// In en, this message translates to:
  /// **'Add Active Period'**
  String get lblAddActivePeriod;

  /// No description provided for @lblHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get lblHome;

  /// No description provided for @lblReferral.
  ///
  /// In en, this message translates to:
  /// **'Referral'**
  String get lblReferral;

  /// No description provided for @lblOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get lblOffers;

  /// No description provided for @lblMyReferralCode.
  ///
  /// In en, this message translates to:
  /// **'My Referral Code'**
  String get lblMyReferralCode;

  /// No description provided for @lblShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get lblShare;

  /// No description provided for @lblMonthSave.
  ///
  /// In en, this message translates to:
  /// **'Happy! This month you save'**
  String get lblMonthSave;

  /// No description provided for @lblDiscBuyGold.
  ///
  /// In en, this message translates to:
  /// **'Buy Gold Discount'**
  String get lblDiscBuyGold;

  /// No description provided for @lblDicsVoucherGold.
  ///
  /// In en, this message translates to:
  /// **'Gold Voucher Discount'**
  String get lblDicsVoucherGold;

  /// No description provided for @lblTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get lblTotal;

  /// No description provided for @lblContactNumber.
  ///
  /// In en, this message translates to:
  /// **'For financial consultation, please contact the number below'**
  String get lblContactNumber;

  /// No description provided for @lblChatViaWA.
  ///
  /// In en, this message translates to:
  /// **'Chat Via Whatsapp'**
  String get lblChatViaWA;

  /// No description provided for @lblYouGot.
  ///
  /// In en, this message translates to:
  /// **'Congratulations, you got'**
  String get lblYouGot;

  /// No description provided for @lblUnsubscribe.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe'**
  String get lblUnsubscribe;

  /// No description provided for @lblReferralBonusTitle.
  ///
  /// In en, this message translates to:
  /// **'Regarding Referral Bonuses'**
  String get lblReferralBonusTitle;

  /// No description provided for @lblReferralBonusDesc.
  ///
  /// In en, this message translates to:
  /// **'Your referral bonus is only valid if the user you referred is subscribed to the Elite program.'**
  String get lblReferralBonusDesc;

  /// No description provided for @lblSip.
  ///
  /// In en, this message translates to:
  /// **'Yup, got it'**
  String get lblSip;

  /// No description provided for @lblWarningUbsub.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unsubscribe?'**
  String get lblWarningUbsub;

  /// No description provided for @lblYesUnsub.
  ///
  /// In en, this message translates to:
  /// **'Yes, Unsubscribe'**
  String get lblYesUnsub;

  /// No description provided for @lblReasonUnsub.
  ///
  /// In en, this message translates to:
  /// **'Reason for Unsubscribing (Required)'**
  String get lblReasonUnsub;

  /// No description provided for @lblWarnUnsub.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribing will turn off the automatic debit of your Lakuemas Elite subscription from the last month of subscription'**
  String get lblWarnUnsub;

  /// No description provided for @lblUnsubNow.
  ///
  /// In en, this message translates to:
  /// **'Unsubscribe Now'**
  String get lblUnsubNow;

  /// No description provided for @lblSendReasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Send your reason and unsubscribe?'**
  String get lblSendReasonTitle;

  /// No description provided for @lblSeeU.
  ///
  /// In en, this message translates to:
  /// **'See you!'**
  String get lblSeeU;

  /// No description provided for @lblSeeUDesc.
  ///
  /// In en, this message translates to:
  /// **'Thank you for being a part of Lakuemas Elite! We are currently processing your subscription termination.'**
  String get lblSeeUDesc;

  /// No description provided for @lblBackToMainScreen.
  ///
  /// In en, this message translates to:
  /// **'Return to Main Page'**
  String get lblBackToMainScreen;

  /// No description provided for @lblTotalVoucherGold.
  ///
  /// In en, this message translates to:
  /// **'Total Gold Vouchers'**
  String get lblTotalVoucherGold;

  /// No description provided for @lblViewGoldVoucher.
  ///
  /// In en, this message translates to:
  /// **'View My Gold Voucher'**
  String get lblViewGoldVoucher;

  /// No description provided for @lblActiveReferralList.
  ///
  /// In en, this message translates to:
  /// **'Active Referral List'**
  String get lblActiveReferralList;

  /// No description provided for @lblViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get lblViewAll;

  /// No description provided for @lblEliteGoldVoucher.
  ///
  /// In en, this message translates to:
  /// **'Lakuemas Elite Gold Voucher'**
  String get lblEliteGoldVoucher;

  /// No description provided for @lblEmptyVoucherDesc.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have a voucher yet'**
  String get lblEmptyVoucherDesc;

  /// No description provided for @lblListMyReferral.
  ///
  /// In en, this message translates to:
  /// **'Your Referral List'**
  String get lblListMyReferral;

  /// No description provided for @lblOffersAvailable.
  ///
  /// In en, this message translates to:
  /// **'Your Referral List'**
  String get lblOffersAvailable;

  /// No description provided for @lblDetailOffer.
  ///
  /// In en, this message translates to:
  /// **'Offer Details'**
  String get lblDetailOffer;

  /// No description provided for @lblHowToUseVoucher.
  ///
  /// In en, this message translates to:
  /// **'How to Use Vouchers'**
  String get lblHowToUseVoucher;

  /// No description provided for @lblVoucherAvailable.
  ///
  /// In en, this message translates to:
  /// **'Number of Vouchers Available'**
  String get lblVoucherAvailable;

  /// No description provided for @lblEmptyOffer.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any offers yet'**
  String get lblEmptyOffer;

  /// No description provided for @lblMyOffer.
  ///
  /// In en, this message translates to:
  /// **'My Offers'**
  String get lblMyOffer;

  /// No description provided for @lblEnterCoupon.
  ///
  /// In en, this message translates to:
  /// **'Enter the coupon code'**
  String get lblEnterCoupon;

  /// No description provided for @lblInfoUseVoucher.
  ///
  /// In en, this message translates to:
  /// **'Vouchers can only be used once per month'**
  String get lblInfoUseVoucher;

  /// No description provided for @lblPhysicalTrade.
  ///
  /// In en, this message translates to:
  /// **'Physical Trade'**
  String get lblPhysicalTrade;

  /// No description provided for @lblGram.
  ///
  /// In en, this message translates to:
  /// **'Gram'**
  String get lblGram;

  /// No description provided for @lblDigitalTrade.
  ///
  /// In en, this message translates to:
  /// **'Digital Trade'**
  String get lblDigitalTrade;

  /// No description provided for @lblUseGoldBalance.
  ///
  /// In en, this message translates to:
  /// **'Use Gold Balance'**
  String get lblUseGoldBalance;

  /// No description provided for @lblTypePayment.
  ///
  /// In en, this message translates to:
  /// **'Type Payment'**
  String get lblTypePayment;

  /// No description provided for @lblSelectStore.
  ///
  /// In en, this message translates to:
  /// **'Select Store'**
  String get lblSelectStore;

  /// No description provided for @lblPickupStore.
  ///
  /// In en, this message translates to:
  /// **'Pickup Store'**
  String get lblPickupStore;

  /// No description provided for @lblDetailOrder.
  ///
  /// In en, this message translates to:
  /// **'Detail Order'**
  String get lblDetailOrder;

  /// No description provided for @lblDontSameOldPass.
  ///
  /// In en, this message translates to:
  /// **'New password cannot be the same as the old password'**
  String get lblDontSameOldPass;

  /// No description provided for @lblDontSameOldPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN cannot be the same as the old PIN'**
  String get lblDontSameOldPin;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'id': return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

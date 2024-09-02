import '../constants/secure_storage_key.dart';
import '../depedencies_injection/depedency_injection.dart';
import '../services/secure_storage_service.dart';

Function() swipeBackDice = () {};

class AppRoutes {
  static Future<String> get initialRoute async {
    final userMapString =
        await sl<SecureStorageService>().readSecureData(ssUserData);
    if ((userMapString ?? '').isNotEmpty) {
      // String? backScreen;
      // return '$pin/${PinType.validate}/$beranda/$backScreen';
      return pin;
    }
    return login;
    //
    // return buyGold;
    // return paymentMethod;
    // return '$paymentMethod/$paymentConfirmation/$couponRedeem';
    // return '$sellGold/$sellGoldConfirmation';
    // return notification;
    // return "$cameraOverlay/${CameraOverlayFor.ktp}";
  }

  static String serverError = 'server-error';

  static String login = 'auth';

  /// require to add extra loginBloc
  static String loginPrivy = 'auth-privy';

  /// require to add query params parentScreenName, phoneNumber, email
  static String otpChooseLogin = 'otp-choose-login';
  static String otpLogin = 'otp-login';
  static String otpChooseForgotPassword = 'otp-choose-forgot-password';
  static String otpForgotPassword = 'otp-forgot-password';
  static String otpChooseRegister = 'otp-choose-register';
  static String otpRegister = 'otp-register';
  static String otpChooseForgotPin = 'otp-choose-forgot-pin';
  static String otpForgotPin = 'otp-forgot-pin';
  static String otpChooseValidate = 'otp-choose-validate';
  static String otpValidate = 'otp-validate';

  static String register = 'register';

  /// require to add query params parentScreenName, phoneNumber, email
  // static String otpChoose = 'otp-choose';
  // static String otpChooseForgotPin = 'otp-choose-forgot-pin';

  /// require to add extra bloc; queryParams parentScreenName, phoneNumber, email; and params username, otpType
  // static String otp = 'otp';
  static String otpPin = 'otp-pin';

  /// require to add params pinType, nextScreen, backScreen and extra 'eliteCubit' and other for the data
  static const String pin = 'pin';
  static String newPin = 'new-pin';
  static String forgotPassword = 'forgot-password';
  static String newPassword = 'new-password';
  static const String beranda = 'beranda';
  static String portofolio = 'portofolio';
  static String elite = 'elite';
  static String profile = 'profile';

  // static String otpForgotPin = 'otp-forgot-pin';

  /// require to add queryParams isElite, extra berandaBalancesBloc
  static String qrTransfer = 'qr-transfer';

  /// require to add extra ProfileBloc
  static String profileSelfData = 'profile-self-data';

  /// require to add extra ProfileBloc
  static String selfDataUpdate = 'self-data-update';

  /// require to add extra bloc=ProfileBloc, phoneNumber
  static String phoneNumberUpdate = 'phone-number-update';

  /// require to add extra bloc=ProfileBloc, email
  static String emailUpdate = 'email-update';

  /// require to add extra ProfileBloc
  static String addressUpdate = 'address-update';

  /// require to add extra ProfileBloc
  static String incomeDataUpdate = 'income-data-update';

  static String changePassword = 'change-password';

  /// require to add queryParams 'isElite', extra ProfileBloc
  static String accountVerification = 'account-verification';
  static String accountVerificationKtpGuide = 'account-verification-ktp-guide';

  /// require to add params cameraOverlayFor and extra aditionalData
  static String cameraOverlay = 'camera-overlay';

  /// require to add extra xFile, aspectRatio, nik, backScreen.
  /// if backScreen null, then will back to accountVerificationKtp
  static String accountVerificationKtpResult =
      'account-verification-ktp-result';
  static String accountVerificationKtpResultAlreadyKyc =
      'account-verification-ktp-result-already-kyc';

  static String accountVerificationSelfieGuide =
      'account-verification-selfie-guide';

  static String accountLivenessSelfie = 'account-liveness-selfie';

  /// require to add extra xFile, backScreen.
  /// if backScreen null, then will back to accountVerificationKtp
  static String accountVerificationSelfie = 'account-verification-selfie';
  static String accountVerificationSelfieResultAlreadyKyc =
      'account-verification-selfie-result-already-kyc';
  static String accountVerificationNpwp = 'account-verification-npwp';
  static String accountVerificationNpwpResultAlreadyKyc =
      'account-verification-npwp-result-already-kyc';
  static String accountVerificationBank = 'account-verification-bank';
  static String accountVerificationBankResultAlreadyKyc =
      'account-verification-bank-result-already-kyc';

  /// require to add params 'backScreen' and extra (only when back to pin screen) 'pinBackScreen', 'pinNextScreen'
  static String changePin = 'change-pin';
  static String aboutUs = 'about-us';
  static String closeAccount = 'close-account';
  static String closeAccountHowLong = 'how-long';
  static String closeAccountGoldForfeit = 'gold-forfeit';
  static String closeMyAccount = 'close-my-account';
  static String settings = 'setting';

  /// require to add extra EliteRegisterReq
  static String eliteSubscriptionMethod = 'elite-subscription-method';
  static String elitePaymentMethod = 'elite-payment-method';
  static String eliteChangePaymentMethod = 'elite-change-payment-method';

  /// require to add extra EliteRegisterEntity
  static String eliteDetailsOrder = 'elite-details-order';
  static String eliteDetailsOrderVoucher = 'elite-details-order-voucher';
  static String eliteOrderSuccess = 'elite-order-success';

  static String eliteTermsCondition = 'elite-terms-condition';

  /// require to add queryParams isElite
  static String eliteTermsConditionDetailOrder =
      'elite-terms-condition-detail-order';
  static String eliteTermsConditionDetailOrderVoucher =
      'elite-terms-condition-detail-order-voucher';

  static String eliteReferal = 'elite-referal';
  static String eliteHistory = 'elite-history';
  static String isElite = 'is-elite';
  static String eliteUnsubscribe = 'elite-unsubscribe';
  static String eliteUnsubscribeSuccess = 'elite-unsubscribe-success';
  static String offerDetail = 'offer-detail';
  static String listOffer = 'list-offer';
  static String listGoldVoucher = 'list-gold-voucher';
  static String detailGoldVoucher = 'detail-gold-voucher';

  ///
  /// require to add queryParams 'isElite'
  static String buyGold = 'buy-gold';

  /// require to add queryParams 'isElite'
  static String sellGold = 'sell-gold';

  /// require to add queryParams 'isElite', extra 'eliteCubit', 'checkout'
  static String sellGoldConfirmation = 'sell-gold-confirmation';

  /// require to add queryParams 'isElite', extra 'backScreen', 'checkout', 'couponDetailEntity'
  static String paymentMethod = 'payment-method';

  /// require to add extra 'eliteCubit', 'paymentCubit', 'isBack'
  static String paymentConfirmation = 'payment-confirmation';

  static String paymentServerError = 'payment-server-error';

  static String paymentDebet = 'payment-debet';

  /// require to add extra 'paymentCubit', 'backScreen', queryParams 'isElite'
  static String couponRedeem = 'coupon-redeem';

  /// require to add extra 'eliteCubit', 'paymentCubit', 'couponDetailEntity', 'backScreen'
  static String couponDetail = 'coupon-detail';

  /// require to add extra 'eliteCubit', 'transactionCode', 'transactionDetailType'
  static String paymentWaiting = 'payment-waiting';
  static String paymentWaitingServerError = 'payment-waiting-server-error';

  /// require to add extra 'eliteCubit', 'transactionCode', 'transactionDetailType'
  static String paymentWaitingTrx = 'payment-waiting-trx';

  /// require to add extra 'eliteCubit', 'transactionCode', 'transactionDetailType'
  static String paymentWaitingWithdraw = 'payment-waiting-withdraw';

  /// require to add queryParams 'isElite', extra 'priceSettingBloc'
  static String redeem = 'redeem';

  ///
  static String physicalPull = 'physical-pull';
  static String physicalPullPayment = 'physical-pull-payment';
  static String physicalWithdrawalMethod = 'physical-pull-withdrawal-method';

  /// require to add queryParams 'isElite', extra 'berandaBalancesBloc'
  static String lakuSave = 'laku-save';

  /// require to add queryParams 'isElite', extra 'berandaBalancesBloc', 'masterDataLakusaveBloc'
  static String lakuSaveDeposit = 'laku-save-deposit';
  static String aboutLakuSave = 'about-laku-save';

  /// require to add queryParams 'isElite', extra 'berandaBalancesBloc', 'lakusaveCubit', 'masterDataLakusaveBloc'
  static String lakuSaveAutoDeposit = 'laku-save-auto-deposit';

  /// require to add queryParams 'isElite', extra 'berandaBalancesBloc', 'lakusaveCubit', 'masterDataLakusaveBloc'
  static String lakuSaveDetail = 'laku-save-detail';

  /// require to add queryParams 'isElite', extra 'berandaBalancesBloc'
  static String transfer = 'transfer';

  /// require to add queryParams 'isElite', extra 'transferChargeEntity'
  static String transferDetails = 'transfer-details';

  ///
  static String lakuTrade = 'laku-trade';
  static String lakuTradeDetail = 'laku-trade-detail';

  ///
  /// require to add queryParams 'isElite', extra 'priceEntity'
  static String goldPriceChart = 'gold-price-chart';

  ///
  static String goldDetails = 'gold-details';

  ///
  /// require to add queryParams 'isElite', extra 'accountBalanceEntity'
  static String accountBalance = 'account-balance';

  /// require to add queryParams 'isElite'
  static String accountBalanceFaq = 'account-balance-faq';

  /// require to add queryParams 'isElite', extra 'accountBalanceEntity'
  static String cashWithdrawal = 'cash-withdrawal';

  /// require to add queryParams 'isElite'
  static String cashWithdrawalHistory = 'cash-withdrawal-history';

  /// require to add queryParams 'isElite', extra 'bankMeEntity' 'accountBalanceEntity', 'denom', 'fee'
  static String cashWithdrawalDetails = 'cash-withdrawal-details';

  /// require to add extra 'eliteCubit'
  static String notification = 'notification';

  /// require to add queryParams 'isElite', extra 'backScreen'
  static String support = 'support';

  /// require to add queryParams 'isElite'
  static String supportLogin = 'support-login';

  /// require to add extra 'eliteCubit'
  static String faq = 'faq';

  /// require to add extra 'eliteCubit'
  static String faqLogin = 'faq-login';

  /// require to add extra 'eliteCubit'
  static String chatUs = 'chat-us';
  static String chatUsFaq = 'chat-us-faq';

  /// require to add extra 'eliteCubit', 'berandaPromoBloc, 'promoEntity'/'promoId'
  static String promoDetail = 'promo-detail';

  /// require to add extra 'eliteCubit'
  static String article = 'article';

  /// require to add extra 'eliteCubit', 'articleEntity'/'articleId'
  static String articleDetail = 'article-detail';

  ///
  static String bonusElite = 'bonus-elite';
  static String bonusEliteDetails = 'bonus-elite-details';
  static String bonusEliteHistory = 'bonus-elite-history';
  static String bonusEliteExpDetails = 'bonus-elite-exp-details';

  ///
  static String gachaPon = 'gacha-pon';

  ///
  static String physicalTrade = 'physical-trade';
  static String physicalTradeDetailPayment = 'physical-trade-detail-payment';
  static String ptWithdrawalMethod = 'physical-trade-withdrawal-method';
  static String pickupStore = 'pickup-store';
  static String physicalTradeFaq = 'physical-trade-faq';

  ///
  /// require to add queryParams 'isElite'
  static String avatar = 'avatar';
}

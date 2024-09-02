class ApiPath {
  static String v1 = '/api/v1';
  static String termConditions = '$v1/term-conditions';
  static String privacyPolicy = '$v1/privacy-policy';
  //!
  static String countries = '$v1/countries';
  static String provinces = '$v1/provinces';
  static String cities = '$v1/cities';
  static String districts = '$v1/districts';
  static String district = '$v1/district';
  static String menusMobile = '$v1/menus-mobile';
  //!
  static String refreshToken = '$v1/auth/refresh-token';
  static String register = '$v1/register';
  static String otpSendRegister = '$v1/register/otp';
  static String otpVerifyRegister = '$v1/register/verify';
  static String login = '$v1/login';
  static String loginPrivy = '$v1/login-privy';
  static String otpSendLogin = '$v1/login/otp';
  static String otpVerifyLogin = '$v1/login/verify';
  static String pin = '$v1/pin';
  static String pinVerify = '$pin/verify';
  static String customer = '$v1/customer';
  static String forgotPin = '$customer/forgot-pin';
  static String forgotPassword = '$customer/forgot-password';
  static String otpSendForgot = '$v1/otp/send';
  static String otpVerifyForgot = '$v1/otp/verify';
  static String customerMe = '$customer/me';
  static String customerAddress = '$customer/address';
  static String changePassword = '$customer/change-password';
  static String changePin = '$customer/change-pin';
  static String closeAccountRequest = '$customer/close-account-request';
  static String customerSetting = '$customer/setting';
  static String customerVerificationSendOtp = '$customer/verification/send-otp';
  static String customerVerificationVerifyOtp =
      '$customer/verification/verify-otp';
  //!
  static String kyc = '$customer/kyc';
  static String kycKtp = '$kyc/ktp';
  static String kycSelfie = '$kyc/selfie';
  static String kycNpwp = '$kyc/npwp';
  static String kycSavings = '$kyc/savings';
  static String kycLivenessPrivy = '$kyc/liveness-privy';
  //!
  static String banks = '$v1/banks';
  static String banksMe = '$banks/me';
  //!
  static String customerElite = '$v1/elite-customer';
  static String elite = '$v1/elite';
  static String eliteFaq = '$customerElite/faq';
  static String eliteTermsConditions = '$customerElite/terms-and-conditions';
  static String eliteMarketingOption = '$elite/marketing-config';
  static String elitePackagesOption = '$elite/package-options';
  static String eliteStartRegister = '$elite/start-register';
  static String eliteRegister = '$elite/register';
  static String eliteConfirmRegister = '$elite/confirm-registration';
  static String elitePaymentMethod = '$elite/payment-methods';
  static String eliteReferalValidation = '$customerElite/referral-validation';
  static String campaign = '$v1/campaign';
  static String eliteActivationCodeValidation = '$campaign/voucher-validation';
  static String eliteMe = '$customerElite/me';
  static String eliteHistory = '$elite/me/histories';
  static String activeOffers = '$elite/active-offers';
  static String activeOffer = '$elite/active-offer';
  static String myOffers = '$elite/me/offers';
  static String myDetailOffer = '$elite/me/offer';
  static String unsubElite = '$customerElite/unsubscribe';
  static String voucherReferral = '$elite/me/voucher-referral';
  static String socialMediaConfig = '$elite/social-media-config';
  static String eliteReferrals = '$customerElite/me/referrals';
  //!
  static String customerBalance = '$v1/customer-balance';
  static String incomeMe = '$v1/income/me';
  static String priceSetting = '$v1/pricing-setting';
  static String buyGold = '$v1/buy-gold';
  static String paymentMethods = '$v1/payment-methods';
  static String payment = '$buyGold/checkout';
  static String detailTransaction = '$v1/transaction';
  //!
  static String sellGold = '$v1/selling-gold';
  //!
  static String promos = '$v1/promos';
  static String promoDetail = '$v1/promo';
  static String articles = '$v1/articles';
  static String articlesDetail = '$v1/article';
  //!
  static String notifications = '$v1/notifications';
  //!
  static String listGoldBrand = '$v1/gold-brands';
  static String stores = '$v1/stores';
  static String charge = '$v1/gold-cashout/charge';
  static String physicalPullCheckout = '$v1/gold-cashout/checkout';
  static String coupon = '$v1/coupon';
  static String couponMe = '$coupon/me';
  static String couponValidation = '$v1/coupon-validation';
  //!
  static String goldTransferCharge = '$v1/gold-transfer/charge';
  static String goldTransferCheckout = '$v1/gold-transfer/checkout';
  //!
  static String trxHistory = '$v1/transactions';
  static String transactions = '$v1/transactions';
  static String transactionsMaster = '$v1/transactions/master';
  static String portofolio = '$v1/portofolio/me';
  //!
  static String goldDeposit = '$v1/gold-deposit';
  static String goldDepositCheckout = '$goldDeposit/checkout';
  static String goldDepositExtend = '$goldDeposit/extend';
  static String goldDepositAbout = '$goldDeposit/about';
  //!
  static String voucherRedeem = '$v1/voucher';
  static String voucherRedeemed = '$v1/transaction/voucher/redeem';
  //!
  static String accountBalance = '$v1/account-balance';
  static String accountBalanceMutations = '$accountBalance/mutations';
  static String accountBalanceFaq = '$accountBalance/faq';
  static String accountBalanceWithdraw = '$accountBalance/withdraw';
  static String accountBalanceTransaction = '$accountBalance/transactions';
  //!
  static String goldPrice = '$v1/gold-price';
  static String goldPriceChart = '$goldPrice/chart';
  //!
  static String support = '$v1/help';
  static String supportFaq = '$support/faq';
  static String supportContact = '$support/contact';
  //!
  static String lakuTrade = '$v1/laku-tukar';
  static String lakuTradeQrCode = '$lakuTrade/qrcode';
  //!
  static String customerAvatar = '$v1/customer-avatar';
  //!
  static String diceGatcha = '$v1/dice/gatcha';
}

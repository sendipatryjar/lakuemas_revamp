part of 'helper_data_cubit.dart';

class HelperDataState extends Equatable {
  final List<MenuEntity> berandaMenus;
  final PriceEntity? priceSettings;
  final PriceEntity? priceSettingsBuyGold;
  final PriceEntity? priceSettingsSellGold;
  final List<PromoEntity> promos;
  final List<ArticleEntity> articles;
  final UserDataEntity? userDataEntity;
  final List<BalanceEntity> balances;
  final TermsAndConditionsEntity? termsAndConditionsEntity;
  final DateTime? currentBackPressTime;
  final bool isShowPopupVerification;
  final List<PaymentMethodEntity> paymentMethods;
  final PortofolioEntity? portofolioEntity;
  final DetailDistrictEntity? homeDetailDistrict;
  final DetailDistrictEntity? mailDetailDistrict;
  final List<MutationEntity> accBalanceMutations;
  final PriceEntity? priceSettingsWithdrawal;
  final BankMeEntity? bankMeEntity;
  final bool isAlreadyInputPin;
  final bool isFirstTimeRunUnity;
  final bool isShowExitButtonOnDice;
  final String? unityDiceScene;
  const HelperDataState({
    this.berandaMenus = const [],
    this.priceSettings,
    this.priceSettingsBuyGold,
    this.priceSettingsSellGold,
    this.promos = const [],
    this.articles = const [],
    this.userDataEntity,
    this.balances = const [],
    this.termsAndConditionsEntity,
    this.currentBackPressTime,
    this.isShowPopupVerification = false,
    this.paymentMethods = const [],
    this.portofolioEntity,
    this.homeDetailDistrict,
    this.mailDetailDistrict,
    this.accBalanceMutations = const [],
    this.priceSettingsWithdrawal,
    this.bankMeEntity,
    this.isAlreadyInputPin = false,
    this.isFirstTimeRunUnity = true,
    this.isShowExitButtonOnDice = false,
    this.unityDiceScene,
  });

  HelperDataState copyWith({
    List<MenuEntity>? berandaMenus,
    PriceEntity? priceSettings,
    PriceEntity? priceSettingsBuyGold,
    bool nullifyPriceSettingsBuyGold = false,
    PriceEntity? priceSettingsSellGold,
    bool nullifyPriceSettingsSellGold = false,
    List<PromoEntity>? promos,
    List<ArticleEntity>? articles,
    UserDataEntity? userDataEntity,
    bool isNullifyUserData = false,
    List<BalanceEntity>? balances,
    TermsAndConditionsEntity? termsAndConditionsEntity,
    bool nullifyTermsAndConditionsEntity = false,
    DateTime? currentBackPressTime,
    bool? isShowPopupVerification,
    List<PaymentMethodEntity>? paymentMethods,
    bool nullifyPaymentMethods = false,
    PortofolioEntity? portofolioEntity,
    bool nullifyPortofolioEntity = false,
    DetailDistrictEntity? homeDetailDistrict,
    DetailDistrictEntity? mailDetailDistrict,
    List<MutationEntity>? accBalanceMutations,
    bool nullifyAccBalanceMutations = false,
    PriceEntity? priceSettingsWithdrawal,
    bool nullifyPriceSettingsWithdrawal = false,
    BankMeEntity? bankMeEntity,
    bool nullifyBankMeEntity = false,
    bool? isAlreadyInputPin,
    bool? isFirstTimeRunUnity,
    bool? isShowExitButtonOnDice,
    String? unityDiceScene,
  }) =>
      HelperDataState(
        berandaMenus: berandaMenus ?? this.berandaMenus,
        priceSettings: priceSettings ?? this.priceSettings,
        priceSettingsBuyGold: nullifyPriceSettingsBuyGold
            ? null
            : (priceSettingsBuyGold ?? this.priceSettingsBuyGold),
        priceSettingsSellGold: nullifyPriceSettingsSellGold
            ? null
            : (priceSettingsSellGold ?? this.priceSettingsSellGold),
        promos: promos ?? this.promos,
        articles: articles ?? this.articles,
        userDataEntity:
            isNullifyUserData ? null : (userDataEntity ?? this.userDataEntity),
        balances: balances ?? this.balances,
        termsAndConditionsEntity: nullifyTermsAndConditionsEntity
            ? null
            : (termsAndConditionsEntity ?? this.termsAndConditionsEntity),
        currentBackPressTime: currentBackPressTime ?? this.currentBackPressTime,
        isShowPopupVerification:
            isShowPopupVerification ?? this.isShowPopupVerification,
        paymentMethods: nullifyPaymentMethods
            ? []
            : (paymentMethods ?? this.paymentMethods),
        portofolioEntity: nullifyPortofolioEntity
            ? null
            : (portofolioEntity ?? this.portofolioEntity),
        homeDetailDistrict: isNullifyUserData
            ? null
            : (homeDetailDistrict ?? this.homeDetailDistrict),
        mailDetailDistrict: isNullifyUserData
            ? null
            : (mailDetailDistrict ?? this.mailDetailDistrict),
        accBalanceMutations: nullifyAccBalanceMutations
            ? []
            : (accBalanceMutations ?? this.accBalanceMutations),
        priceSettingsWithdrawal: nullifyPriceSettingsWithdrawal
            ? null
            : (priceSettingsWithdrawal ?? this.priceSettingsWithdrawal),
        bankMeEntity:
            nullifyBankMeEntity ? null : (bankMeEntity ?? this.bankMeEntity),
        isAlreadyInputPin: isAlreadyInputPin ?? this.isAlreadyInputPin,
        isFirstTimeRunUnity: isFirstTimeRunUnity ?? this.isFirstTimeRunUnity,
        isShowExitButtonOnDice:
            isShowExitButtonOnDice ?? this.isShowExitButtonOnDice,
        unityDiceScene: unityDiceScene ?? this.unityDiceScene,
      );

  @override
  List<Object?> get props => [
        berandaMenus,
        priceSettings,
        priceSettingsBuyGold,
        priceSettingsSellGold,
        promos,
        articles,
        userDataEntity,
        balances,
        termsAndConditionsEntity,
        currentBackPressTime,
        isShowPopupVerification,
        paymentMethods,
        portofolioEntity,
        homeDetailDistrict,
        mailDetailDistrict,
        accBalanceMutations,
        priceSettingsWithdrawal,
        bankMeEntity,
        isAlreadyInputPin,
        isFirstTimeRunUnity,
        isShowExitButtonOnDice,
        unityDiceScene,
      ];
}

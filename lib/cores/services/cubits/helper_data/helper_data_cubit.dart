import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../features/_core/others/domain/entities/terms_and_conditions_entity.dart';
import '../../../../features/_core/transaction/domain/entities/price_entity.dart';
import '../../../../features/_core/user/domain/entities/balance_entity.dart';
import '../../../../features/_core/user/domain/entities/user_data_entity.dart';
import '../../../../features/account_balance/domain/entities/bank_me_entity.dart';
import '../../../../features/account_balance/domain/entities/mutation_entity.dart';
import '../../../../features/article/domain/entities/article_entity.dart';
import '../../../../features/beranda/domain/entities/menu_entity.dart';
import '../../../../features/beranda/domain/entities/promo_entity.dart';
import '../../../../features/payment/domain/entities/payment_method_entity.dart';
import '../../../../features/portofolio/domain/entities/portofolio_entity.dart';
import '../../../../features/profile/domain/entities/detail_district_entity.dart';

part 'helper_data_state.dart';

class HelperDataCubit extends Cubit<HelperDataState> {
  HelperDataCubit() : super(const HelperDataState());

  void updateShowPopupVerification(bool value) =>
      emit(state.copyWith(isShowPopupVerification: value));

  void resetData() => emit(const HelperDataState());

  void resetDataAfterTrx() => emit(HelperDataState(
        articles: state.articles,
        berandaMenus: state.berandaMenus,
        promos: state.promos,
        termsAndConditionsEntity: state.termsAndConditionsEntity,
        isAlreadyInputPin: state.isAlreadyInputPin,
      ));

  void resetDataProfile() => emit(HelperDataState(
        articles: state.articles,
        berandaMenus: state.berandaMenus,
        promos: state.promos,
        priceSettings: state.priceSettings,
        balances: state.balances,
        termsAndConditionsEntity: state.termsAndConditionsEntity,
        paymentMethods: state.paymentMethods,
        isAlreadyInputPin: state.isAlreadyInputPin,
      ));

  void resetBalanceAfterRedeem() => emit(HelperDataState(
        articles: state.articles,
        berandaMenus: state.berandaMenus,
        promos: state.promos,
        priceSettings: state.priceSettings,
        userDataEntity: state.userDataEntity,
        termsAndConditionsEntity: state.termsAndConditionsEntity,
        isAlreadyInputPin: state.isAlreadyInputPin,
      ));

  void updateUserData(UserDataEntity? value) => emit(state.copyWith(
        userDataEntity: value,
        isNullifyUserData: value == null,
      ));

  void updatePriceSettings(PriceEntity? value) =>
      emit(state.copyWith(priceSettings: value));

  void updatePriceSettingsBuyGold(PriceEntity? value) => emit(state.copyWith(
      priceSettingsBuyGold: value, nullifyPriceSettingsBuyGold: value == null));

  void updatePriceSettingsSellGold(PriceEntity? value) => emit(state.copyWith(
      priceSettingsSellGold: value,
      nullifyPriceSettingsSellGold: value == null));

  void updateBerandaMenus(List<MenuEntity>? value) =>
      emit(state.copyWith(berandaMenus: value));

  void updatePromos(List<PromoEntity>? value) =>
      emit(state.copyWith(promos: value));

  void updateArticle(List<ArticleEntity>? value) =>
      emit(state.copyWith(articles: value));

  void updateBalances(List<BalanceEntity>? value) => emit(state.copyWith(
        balances: value,
      ));

  void updateCurrentBackPressTime(DateTime? value) => emit(state.copyWith(
        currentBackPressTime: value,
      ));

  void updateTermsAndConditions(TermsAndConditionsEntity? value) =>
      emit(state.copyWith(termsAndConditionsEntity: value));
  void resetTermsAndConditions() =>
      emit(state.copyWith(nullifyTermsAndConditionsEntity: true));

  void updatePaymentMethods(List<PaymentMethodEntity>? value) =>
      emit(state.copyWith(paymentMethods: value));
  void resetPaymentMethods() =>
      emit(state.copyWith(nullifyPaymentMethods: true));

  void updatePortofolio(PortofolioEntity? value) =>
      emit(state.copyWith(portofolioEntity: value));
  void resetPortofolio() => emit(state.copyWith(nullifyPortofolioEntity: true));

  void updateHomeDetailDistrict(DetailDistrictEntity? value) =>
      emit(state.copyWith(homeDetailDistrict: value));
  void updateMailDetailDistrict(DetailDistrictEntity? value) =>
      emit(state.copyWith(mailDetailDistrict: value));

  void updateAccBalanceMutations(List<MutationEntity>? value) =>
      emit(state.copyWith(
        accBalanceMutations: value,
        nullifyAccBalanceMutations: value == null,
      ));

  void updatePriceWithdrawal(PriceEntity? value) => emit(state.copyWith(
      priceSettingsWithdrawal: value,
      nullifyPriceSettingsWithdrawal: value == null));

  void updateBankMeEntity(BankMeEntity? value) => emit(
      state.copyWith(bankMeEntity: value, nullifyBankMeEntity: value == null));

  void alreadyInputPin(bool? value) =>
      emit(state.copyWith(isAlreadyInputPin: value));

  void firstTimeRunUnity(bool? value) =>
      emit(state.copyWith(isFirstTimeRunUnity: value));

  void exitButtonOnUnity(bool? value) =>
      emit(state.copyWith(isShowExitButtonOnDice: value));

  void unityDiceScene(String? value) =>
      emit(state.copyWith(unityDiceScene: value));
}

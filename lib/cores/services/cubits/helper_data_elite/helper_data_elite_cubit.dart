import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../features/elite/domain/entities/elite_me_entity.dart';
import '../../../../features/elite/domain/entities/faq_entity.dart';
import '../../../../features/elite/domain/entities/get_marketing_option_entity.dart';
import '../../../../features/elite/domain/entities/offer_entity.dart';
import '../../../../features/elite/domain/entities/social_media_config_entity.dart';
import '../../../../features/elite/domain/entities/voucher_referral_entity.dart';

part 'helper_data_elite_state.dart';

class HelperDataEliteCubit extends Cubit<HelperDataEliteState> {
  HelperDataEliteCubit() : super(const HelperDataEliteState());

  void resetData() => emit(const HelperDataEliteState());
  void resetDataHome() => emit(state.copyWith(
        nullifyEliteMeEntity: true,
        nullifyGetMarketingOptionEntity: true,
        nullifySocialMediaConfigEntity: true,
      ));

  void updateEliteMe(EliteMeEntity value) =>
      emit(state.copyWith(eliteMeEntity: value));
  void resetEliteMe() => emit(state.copyWith(nullifyEliteMeEntity: true));

  void updateSocialMediaConfig(SocialMediaConfigEntity value) =>
      emit(state.copyWith(socialMediaConfigEntity: value));
  void resetSocialMediaConfig() =>
      emit(state.copyWith(nullifySocialMediaConfigEntity: true));

  void updateGetMarketingOptionEntity(GetMarketingOptionEntity value) =>
      emit(state.copyWith(getMarketingOptionEntity: value));
  void resetGetMarketingOption() =>
      emit(state.copyWith(nullifyGetMarketingOptionEntity: true));

  void updateListVoucherReferralEntity(List<VoucherReferralEntity>? value) =>
      emit(state.copyWith(
        listVoucherReferralEntity: value,
      ));
  void resetListVoucherReferral() =>
      emit(state.copyWith(nullifyListVoucherReferralEntity: true));

  void updateListOfferEntity(List<OfferEntity>? value) => emit(state.copyWith(
        listOfferEntity: value,
      ));
  void resetListOffer() => emit(state.copyWith(nullifyListOfferEntity: true));

  void updateListMyOfferEntity(List<OfferEntity>? value) => emit(state.copyWith(
        listMyOfferEntity: value,
      ));
  void resetMyListOffer() =>
      emit(state.copyWith(nullifyListMyOfferEntity: true));

  void updateFaq(List<FaqEntity>? value) => emit(state.copyWith(
        faq: value,
      ));
}

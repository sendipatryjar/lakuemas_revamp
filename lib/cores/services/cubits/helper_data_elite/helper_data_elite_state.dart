part of 'helper_data_elite_cubit.dart';

class HelperDataEliteState extends Equatable {
  final EliteMeEntity? eliteMeEntity;
  final SocialMediaConfigEntity? socialMediaConfigEntity;
  final GetMarketingOptionEntity? getMarketingOptionEntity;
  final List<VoucherReferralEntity>? listVoucherReferralEntity;
  final List<OfferEntity>? listOfferEntity;
  final List<OfferEntity>? listMyOfferEntity;
  final List<FaqEntity>? faq;

  const HelperDataEliteState({
    this.eliteMeEntity,
    this.socialMediaConfigEntity,
    this.getMarketingOptionEntity,
    this.listVoucherReferralEntity,
    this.listOfferEntity,
    this.listMyOfferEntity,
    this.faq,
  });

  HelperDataEliteState copyWith({
    EliteMeEntity? eliteMeEntity,
    bool nullifyEliteMeEntity = false,
    SocialMediaConfigEntity? socialMediaConfigEntity,
    bool nullifySocialMediaConfigEntity = false,
    GetMarketingOptionEntity? getMarketingOptionEntity,
    bool nullifyGetMarketingOptionEntity = false,
    List<VoucherReferralEntity>? listVoucherReferralEntity,
    bool nullifyListVoucherReferralEntity = false,
    List<OfferEntity>? listOfferEntity,
    bool nullifyListOfferEntity = false,
    List<OfferEntity>? listMyOfferEntity,
    bool nullifyListMyOfferEntity = false,
    List<FaqEntity>? faq,
  }) =>
      HelperDataEliteState(
        eliteMeEntity:
            nullifyEliteMeEntity ? null : (eliteMeEntity ?? this.eliteMeEntity),
        socialMediaConfigEntity: nullifySocialMediaConfigEntity
            ? null
            : (socialMediaConfigEntity ?? this.socialMediaConfigEntity),
        getMarketingOptionEntity: nullifyGetMarketingOptionEntity
            ? null
            : (getMarketingOptionEntity ?? this.getMarketingOptionEntity),
        listVoucherReferralEntity: nullifyListVoucherReferralEntity
            ? null
            : (listVoucherReferralEntity ?? this.listVoucherReferralEntity),
        listOfferEntity: nullifyListOfferEntity
            ? null
            : (listOfferEntity ?? this.listOfferEntity),
        listMyOfferEntity: nullifyListMyOfferEntity
            ? null
            : (listMyOfferEntity ?? this.listMyOfferEntity),
        faq: faq ?? this.faq,
      );

  @override
  List<Object> get props => [
        [
          eliteMeEntity,
          socialMediaConfigEntity,
          getMarketingOptionEntity,
          listVoucherReferralEntity,
          listOfferEntity,
          listMyOfferEntity,
          faq,
        ]
      ];
}

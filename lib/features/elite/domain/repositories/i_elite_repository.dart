import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/models/data_with_meta.dart';
import '../entities/detail_offer_entity.dart';
import '../entities/elite_entities.dart';
import '../entities/elite_history_entity.dart';
import '../entities/elite_me_entity.dart';
import '../entities/offer_entity.dart';
import '../entities/social_media_config_entity.dart';
import '../entities/voucher_referral_entity.dart';

abstract class IEliteRepository {
  Future<Either<AppFailure, List<FaqEntity>>> getFaq({
    String? sortBy,
    String? orderBy,
    int? isActive,
  });
  Future<Either<AppFailure, String>> getTermsConditions();
  Future<Either<AppFailure, GetMarketingOptionEntity>> getMarketingOption();
  Future<Either<AppFailure, List<SubscriptionPackagesEntity>>>
      getSubscriptionPackages();
  Future<Either<AppFailure, dynamic>> eliteStartRegister();
  Future<Either<AppFailure, List<ElitePaymentMethodEntity>>>
      elitePaymentMethod();
  Future<Either<AppFailure, EliteRegisterEntity>> eliteRegister({
    int? customerId,
    int? packageId,
    int? paymentMethodId,
    String? voucherId,
    String? autoRenewalPaymentMethod,
    String? referalCode,
  });
  Future<Either<AppFailure, EliteRegisterEntity>> eliteConfirmRegister({
    int? customerId,
  });
  Future<Either<AppFailure, EliteReferalValidaitonEntity>>
      eliteReferalValidaiton({dynamic referalCode});
  Future<Either<AppFailure, EliteActivationCodeValidationEntity>>
      eliteActivationCodeValidation({
    dynamic voucherCode,
    String? type,
  });
  Future<Either<AppFailure, EliteMeEntity>> eliteMe();
  Future<Either<AppFailure, DataWithMeta<List<EliteHistoryEntity>>>>
      eliteHistory({
    int? limit,
    int? page,
    String? startDate,
    String? endDate,
    String? orderBy,
    String? sortBy,
    int? statuses,
    String? period,
  });
  Future<Either<AppFailure, List<OfferEntity>>> getOffer();
  Future<Either<AppFailure, DetailOfferEntity>> getDetailOffer({
    int? id,
  });
  Future<Either<AppFailure, List<OfferEntity>>> getMyOffer();
  Future<Either<AppFailure, DetailOfferEntity>> getMyDetailOffer({
    int? id,
  });
  Future<Either<AppFailure, Map<String, dynamic>>> redeemOffer({int? id});
  Future<Either<AppFailure, dynamic>> unsubElite({String? reason});
  Future<Either<AppFailure, List<VoucherReferralEntity>>> getVoucherReferral();
  Future<Either<AppFailure, SocialMediaConfigEntity>> getSocialMediaConfig();
  Future<Either<AppFailure, DataWithMeta<List<ListReferralEntity>>>>
      getListReferral({
    int? limit,
    int? page,
    String? startDate,
    String? endDate,
    String? startValidDate,
    String? endValidDate,
  });
}

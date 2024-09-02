import '../../../../../cores/models/base_list_resp.dart';
import '../../../../../cores/models/base_resp.dart';
import '../../models/detail_offer_model.dart';
import '../../models/elite_history_model.dart';
import '../../models/elite_me_model.dart';
import '../../models/elite_models.dart';
import '../../models/offer_model.dart';
import '../../models/social_media_config_model.dart';
import '../../models/voucher_referral_model.dart';

abstract class IEliteRemoteDataSource {
  Future<BaseResp<GetMarketingOptionModel>> getMarketingOption({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseListResp<FaqModel>> getFaq({
    FaqReq? request,
  });
  Future<String> getTermsConditions();
  Future<BaseListResp<SubscriptionPackagesModel>> getSubscriptionPackages({
    String? accessToken,
    String? refreshToken,
  });
  Future<dynamic> eliteStartRegister({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseListResp<ElitePaymentMethodModel>> elitePaymentMethod({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp<EliteRegisterModel>> eliteRegister({
    String? accessToken,
    String? refreshToken,
    EliteRegisterReq? request,
  });
  Future<BaseResp<EliteRegisterModel>> eliteConfirmRegister({
    String? accessToken,
    String? refreshToken,
    int? customerId,
  });
  Future<BaseResp<EliteReferalValidationModel>> eliteReferalValidation({
    String? accessToken,
    String? refreshToken,
    dynamic referalCode,
  });
  Future<BaseResp<EliteActivationCodeValidationModel>>
      eliteActivationCodeValidation({
    String? accessToken,
    String? refreshToken,
    dynamic voucherCode,
    String? type,
  });
  Future<BaseResp<EliteMeModel>> eliteMe({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseListResp<EliteHistoryModel>> eliteHistory({
    String? accessToken,
    String? refreshToken,
    int? limit,
    int? page,
    String? startDate,
    String? endDate,
    String? orderBy,
    String? sortBy,
    int? statuses,
    String? period,
  });
  Future<BaseListResp<OfferModel>> getOffer({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp<DetailOfferModel>> getDetailOffer({
    String? accessToken,
    String? refreshToken,
    int? id,
  });
  Future<BaseListResp<OfferModel>> getMyOffer({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp<DetailOfferModel>> getMyDetailOffer({
    String? accessToken,
    String? refreshToken,
    int? id,
  });
  Future<Map<String, dynamic>> redeemOffer({
    String? accessToken,
    String? refreshToken,
    int? id,
  });
  Future unsubElite({
    String? accessToken,
    String? refreshToken,
    String? reason,
  });
  Future<BaseListResp<VoucherReferralModel>> getVoucherReferral({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp<SocialMediaConfigModel>> getSociaMediaConfig({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseListResp<ListReferral>> getListReferral({
    String? accessToken,
    String? refreshToken,
    int? limit,
    int? page,
    String? startDate,
    String? endDate,
    String? startValidDate,
    String? endValidDate,
    // String? period,
  });
}

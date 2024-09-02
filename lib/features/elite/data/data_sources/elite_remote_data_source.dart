import '../../../../features/elite/data/models/detail_offer_model.dart';
import '../../../../features/elite/data/models/elite_history_model.dart';
import '../../../../features/elite/data/models/elite_me_model.dart';
import '../../../../features/elite/data/models/offer_model.dart';
import '../../../../features/elite/data/models/social_media_config_model.dart';
import '../../../../features/elite/data/models/voucher_referral_model.dart';

import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_list_resp.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../models/elite_models.dart';
import 'interfaces/i_elite_remote_data_source.dart';

class EliteRemoteDataSource implements IEliteRemoteDataSource {
  final ApiService apiService;

  EliteRemoteDataSource({required this.apiService});

  @override
  Future<BaseListResp<FaqModel>> getFaq({
    FaqReq? request,
  }) async {
    final result = await apiService.baseUrl(Environment.baseUrlMember()).get(
          apiPath: ApiPath.eliteFaq,
          request: request?.toJson(),
        );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, FaqModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<String> getTermsConditions() async {
    final result = await apiService.baseUrl(Environment.baseUrlMember()).get(
          apiPath: ApiPath.eliteTermsConditions,
        );
    switch (result.statusCode) {
      case 200:
        return result.data;
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<GetMarketingOptionModel>> getMarketingOption({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlInternalProcessService())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.eliteMarketingOption,
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, GetMarketingOptionModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<SubscriptionPackagesModel>> getSubscriptionPackages({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlInternalProcessService())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.elitePackagesOption,
        );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(
            result.data, SubscriptionPackagesModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<dynamic> eliteStartRegister({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .post(
          apiPath: ApiPath.eliteStartRegister,
        );
    switch (result.statusCode) {
      case 200:
        return result;
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<ElitePaymentMethodModel>> elitePaymentMethod({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.elitePaymentMethod,
        );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(
            result.data, ElitePaymentMethodModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<EliteRegisterModel>> eliteRegister({
    String? accessToken,
    String? refreshToken,
    EliteRegisterReq? request,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .post(apiPath: ApiPath.eliteRegister, request: request?.toJson());
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, EliteRegisterModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<EliteRegisterModel>> eliteConfirmRegister({
    String? accessToken,
    String? refreshToken,
    int? customerId,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .post(
      apiPath: ApiPath.eliteConfirmRegister,
      request: {
        'customer_id': customerId,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, EliteRegisterModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<EliteReferalValidationModel>> eliteReferalValidation({
    String? accessToken,
    String? refreshToken,
    referalCode,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .get(
      apiPath: ApiPath.eliteReferalValidation,
      request: {
        'referral_code': referalCode,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(
            result.data, EliteReferalValidationModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<EliteActivationCodeValidationModel>>
      eliteActivationCodeValidation({
    String? accessToken,
    String? refreshToken,
    voucherCode,
    String? type,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
      apiPath: ApiPath.eliteActivationCodeValidation,
      request: {
        'voucher_code': voucherCode,
        'type': 'elite',
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(
            result.data, EliteActivationCodeValidationModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<EliteMeModel>> eliteMe({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.eliteMe,
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(
          result.data,
          EliteMeModel.fromJson,
        );
      default:
        return handleErrors(result);
    }
  }

  @override
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
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(
      apiPath: ApiPath.eliteHistory,
      request: {
        'limit': limit,
        'page': page,
        'start_date': startDate,
        'end_date': endDate,
        'order_by': orderBy,
        'sort_by': sortBy,
        'statuses': statuses,
        'period': period,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(
          result.data,
          EliteHistoryModel.fromJson,
        );
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<OfferModel>> getOffer({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.activeOffers,
        );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(
          result.data,
          OfferModel.fromJson,
        );
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<DetailOfferModel>> getDetailOffer({
    String? accessToken,
    String? refreshToken,
    int? id,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: '${ApiPath.activeOffer}/$id',
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(
          result.data,
          DetailOfferModel.fromJson,
        );
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<OfferModel>> getMyOffer({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.myOffers,
        );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(
          result.data,
          OfferModel.fromJson,
        );
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<DetailOfferModel>> getMyDetailOffer({
    String? accessToken,
    String? refreshToken,
    int? id,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: '${ApiPath.myDetailOffer}/$id',
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(
          result.data,
          DetailOfferModel.fromJson,
        );
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<Map<String, dynamic>> redeemOffer({
    String? accessToken,
    String? refreshToken,
    int? id,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .post(
          apiPath: '${ApiPath.activeOffer}/$id/redeem',
        );
    switch (result.statusCode) {
      case 200:
        return result.data;
      default:
        return handleErrors(result);
    }
  }

  @override
  Future unsubElite({
    String? accessToken,
    String? refreshToken,
    String? reason,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .post(
      apiPath: ApiPath.unsubElite,
      request: {
        'reason': reason,
      },
    );
    switch (result.statusCode) {
      case 200:
        return result.data;
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<VoucherReferralModel>> getVoucherReferral({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.voucherReferral,
        );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(
          result.data,
          VoucherReferralModel.fromJson,
        );
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<SocialMediaConfigModel>> getSociaMediaConfig({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlInternalProcessService())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.socialMediaConfig,
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(
          result.data,
          SocialMediaConfigModel.fromJson,
        );
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseListResp<ListReferral>> getListReferral({
    String? accessToken,
    String? refreshToken,
    int? limit,
    int? page,
    String? startDate,
    String? endDate,
    String? startValidDate,
    String? endValidDate,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlMember())
        .tokenBearer(accessToken, refreshToken)
        .get(
      apiPath: ApiPath.eliteReferrals,
      request: {
        'limit': limit,
        'page': page,
        'start_date': startDate,
        'end_date': endDate,
        'start_valid_date': startValidDate,
        'end_valid_date': endValidDate,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(
          result.data,
          ListReferral.fromJson,
        );
      default:
        return handleErrors(result);
    }
  }
}

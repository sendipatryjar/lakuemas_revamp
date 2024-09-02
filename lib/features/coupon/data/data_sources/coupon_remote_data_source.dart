import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_list_resp.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../models/coupon_detail_model.dart';
import '../models/coupon_model.dart';
import '../models/coupon_validation_model.dart';
import 'interfaces/i_coupon_remote_data_source.dart';

class CouponRemoteDataSource implements ICouponRemoteDataSource {
  final ApiService apiService;

  CouponRemoteDataSource({required this.apiService});

  @override
  Future<BaseListResp<CouponModel>> getCoupons(
      {String? accessToken, String? refreshToken}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.couponMe,
        );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, CouponModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<CouponDetailModel>> getCouponDetail(
      {String? accessToken, String? refreshToken, String? couponCode}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: '${ApiPath.coupon}/$couponCode',
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, CouponDetailModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<CouponValidationModel>> couponValidation(
      {String? accessToken,
      String? refreshToken,
      String? couponCode,
      int? amount,
      int? paymentMethodId}) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .get(
      apiPath: ApiPath.couponValidation,
      request: {
        'coupon_code': couponCode,
        'amount': amount,
        'payment_method_id': paymentMethodId,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, CouponValidationModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}

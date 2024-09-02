import '../../../../../cores/models/base_list_resp.dart';
import '../../../../../cores/models/base_resp.dart';
import '../../models/coupon_detail_model.dart';
import '../../models/coupon_model.dart';
import '../../models/coupon_validation_model.dart';

abstract class ICouponRemoteDataSource {
  Future<BaseListResp<CouponModel>> getCoupons({
    String? accessToken,
    String? refreshToken,
  });
  Future<BaseResp<CouponDetailModel>> getCouponDetail({
    String? accessToken,
    String? refreshToken,
    String? couponCode,
  });
  Future<BaseResp<CouponValidationModel>> couponValidation({
    String? accessToken,
    String? refreshToken,
    String? couponCode,
    int? amount,
    int? paymentMethodId,
  });
}

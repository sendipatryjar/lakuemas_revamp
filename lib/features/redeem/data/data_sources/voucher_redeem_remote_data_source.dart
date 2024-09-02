import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../models/voucher_redeem_model.dart';
import '../models/voucher_redeemed_model.dart';
import 'interfaces/i_voucher_redeem_remote_data_source.dart';

class VoucherRedeemRemoteDataSource implements IVoucherRedeemRemoteDataSource {
  final ApiService apiService;

  VoucherRedeemRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp<VoucherRedeemModel>> check({
    String? accessToken,
    String? refreshToken,
    String? voucherCode,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlGundala())
        .tokenBearer(accessToken, refreshToken)
        .post(
          apiPath: '${ApiPath.voucherRedeem}/$voucherCode/redeemp-validation',
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, VoucherRedeemModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<VoucherRedeemedModel>> redeem({
    String? accessToken,
    String? refreshToken,
    String? voucherCode,
    double? goldRedeemed,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .post(apiPath: ApiPath.voucherRedeemed, request: {
      'voucher_code': voucherCode,
      'gold_redeemed': goldRedeemed,
    });
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, VoucherRedeemedModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}

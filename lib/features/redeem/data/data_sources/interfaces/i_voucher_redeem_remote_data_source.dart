import '../../../../../cores/models/base_resp.dart';
import '../../models/voucher_redeem_model.dart';
import '../../models/voucher_redeemed_model.dart';

abstract class IVoucherRedeemRemoteDataSource {
  Future<BaseResp<VoucherRedeemModel>> check({
    String? accessToken,
    String? refreshToken,
    String? voucherCode,
  });
  Future<BaseResp<VoucherRedeemedModel>> redeem({
    String? accessToken,
    String? refreshToken,
    String? voucherCode,
    double? goldRedeemed,
  });
}

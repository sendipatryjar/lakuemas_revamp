import '../../../../../cores/models/base_resp.dart';
import '../../models/laku_trade_checkout_model.dart';
import '../../models/laku_trade_qr_data_model.dart';

abstract class ILakuTradeRemoteDataSource {
  Future<BaseResp<LakuTradeQrDataModel>> getQrData({
    String? accessToken,
    String? refreshToken,
    String? code,
  });
  Future<BaseResp<LakuTradeCheckoutModel>> checkout({
    String? accessToken,
    String? refreshToken,
    String? code,
  });
}

import '../../../../../cores/models/base_resp.dart';
import '../../models/transfer_charge_model.dart';
import '../../models/transfer_checkout_model.dart';

abstract class ITransferRemoteDataSource {
  Future<BaseResp<TransferChargeModel>> transferCharge({
    String? accessToken,
    String? refreshToken,
    required bool isAddFavorite,
    required double goldWeight,
    required String accountNumber,
    String? note,
  });
  Future<BaseResp<TransferCheckoutModel>> transferCheckout({
    String? accessToken,
    String? refreshToken,
    required String transactionKey,
  });
}

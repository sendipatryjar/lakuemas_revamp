import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../models/transfer_charge_model.dart';
import '../models/transfer_checkout_model.dart';
import 'interfaces/i_transfer_remote_data_source.dart';

class TransferRemoteDataSource implements ITransferRemoteDataSource {
  final ApiService apiService;

  TransferRemoteDataSource({required this.apiService});

  @override
  Future<BaseResp<TransferChargeModel>> transferCharge({
    String? accessToken,
    String? refreshToken,
    required bool isAddFavorite,
    required double goldWeight,
    required String accountNumber,
    String? note,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .post(
      apiPath: ApiPath.goldTransferCharge,
      request: {
        "is_add_favorite": isAddFavorite,
        "gold_weight": goldWeight,
        "account_number": accountNumber,
        "note": note,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, TransferChargeModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<TransferCheckoutModel>> transferCheckout({
    String? accessToken,
    String? refreshToken,
    required String transactionKey,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .post(
          apiPath: '${ApiPath.goldTransferCheckout}/$transactionKey',
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, TransferCheckoutModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}

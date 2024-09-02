import '../../../../../cores/models/base_list_resp.dart';
import '../../../../../cores/models/base_resp.dart';
import '../../models/portofolio_model.dart';
import '../../models/trx_history_model.dart';

abstract class IPortofolioRemoteDataSource {
  Future<BaseListResp<TrxHistoryModel>> getTrxHistory({
    String? accessToken,
    String? refreshToken,
    int? limit,
    int? page,
    String? sortBy,
    String? orderBy,
    int? status,
    String? type,
    String? period,
    String? startDate,
    String? endDate,
  });
  Future<BaseResp<PortofolioModel>> getPortofolio({
    String? accessToken,
    String? refreshToken,
  });
}

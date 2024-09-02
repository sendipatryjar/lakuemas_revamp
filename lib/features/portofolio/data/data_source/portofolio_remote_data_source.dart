import '../../../../cores/models/base_resp.dart';

import '../../../../features/portofolio/data/models/portofolio_model.dart';

import '../../../../cores/configs/environment.dart';
import '../../../../cores/constants/api_path.dart';
import '../../../../cores/errors/error_utils.dart';
import '../../../../cores/models/base_list_resp.dart';
import '../../../../cores/services/api_service.dart';
import '../models/trx_history_model.dart';
import 'interfaces/i_portofolio_remote_data_source.dart';

class PortofolioRemoteDataSource implements IPortofolioRemoteDataSource {
  final ApiService apiService;

  PortofolioRemoteDataSource({required this.apiService});

  @override
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
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(
      apiPath: ApiPath.trxHistory,
      request: {
        ...limit != null ? {'limit': limit} : {},
        ...page != null ? {'page': page} : {},
        ...sortBy != null ? {'sort_by': 'desc'} : {},
        ...orderBy != null ? {'order_by': 'created_at'} : {},
        'type': type ?? '',
        'period': period,
        'start_date': startDate,
        'end_date': endDate,
        if (status != null) 'status': status,
      },
    );
    switch (result.statusCode) {
      case 200:
        return BaseListResp.fromJson(result.data, TrxHistoryModel.fromJson);
      default:
        return handleErrors(result);
    }
  }

  @override
  Future<BaseResp<PortofolioModel>> getPortofolio({
    String? accessToken,
    String? refreshToken,
  }) async {
    final result = await apiService
        .baseUrl(Environment.baseUrlTransaction())
        .tokenBearer(accessToken, refreshToken)
        .get(
          apiPath: ApiPath.portofolio,
        );
    switch (result.statusCode) {
      case 200:
        return BaseResp.fromJson(result.data, PortofolioModel.fromJson);
      default:
        return handleErrors(result);
    }
  }
}

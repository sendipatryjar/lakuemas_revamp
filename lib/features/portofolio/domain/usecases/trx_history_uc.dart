import 'package:dartz/dartz.dart';
import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/models/data_with_meta.dart';
import '../entities/trx_history_entity.dart';
import '../repositories/i_portofolio_repository.dart';

class TrxHistoryUc {
  final IPortofolioRepository repository;

  TrxHistoryUc({required this.repository});

  Future<Either<AppFailure, DataWithMeta<List<TrxHistoryEntity>>>> call(
          GetTrxHistory params) =>
      repository.getTrxHistory(
        limit: params.limit,
        page: params.page,
        sortBy: params.sortBy,
        orderBy: params.orderBy,
        status: params.status,
        type: params.type,
        period: params.period,
        startDate: params.startDate,
        endDate: params.endDate,
      );
}

class GetTrxHistory {
  final int? limit;
  final int? page;
  final String? sortBy;
  final String? orderBy;
  final int? status;
  final String? type;
  final String? period;
  final String? startDate;
  final String? endDate;

  const GetTrxHistory({
    this.limit,
    this.page,
    this.sortBy,
    this.orderBy,
    this.status,
    this.type,
    this.period,
    this.startDate,
    this.endDate,
  });
}

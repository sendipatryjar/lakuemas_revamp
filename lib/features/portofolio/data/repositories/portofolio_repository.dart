import 'package:dartz/dartz.dart';
import '../../../../features/portofolio/domain/entities/portofolio_entity.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/models/data_with_meta.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../domain/entities/trx_history_entity.dart';
import '../../domain/repositories/i_portofolio_repository.dart';
import '../data_source/interfaces/i_portofolio_remote_data_source.dart';

class PortofolioRepository implements IPortofolioRepository {
  final IPortofolioRemoteDataSource remoteDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  PortofolioRepository({
    required this.remoteDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, DataWithMeta<List<TrxHistoryEntity>>>>
      getTrxHistory({
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
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getTrxHistory(
          accessToken: accessToken,
          refreshToken: refreshToken,
          limit: limit,
          page: page,
          sortBy: sortBy,
          orderBy: orderBy,
          status: status,
          type: type,
          period: period,
          startDate: startDate,
          endDate: endDate,
        );
        return Right(
          DataWithMeta<List<TrxHistoryEntity>>(
            result.data ?? [],
            result.meta ?? {},
          ),
        );
      } on SessionException {
        return Left(SessionFailure());
      } on ClientException catch (e) {
        return Left(ClientFailure(
          code: e.code,
          messages: e.toString(),
          errors: e.errors,
        ));
      } on ServerException {
        return const Left(ServerFailure());
      } on UnknownException {
        return Left(UnknownFailure());
      } catch (e) {
        appPrint("[$this][getListTrx][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, PortofolioEntity>> getPortofolio() async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getPortofolio(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        return Right(result.data!);
      } on SessionException {
        return Left(SessionFailure());
      } on ClientException catch (e) {
        return Left(ClientFailure(code: e.code, messages: e.toString()));
      } on ServerException {
        return const Left(ServerFailure());
      } on UnknownException {
        return Left(UnknownFailure());
      } catch (e) {
        appPrint("[$this][getPortofolio][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

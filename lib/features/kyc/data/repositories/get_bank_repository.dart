import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../domain/entities/get_banks_entity.dart';
import '../../domain/repositories/i_get_banks_repository.dart';
import '../data_sources/interfaces/i_get_banks_remote_data_source.dart';
import '../models/get_banks_req.dart';

class GetBanksRepository implements IGetBanksRepository {
  final IGetBanksRemoteDataSource remoteDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  GetBanksRepository({
    required this.remoteDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, List<GetBanksEntity>>> bankAccount(
      {int? limit, int? page, String? sortBy}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.bankAccount(
            accessToken: accessToken,
            refreshToken: refreshToken,
            request: GetBanksReq(
              limit: limit,
              page: page,
              sortBy: sortBy,
            ));
        return Right(result.data!);
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
        appPrint("[$this][getBanks][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../domain/repositories/i_settings_repository.dart';
import '../data_sources/interfaces/i_settings_remote_data_source.dart';
import '../models/update_settings_req.dart';

class SettingsRepository implements ISettingsRepository {
  final ISettingsRemoteDataSource remoteDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  SettingsRepository({
    required this.remoteDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, bool>> updateSettings({
    required UpdateSettingsReq updateSettingsReq,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        await remoteDataSource.updateSettings(
          accessToken: accessToken,
          refreshToken: refreshToken,
          request: updateSettingsReq,
        );
        return const Right(true);
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
        appPrint("[$this][updateSettings][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

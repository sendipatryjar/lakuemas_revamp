import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../domain/repositories/i_dice_repository.dart';
import '../data_sources/interfaces/i_dice_remote_data_source.dart';

class DiceRepository implements IDiceRepository {
  final IDiceRemoteDataSource remoteDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  DiceRepository({required this.remoteDataSource, required this.tokenLocalDataSource});

  @override
  Future<Either<AppFailure, bool?>> gatcha({int? qty}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        await remoteDataSource.gatcha(
          accessToken: accessToken,
          refreshToken: refreshToken,
          qty: qty,
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
        appPrint("[$this][gatcha][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

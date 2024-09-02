import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../domain/entities/login_entity.dart';
import '../../domain/repositories/i_login_repository.dart';
import '../data_sources/interfaces/i_login_remote_data_source.dart';
import '../models/login_req.dart';

class LoginRepository implements ILoginRepository {
  final ILoginRemoteDataSource remoteDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  LoginRepository({
    required this.remoteDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, LoginEntity>> login({
    String? userName,
    String? password,
    String? firebaseToken,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        var res = await remoteDataSource.login(LoginReq(
          username: userName ?? '',
          password: password ?? '',
          firebaseToken: firebaseToken ?? '',
        ));
        await tokenLocalDataSource.saveAccessToken(res.data?.accessToken ?? '');
        await tokenLocalDataSource
            .saveRefreshToken(res.data?.refreshToken ?? '');
        return Right(res.data!);
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
        appPrint("[$this][login][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, LoginEntity>> loginPrivy({String? code}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        var res = await remoteDataSource.loginPrivy(code: code);
        await tokenLocalDataSource.saveAccessToken(res.data?.accessToken ?? '');
        await tokenLocalDataSource
            .saveRefreshToken(res.data?.refreshToken ?? '');
        return Right(res.data!);
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
        appPrint("[$this][loginPrivy][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

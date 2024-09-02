import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/models/base_resp.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../../otp/data/models/send_otp_req.dart';
import '../../../otp/data/models/verify_otp_req.dart';
import '../../domain/repositories/i_forgot_password_repository.dart';
import '../data_sources/interfaces/i_forgot_password_remote_data_source.dart';
import '../models/verify_otp_forgot_model.dart';

class ForgotPasswordRepository implements IForgotPasswordRepository {
  final IForgotPasswordRemoteDataSource remoteDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  ForgotPasswordRepository({
    required this.remoteDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, bool>> forgot(
    String newPassword,
    String confirmPassword,
  ) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        await remoteDataSource.forgot(
          accessToken,
          refreshToken,
          newPassword,
          confirmPassword,
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
        appPrint("[$this][forgot][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, bool>> sendOtpForgot({
    String? username,
    int? otpType,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        await remoteDataSource.sendOtpForgot(SendOtpReq(
          username: username ?? '',
          otpType: otpType ?? 0,
        ));

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
        appPrint("[$this][sendOtpForgot][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, BaseResp<VerifyOtpForgotModel>>> verifyOtpForgot({
    String? username,
    String? otpCode,
    int? otpType,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final result = await remoteDataSource.verifyOtpForgot(VerifyOtpReq(
          username: username ?? '',
          otpCode: otpCode ?? '',
          otpType: otpType,
        ));
        await tokenLocalDataSource
            .saveAccessToken(result.data?.accessToken ?? '');
        await tokenLocalDataSource
            .saveRefreshToken(result.data?.refreshToken ?? '');

        return Right(result);
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
        appPrint("[$this][verifyOtpForgot][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

import 'package:dartz/dartz.dart';

import '../../../../cores/constants/otp_type.dart';
import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../domain/repositories/i_otp_repository.dart';
import '../data_sources/interfaces/i_otp_remote_data_source.dart';
import '../models/send_otp_req.dart';
import '../models/verify_otp_req.dart';

class OtpRepository implements IOtpRepository {
  final IOtpRemoteDataSource remoteDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  OtpRepository({
    required this.remoteDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, bool>> sendOtp({
    String? username,
    int? otpType,
    int? otpLocation,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        if (otpLocation == OtpLocation.login) {
          await remoteDataSource.sendOtpLogin(SendOtpReq(
            username: username ?? '',
            otpType: otpType ?? 0,
          ));
        } else if (otpLocation == OtpLocation.register) {
          await remoteDataSource.sendOtpRegister(SendOtpReq(
            username: username ?? '',
            otpType: otpType ?? 0,
          ));
        } else if (otpLocation == OtpLocation.verify) {
          final accessToken = await tokenLocalDataSource.getAccessToken();
          final refreshToken = await tokenLocalDataSource.getRefreshToken();
          await remoteDataSource.sendOtpVerify(
            accessToken: accessToken,
            refreshToken: refreshToken,
            request: SendOtpReq(
              username: username ?? '',
              otpType: otpType ?? 0,
            ),
          );
        } else if (otpLocation == OtpLocation.forgotPin) {
          await remoteDataSource.sendOtpForgotPin(
            request: SendOtpReq(
              username: username ?? '',
              otpType: otpType ?? 0,
            ),
          );
        } else {
          return const Left(ClientFailure(
            code: 909,
            messages: 'otpLocation not found',
            errors: null,
          ));
        }
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
        appPrint("[$this][sendOtp][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, bool?>> verifyOtp({
    String? username,
    String? otpCode,
    int? otpLocation,
    int? otpType,
    String? privyId,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        bool? result;
        if (otpLocation == OtpLocation.login) {
          final res = await remoteDataSource.verifyOtpLogin(VerifyOtpReq(
            username: username ?? '',
            otpCode: otpCode ?? '',
            otpType: otpType,
            privyId: privyId,
          ));
          await tokenLocalDataSource
              .saveAccessToken(res.data?.accessToken ?? '');
          await tokenLocalDataSource
              .saveRefreshToken(res.data?.refreshToken ?? '');
          result = res.data?.pinStatus;
        } else if (otpLocation == OtpLocation.register) {
          final res = await remoteDataSource.verifyOtpRegister(VerifyOtpReq(
            username: username ?? '',
            otpCode: otpCode ?? '',
            otpType: otpType,
            privyId: privyId,
          ));
          if ((res.data?.accessToken ?? '').isNotEmpty) {
            await tokenLocalDataSource
                .saveAccessToken(res.data?.accessToken ?? '');
          }
          if ((res.data?.refreshToken ?? '').isNotEmpty) {
            await tokenLocalDataSource
                .saveRefreshToken(res.data?.refreshToken ?? '');
          }
        } else if (otpLocation == OtpLocation.verify) {
          final accessToken = await tokenLocalDataSource.getAccessToken();
          final refreshToken = await tokenLocalDataSource.getRefreshToken();
          await remoteDataSource.verifyOtpVerify(
            accessToken: accessToken,
            refreshToken: refreshToken,
            request: VerifyOtpReq(
              username: username ?? '',
              otpCode: otpCode ?? '',
              otpType: otpType,
            ),
          );
        } else if (otpLocation == OtpLocation.forgotPin) {
          await remoteDataSource.verifyOtpForgotPin(
            request: VerifyOtpReq(
              username: username ?? '',
              otpCode: otpCode ?? '',
              otpType: otpType,
            ),
          );
        } else {
          return const Left(ClientFailure(
            code: 909,
            messages: 'otpLocation not found',
            errors: null,
          ));
        }
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
        appPrint("[$this][verifyOtp][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

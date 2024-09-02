import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../domain/entities/pin_entity.dart';
import '../../domain/repositories/i_pin_repository.dart';
import '../data_sources/interfaces/i_pin_remote_data_source.dart';

class PinRepository implements IPinRepository {
  final IPinRemoteDataSource remoteDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  PinRepository({
    required this.remoteDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, bool>> createPin({
    String? pin,
    String? pinConfirm,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        await remoteDataSource.createPin(
          pin: pin,
          pinConfirmation: pinConfirm,
          accessToken: accessToken,
          refreshToken: refreshToken,
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
        appPrint("[$this][createPin][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, PinEntity?>> validatePin({
    String? pin,
    String? firebaseToken,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.validatePin(
          pin: pin,
          firebaseToken: firebaseToken,
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        if (result.data?.accessToken != null &&
            result.data?.refreshToken != null) {
          await tokenLocalDataSource
              .saveAccessToken(result.data?.accessToken ?? '');
          await tokenLocalDataSource
              .saveRefreshToken(result.data?.refreshToken ?? '');
        }
        return Right(result.data);
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
        appPrint("[$this][validatePin][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, bool>> forgotPin(
    String newPin,
    String confirmPin,
  ) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        await remoteDataSource.forgotPin(
          accessToken,
          refreshToken,
          newPin,
          confirmPin,
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
        appPrint("[$this][forgotPin][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  // @override
  // Future<Either<AppFailure, bool>> sendOtpForgot({
  //   String? username,
  //   int? otpType,
  // }) async {
  //   bool isConnected = true;
  //   if (isConnected == true) {
  //     try {
  //       await remoteDataSource.sendOtpForgotPin(SendOtpReq(
  //         username: username ?? '',
  //         otpType: otpType ?? 0,
  //       ));

  //       return const Right(true);
  //     } on SessionException {
  //       return Left(SessionFailure());
  //     } on ClientException catch (e) {
  //       return Left(ClientFailure(
  //         code: e.code,
  //         messages: e.toString(),
  //         errors: e.errors,
  //       ));
  //     } on ServerException {
  //       return const Left(ServerFailure());
  //     } on UnknownException {
  //       return Left(UnknownFailure());
  //     } catch (e) {
  //       appPrint("[$this][sendOtpForgotPin][catch] error: $e");
  //       return Left(UnknownFailure());
  //     }
  //   } else {
  //     return Left(OfflineFailure());
  //   }
  // }

  // @override
  // Future<Either<AppFailure, BaseResp<VerifyOtpForgotModel>>> verifyOtpForgot({
  //   String? username,
  //   String? otpCode,
  //   int? otpType,
  // }) async {
  //   bool isConnected = true;
  //   if (isConnected == true) {
  //     try {
  //       final result = await remoteDataSource.verifyOtpForgotPin(VerifyOtpReq(
  //         username: username ?? '',
  //         otpCode: otpCode ?? '',
  //         otpType: otpType,
  //       ));
  //       // await tokenLocalDataSource
  //       //     .saveAccessToken(result.data?.accessToken ?? '');
  //       // await tokenLocalDataSource
  //       //     .saveRefreshToken(result.data?.refreshToken ?? '');

  //       return Right(result);
  //     } on SessionException {
  //       return Left(SessionFailure());
  //     } on ClientException catch (e) {
  //       return Left(ClientFailure(
  //         code: e.code,
  //         messages: e.toString(),
  //         errors: e.errors,
  //       ));
  //     } on ServerException {
  //       return const Left(ServerFailure());
  //     } on UnknownException {
  //       return Left(UnknownFailure());
  //     } catch (e) {
  //       appPrint("[$this][verifyOtpForgotPin][catch] error: $e");
  //       return Left(UnknownFailure());
  //     }
  //   } else {
  //     return Left(OfflineFailure());
  //   }
  // }
}

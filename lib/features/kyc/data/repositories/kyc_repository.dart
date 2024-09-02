import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../domain/entities/kyc_entity.dart';
import '../../domain/repositories/i_kyc_repository.dart';
import '../data_sources/interfaces/i_kyc_local_data_source.dart';
import '../data_sources/interfaces/i_kyc_remote_data_source.dart';

class KycRepository implements IKycRepository {
  final IKycRemoteDataSource remoteDataSource;
  final IKycLocalDataSource localDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  KycRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, KycEntity>> getKycData(
      {bool isCallApi = false}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        KycEntity? result;
        if (isCallApi) {
          final accessToken = await tokenLocalDataSource.getAccessToken();
          final refreshToken = await tokenLocalDataSource.getRefreshToken();
          final userData = await remoteDataSource.getUserData(
            accessToken: accessToken,
            refreshToken: refreshToken,
          );
          result = userData.data?.kycEntity;
        } else {
          result = await localDataSource.getKycData();
        }
        return Right(result!);
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
        appPrint("[$this][getKycData][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, bool>> kycKtp({
    String? nik,
    String? name,
    String? pob,
    String? dob,
    List<int>? ktpPhotoBytes,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        await remoteDataSource.kycKtp(
          nik: nik,
          name: name,
          pob: pob,
          dob: dob,
          ktpPhotoBytes: ktpPhotoBytes,
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
        appPrint("[$this][kycKtp][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, bool>> kycSelfie(
      {List<int>? selfiePhotoBytes}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        await remoteDataSource.kycSelfie(
          selfiePhotoBytes: selfiePhotoBytes,
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
        appPrint("[$this][kycSelfie][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, bool>> kycNpwp(
      String npwpNo, String npwpPhotoBytes) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        await remoteDataSource.kycNpwp(
          accessToken: accessToken ?? '',
          refreshToken: refreshToken ?? '',
          npwpNo: npwpNo,
          npwpPhotoBytes: npwpPhotoBytes,
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
        appPrint("[$this][npwpVerification][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, bool>> kycSavings(
      String accountNumber, int bankId) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        await remoteDataSource.kycSavings(
          accessToken: accessToken ?? '',
          refreshToken: refreshToken ?? '',
          accountNumber: accountNumber,
          bankId: bankId,
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
        appPrint("[$this][bankAccountSavings][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, String?>> generateLivenessUrl() async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final res = await remoteDataSource.genrateLivenessUrl(
          accessToken: accessToken ?? '',
          refreshToken: refreshToken ?? '',
        );
        return Right(res.data?.userLandingUrl);
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
        appPrint("[$this][generateLivenessUrl][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

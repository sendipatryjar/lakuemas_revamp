import 'package:dartz/dartz.dart';
import '../../../../features/_core/others/domain/entities/terms_and_conditions_entity.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../../_core/user/domain/entities/user_data_entity.dart';
import '../../domain/entities/update_address_entity.dart';
import '../../domain/repositories/i_profile_repository.dart';
import '../data_sources/interfaces/i_profile_local_data_source.dart';
import '../data_sources/interfaces/i_profile_remote_data_source.dart';
import '../models/change_password_req.dart';
import '../models/change_pin_req.dart';
import '../models/update_address_req.dart';
import '../models/update_user_data_req.dart';

class ProfileRepository implements IProfileRepository {
  final IProfileRemoteDataSource remoteDataSource;
  final IProfileLocalDataSource localDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  ProfileRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, UserDataEntity?>> getUserData(
      {bool isFromLocal = false}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        if (isFromLocal) {
          final result = await localDataSource.getUserData();
          if (result != null) return Right(result);
        }
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getUserData(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        await localDataSource.saveUserData(result.data!);
        await localDataSource.saveIsElite(result.data?.isElite ?? false);
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
        final result = await localDataSource.getUserData();
        if (result != null) return Right(result);
        return const Left(ServerFailure());
      } on UnknownException {
        return Left(UnknownFailure());
      } catch (e) {
        appPrint("[$this][getUserData][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, bool>> updateUserData({
    String? fullName,
    String? gender,
    String? cob,
    String? pob,
    String? dob,
    String? maritalStatus,
    String? religion,
    String? occupation,
    String? income,
    String? purpose,
    String? email,
    String? phoneNumber,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        await remoteDataSource.updateUserData(
          accessToken: accessToken,
          refreshToken: refreshToken,
          request: UpdateUserDataReq(
            name: fullName,
            gender: gender,
            countryOfBirth: cob,
            placeOfBirth: pob,
            dateOfBirth: dob,
            maritalStatus: maritalStatus,
            religion: religion,
            occupation: occupation,
            income: income,
            purpose: purpose,
            email: email,
            phoneNumber: phoneNumber,
          ),
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
        appPrint("[$this][updateUserData][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, bool>> updateAddress({
    List<UpdateAddressEntity> addressDatas = const [],
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        await remoteDataSource.updateAddress(
          accessToken: accessToken,
          refreshToken: refreshToken,
          request: UpdateAddressReq(addressDatas),
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
        appPrint("[$this][updateAddress][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, bool>> changePassword(
      {String? oldPassword,
      String? newPassword,
      String? newPasswordConfirmation}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        await remoteDataSource.changePassword(
          accessToken: accessToken,
          refreshToken: refreshToken,
          request: ChangePasswordReq(
            oldPassword: oldPassword,
            newPassword: newPassword,
            confirmPassword: newPasswordConfirmation,
          ),
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
        appPrint("[$this][changePassword][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, bool>> changePin(
      {String? oldPin, String? newPin, String? newPinConfirmation}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        await remoteDataSource.changePin(
          accessToken: accessToken,
          refreshToken: refreshToken,
          request: ChangePinReq(
            oldPin: oldPin,
            newPin: newPin,
            confirmPin: newPinConfirmation,
          ),
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
        appPrint("[$this][changePin][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, TermsAndConditionsEntity>>
      getTermsAndConditionsProfile() async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getTermsAndConditionsProfile(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
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
        appPrint("[$this][getTermsAndConditionsProfile][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

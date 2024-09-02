import 'package:dartz/dartz.dart';

import '../../../../cores/constants/avatar_const.dart';
import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../domain/entities/avatar_user_entity.dart';
import '../../domain/repositories/i_avatar_repository.dart';
import '../data_sources/interfaces/i_avatar_local_data_source.dart';
import '../data_sources/interfaces/i_avatar_remote_data_source.dart';

class AvatarRepository implements IAvatarRepository {
  final IAvatarRemoteDataSource remoteDataSource;
  final IAvatarLocalDataSource localDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  AvatarRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, AvatarUserEntity?>> createGuestAccount() async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final localData = await localDataSource.getAvatarGuestUser();
        if (localData != null) {
          return Right(localData);
        }
        final result = await remoteDataSource.createGuestAccount();
        localDataSource.saveAvatarGuestUser(result.data);
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
        appPrint("[$this][createGuestAccount][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, String?>> guestAccountLinking(
      {String? userId}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final localData = await localDataSource.getAvatarTokenIframe();
        if (localData != null) {
          return Right(localData);
        }
        final result = await remoteDataSource.guestAccountLinking(
          userId: userId,
          partner: AvatarConst.partner,
        );
        localDataSource.saveAvatarTokenIframe(result);
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
        appPrint("[$this][guestAccountLinking][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, bool?>> saveAvatar({String? imageUrl}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        await remoteDataSource.saveAvatar(
          accessToken: accessToken,
          refreshToken: refreshToken,
          imageUrl: imageUrl,
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
        appPrint("[$this][saveAvatar][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

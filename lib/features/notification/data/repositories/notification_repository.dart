import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/models/data_with_meta.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../domain/entities/notification_adjust_entity.dart';
import '../../domain/repositories/i_notification_repository.dart';
import '../data_sources/interfaces/i_notification_remote_data_source.dart';

class NotificationRepository implements INotificationRepository {
  final INotificationRemoteDataSource remoteDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  NotificationRepository({
    required this.remoteDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, DataWithMeta<NotificationAdjustEntity?>>>
      getNotifications({
    int? limit,
    int? page,
    String? sortBy,
    String? orderBy,
    bool? isTransaction,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        var res = await remoteDataSource.getNotifications(
          accessToken: accessToken,
          refreshToken: refreshToken,
          limit: limit,
          page: page,
          sortBy: sortBy,
          orderBy: orderBy,
          isTransaction: isTransaction,
        );
        return Right(
            DataWithMeta<NotificationAdjustEntity?>(res.data, res.meta ?? {}));
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
        appPrint("[$this][getNotifications][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, bool>> makeReadNotif(int? id) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        await remoteDataSource.makeReadNotif(
          accessToken: accessToken,
          refreshToken: refreshToken,
          id: id,
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
        appPrint("[$this][makeReadNotif][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, bool>> makeReadAllNotif() async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        await remoteDataSource.makeReadAllNotif(
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
        appPrint("[$this][makeReadAllNotif][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

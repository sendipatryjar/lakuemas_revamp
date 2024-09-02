import 'package:dartz/dartz.dart';
import '../../../../features/_core/user/domain/entities/user_favorite_entity.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../domain/entities/transfer_charge_entity.dart';
import '../../domain/entities/transfer_checkout_entity.dart';
import '../../domain/repositories/i_transfer_repository.dart';
import '../data_sources/interfaces/i_transfer_local_data_source.dart';
import '../data_sources/interfaces/i_transfer_remote_data_source.dart';

class TransferRepository implements ITransferRepository {
  final ITransferRemoteDataSource remoteDataSource;
  final ITransferLocalDataSource localDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  TransferRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, TransferChargeEntity>> transferCharge({
    required bool isAddFavorite,
    required double goldWeight,
    required String accountNumber,
    String? note,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.transferCharge(
          accessToken: accessToken,
          refreshToken: refreshToken,
          isAddFavorite: isAddFavorite,
          goldWeight: goldWeight,
          accountNumber: accountNumber,
          note: note,
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
        appPrint("[$this][transferCharge][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, TransferCheckoutEntity>> transferCheckout(
      {required String transactionKey}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.transferCheckout(
          accessToken: accessToken,
          refreshToken: refreshToken,
          transactionKey: transactionKey,
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
        appPrint("[$this][transferCheckout][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, List<UserFavoriteEntity>>> userFavorites() async {
    try {
      final result = await localDataSource.getUserData();
      return Right(result?.userFavoritesEntity ?? []);
    } catch (e) {
      appPrint("[$this][userFavorites][catch] error: $e");
      return Left(UnknownFailure());
    }
  }
}

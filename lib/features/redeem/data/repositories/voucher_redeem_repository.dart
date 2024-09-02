import 'package:dartz/dartz.dart';
import '../../../../features/redeem/domain/entities/voucher_redeemed_entity.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../domain/entities/voucher_redeem_entity.dart';
import '../../domain/repositories/i_voucher_redeem_repository.dart';
import '../data_sources/interfaces/i_voucher_redeem_remote_data_source.dart';

class VoucherRedeemRepository implements IVoucherRedeemRepository {
  final IVoucherRedeemRemoteDataSource remoteDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  VoucherRedeemRepository({
    required this.remoteDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, VoucherRedeemEntity?>> check(
      {String? voucherCode}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.check(
          accessToken: accessToken,
          refreshToken: refreshToken,
          voucherCode: voucherCode,
        );
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
        appPrint("[$this][check][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, VoucherRedeemedEntity?>> redeem({
    String? voucherCode,
    double? goldRedeemed,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.redeem(
            accessToken: accessToken,
            refreshToken: refreshToken,
            voucherCode: voucherCode,
            goldRedeemed: goldRedeemed);
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
        appPrint("[$this][redeem][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

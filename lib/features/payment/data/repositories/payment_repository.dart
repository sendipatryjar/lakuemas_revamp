import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/errors/exceptions/api_exception.dart';
import '../../../../cores/services/local_data_source/i_token_local_data_source.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../../_core/user/domain/entities/balance_entity.dart';
import '../../domain/entities/detail_transaction_entity.dart';
import '../../domain/entities/payment_debet_entity.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/payment_method_entity.dart';
import '../../domain/entities/update_status_entity.dart';
import '../../domain/repositories/i_payment_repository.dart';
import '../data_sources/interfaces/i_payment_remote_data_source.dart';
import '../models/payment_debet_model.dart';
import '../models/payment_req.dart';

class PaymentRepository implements IPaymentRepository {
  final IPaymentRemoteDataSource remoteDataSource;
  final ITokenLocalDataSource tokenLocalDataSource;

  PaymentRepository({
    required this.remoteDataSource,
    required this.tokenLocalDataSource,
  });

  @override
  Future<Either<AppFailure, List<PaymentMethodEntity>>> getPaymentMethods(
      {String? actionType}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getPaymentMethods(
          accessToken: accessToken,
          refreshToken: refreshToken,
          actionType: actionType,
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
        appPrint("[$this][getPaymentMethods][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, BalanceEntity>> getAccountBalance() async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getAccountBalance(
          accessToken: accessToken,
          refreshToken: refreshToken,
        );
        final accBalance = result.data
            ?.where(
                (element) => element.type?.toLowerCase() == 'account_balance')
            .toList();
        var res = (accBalance ?? []).isNotEmpty
            ? accBalance?.first
            : const BalanceEntity();
        return Right(res!);
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
        appPrint("[$this][getPaymentMethods][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, PaymentEntity>> payment({
    required int paymentMethodId,
    required String transactionKey,
    String? jeniusCashtag,
    String? phoneNumber,
    String? couponCode,
    PaymentDebetEntity? paymentDebetEntity,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.payment(
          accessToken: accessToken,
          refreshToken: refreshToken,
          request: PaymentReq(
            paymentMethodId: paymentMethodId,
            transactionKey: transactionKey,
            jeniusCashtag: jeniusCashtag,
            couponCode: couponCode,
            phoneNumber: phoneNumber,
            paymentDebetModel: paymentDebetEntity != null
                ? PaymentDebetModel(
                    cardNumber: paymentDebetEntity.cardNumber,
                    month: paymentDebetEntity.month,
                    year: int.tryParse('20${paymentDebetEntity.year}'),
                    cvv: paymentDebetEntity.cvv,
                  )
                : null,
          ),
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
        appPrint("[$this][payment][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, DetailTransactionEntity>> getDetailTransaction(
      {required String transactionCode}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getDetailTransaction(
          accessToken: accessToken,
          refreshToken: refreshToken,
          transactionCode: transactionCode,
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
        appPrint("[$this][getDetailTransaction][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, DetailTransactionEntity>>
      getDetailTransactionWithdraw({required String transactionCode}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getDetailTransactioWithdraw(
          accessToken: accessToken,
          refreshToken: refreshToken,
          transactionCode: transactionCode,
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
        appPrint("[$this][getDetailTransactionWithdraw][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, UpdateStatusEntity>> updateStatus(
      {required String transactionCode}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.updateStatus(
          accessToken: accessToken,
          refreshToken: refreshToken,
          transactionCode: transactionCode,
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
        appPrint("[$this][updateStatus][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, DetailTransactionEntity>>
      getDetailTransactionElite({
    required String code,
  }) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.getDetailTransactionElite(
          accessToken: accessToken,
          refreshToken: refreshToken,
          code: code,
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
        appPrint("[$this][getDetailTransactionElite][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<AppFailure, String?>> cancelTransaction(
      {required String? transactionCode}) async {
    bool isConnected = true;
    if (isConnected == true) {
      try {
        final accessToken = await tokenLocalDataSource.getAccessToken();
        final refreshToken = await tokenLocalDataSource.getRefreshToken();
        final result = await remoteDataSource.cancelTransaction(
          accessToken: accessToken,
          refreshToken: refreshToken,
          transactionCode: transactionCode,
        );
        return Right(result.data?['message'] ?? '');
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
        appPrint("[$this][cancelTransaction][catch] error: $e");
        return Left(UnknownFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}

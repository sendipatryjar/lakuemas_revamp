import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/user/domain/entities/balance_entity.dart';
import '../entities/detail_transaction_entity.dart';
import '../entities/payment_debet_entity.dart';
import '../entities/payment_entity.dart';
import '../entities/payment_method_entity.dart';
import '../entities/update_status_entity.dart';

abstract class IPaymentRepository {
  Future<Either<AppFailure, List<PaymentMethodEntity>>> getPaymentMethods(
      {String? actionType});
  Future<Either<AppFailure, BalanceEntity>> getAccountBalance();
  Future<Either<AppFailure, PaymentEntity>> payment({
    required int paymentMethodId,
    required String transactionKey,
    String? jeniusCashtag,
    String? phoneNumber,
    String? couponCode,
    PaymentDebetEntity? paymentDebetEntity,
  });
  Future<Either<AppFailure, DetailTransactionEntity>> getDetailTransaction({
    required String transactionCode,
  });
  Future<Either<AppFailure, DetailTransactionEntity>>
      getDetailTransactionWithdraw({
    required String transactionCode,
  });
  Future<Either<AppFailure, DetailTransactionEntity>>
      getDetailTransactionElite({
    required String code,
  });
  Future<Either<AppFailure, UpdateStatusEntity>> updateStatus({
    required String transactionCode,
  });
  Future<Either<AppFailure, String?>> cancelTransaction({
    required String? transactionCode,
  });
}

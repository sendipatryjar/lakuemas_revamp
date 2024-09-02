import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/payment_debet_entity.dart';
import '../entities/payment_entity.dart';
import '../repositories/i_payment_repository.dart';

class PaymentUc {
  final IPaymentRepository repository;

  PaymentUc({required this.repository});

  Future<Either<AppFailure, PaymentEntity>> call(PaymentParams params) =>
      repository.payment(
        paymentMethodId: params.paymentMethodId,
        transactionKey: params.transactionKey,
        jeniusCashtag: params.jeniusCashtag,
        couponCode: params.couponCode,
        phoneNumber: params.phoneNumber,
        paymentDebetEntity: params.paymentDebetEntity,
      );
}

class PaymentParams extends Equatable {
  final int paymentMethodId;
  final String transactionKey;
  final String? jeniusCashtag;
  final String? phoneNumber;
  final String? couponCode;
  final PaymentDebetEntity? paymentDebetEntity;

  const PaymentParams({
    required this.paymentMethodId,
    required this.transactionKey,
    this.jeniusCashtag,
    this.phoneNumber,
    this.couponCode,
    this.paymentDebetEntity,
  });

  @override
  List<Object?> get props => [
        paymentMethodId,
        transactionKey,
        jeniusCashtag,
        phoneNumber,
        couponCode,
        paymentDebetEntity,
      ];
}

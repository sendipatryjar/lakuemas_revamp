import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/payment_method_entity.dart';
import '../repositories/i_payment_repository.dart';

class GetPaymentMethodsUc {
  final IPaymentRepository repository;

  GetPaymentMethodsUc({required this.repository});

  Future<Either<AppFailure, List<PaymentMethodEntity>>> call(
          String? actionType) =>
      repository.getPaymentMethods(actionType: actionType);
}

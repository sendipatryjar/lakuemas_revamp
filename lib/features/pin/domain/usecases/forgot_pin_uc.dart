import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_pin_repository.dart';

class ForgotPinUc {
  final IPinRepository repository;

  ForgotPinUc({required this.repository});

  Future<Either<AppFailure, bool>> call(String newPin, String confirmPin) =>
      repository.forgotPin(newPin, confirmPin);
}

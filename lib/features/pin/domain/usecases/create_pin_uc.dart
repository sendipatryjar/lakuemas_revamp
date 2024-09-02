import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_pin_repository.dart';

class CreatePinUc {
  final IPinRepository repository;

  CreatePinUc({required this.repository});

  Future<Either<AppFailure, bool>> call(CreatePinParams params) {
    return repository.createPin(
      pin: params.pin,
      pinConfirm: params.pinConfirm,
    );
  }
}

class CreatePinParams {
  final String pin;
  final String pinConfirm;

  CreatePinParams({required this.pin, required this.pinConfirm});
}

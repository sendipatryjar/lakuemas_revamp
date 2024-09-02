import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_profile_repository.dart';

class ChangePinUc {
  final IProfileRepository repository;

  ChangePinUc({required this.repository});

  Future<Either<AppFailure, bool>> call(ChangePinParams params) =>
      repository.changePin(
        oldPin: params.oldPin,
        newPin: params.newPin,
        newPinConfirmation: params.newPinConfirmation,
      );
}

class ChangePinParams {
  final String? oldPin;
  final String? newPin;
  final String? newPinConfirmation;

  ChangePinParams({this.oldPin, this.newPin, this.newPinConfirmation});
}

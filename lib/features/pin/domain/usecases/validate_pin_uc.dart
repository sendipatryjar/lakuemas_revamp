import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/services/firebase/firebase_messaging_service.dart';
import '../entities/pin_entity.dart';
import '../repositories/i_pin_repository.dart';

class ValidatePinUc {
  final IPinRepository repository;

  ValidatePinUc({required this.repository});

  Future<Either<AppFailure, PinEntity?>> call(String params) {
    return repository.validatePin(
      pin: params,
      firebaseToken: FirebaseMessagingService.token,
    );
  }
}

import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_register_repository.dart';

class GetPrivacyPolicyRegisterUc {
  final IRegisterRepository repository;

  GetPrivacyPolicyRegisterUc({required this.repository});

  Future<Either<AppFailure, String?>> call() =>
      repository.getPrivacyPolicyRegister();
}

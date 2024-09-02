import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/others/domain/entities/terms_and_conditions_entity.dart';
import '../entities/register_entity.dart';

abstract class IRegisterRepository {
  Future<Either<AppFailure, RegisterEntity>> register({
    required String fullName,
    required String phoneNumber,
    required String email,
    required String password,
  });
  Future<Either<AppFailure, TermsAndConditionsEntity>>
      getTermsAndConditionsRegister();
  Future<Either<AppFailure, String?>> getPrivacyPolicyRegister();
}

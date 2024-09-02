import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/others/domain/entities/terms_and_conditions_entity.dart';
import '../repositories/i_profile_repository.dart';

class GetTermsAndConditionsProfileUc {
  final IProfileRepository repository;

  GetTermsAndConditionsProfileUc({required this.repository});

  Future<Either<AppFailure, TermsAndConditionsEntity>> call() =>
      repository.getTermsAndConditionsProfile();
}

import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/support_contact_entity.dart';
import '../repositories/i_support_repository.dart';

class GetSupportContactUc {
  final ISupportRepository repository;

  GetSupportContactUc({required this.repository});

  Future<Either<AppFailure, SupportContactEntity?>> call() =>
      repository.getSupportContacts();
}

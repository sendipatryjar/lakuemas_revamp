import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/support_contact_entity.dart';
import '../entities/support_faq_entity.dart';

abstract class ISupportRepository {
  Future<Either<AppFailure, List<SupportFaqEntity>>> getFaq({String? keyword});
  Future<Either<AppFailure, SupportContactEntity?>> getSupportContacts();
}

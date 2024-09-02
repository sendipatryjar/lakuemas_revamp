import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/support_faq_entity.dart';
import '../repositories/i_support_repository.dart';

class GetFaqSupportUc {
  final ISupportRepository repository;

  GetFaqSupportUc({required this.repository});

  Future<Either<AppFailure, List<SupportFaqEntity>>> call({String? keyword}) =>
      repository.getFaq(keyword: keyword);
}

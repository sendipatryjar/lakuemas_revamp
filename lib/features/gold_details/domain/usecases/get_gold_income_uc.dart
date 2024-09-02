import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/gold_income_entity.dart';
import '../respositories/i_gold_details_repository.dart';

class GetGoldIncomeUc {
  final IGoldDetailsRepository repository;

  GetGoldIncomeUc({required this.repository});

  Future<Either<AppFailure, GoldIncomeEntity>> call() =>
      repository.getGoldIncome();
}

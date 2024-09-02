import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/get_banks_entity.dart';
import '../repositories/i_get_banks_repository.dart';

class GetBanksUc {
  final IGetBanksRepository repository;

  GetBanksUc({required this.repository});

  Future<Either<AppFailure, List<GetBanksEntity>>> call(
      BankAccountParams params) {
    return repository.bankAccount(
      limit: params.limit,
      page: params.page,
      sortBy: params.sortBy,
    );
  }
}

class BankAccountParams {
  final int? limit;
  final int? page;
  final String? sortBy;

  BankAccountParams({this.limit, this.page, this.sortBy});
}

import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/gold_deposit_entity.dart';
import '../repositories/i_lakusave_repoisitory.dart';

class GetMasterDataLakusaveUc {
  final ILakusaveRepository repository;

  GetMasterDataLakusaveUc({required this.repository});

  Future<Either<AppFailure, GoldDepositEntity>> call() =>
      repository.getMasterData();
}

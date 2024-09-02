import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/user/domain/entities/balance_entity.dart';

abstract class IQRTransferRepository {
  Future<Either<AppFailure, List<BalanceEntity>>> getBalances();
}

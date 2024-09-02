import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';

abstract class ICloseAccountRepository {
  Future<Either<AppFailure, bool>> submit(String reason);
}

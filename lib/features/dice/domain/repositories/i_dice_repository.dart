import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';

abstract class IDiceRepository {
  Future<Either<AppFailure, bool?>> gatcha({
    int? qty,
  });
}

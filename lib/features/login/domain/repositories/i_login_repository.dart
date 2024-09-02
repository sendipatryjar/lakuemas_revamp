import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/login_entity.dart';

abstract class ILoginRepository {
  Future<Either<AppFailure, LoginEntity>> login({
    String? userName,
    String? password,
    String? firebaseToken,
  });
  Future<Either<AppFailure, LoginEntity>> loginPrivy({String? code});
}

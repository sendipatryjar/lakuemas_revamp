import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/login_entity.dart';
import '../repositories/i_login_repository.dart';

class LoginPrivyUc {
  final ILoginRepository repo;

  LoginPrivyUc({required this.repo});

  Future<Either<AppFailure, LoginEntity>> call({String? code}) {
    return repo.loginPrivy(code: code);
  }
}

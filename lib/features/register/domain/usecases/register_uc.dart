import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/register_entity.dart';
import '../repositories/i_register_repository.dart';

class RegisterUc {
  final IRegisterRepository repo;

  RegisterUc({required this.repo});

  Future<Either<AppFailure, RegisterEntity>> call(RegisterParams params) {
    return repo.register(
      fullName: params.fullName,
      phoneNumber: params.phoneNumber,
      email: params.email,
      password: params.password,
    );
  }
}

class RegisterParams {
  String fullName;
  String phoneNumber;
  String email;
  String password;

  RegisterParams({
    required this.fullName,
    required this.phoneNumber,
    required this.email,
    required this.password,
  });
}

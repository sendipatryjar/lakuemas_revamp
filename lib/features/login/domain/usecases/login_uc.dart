import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/services/firebase/firebase_messaging_service.dart';
import '../entities/login_entity.dart';
import '../repositories/i_login_repository.dart';

class LoginUc {
  final ILoginRepository repo;

  LoginUc({required this.repo});

  Future<Either<AppFailure, LoginEntity>> call(LoginParams params) {
    return repo.login(
      userName: params.userName,
      password: params.password,
      firebaseToken: FirebaseMessagingService.token,
    );
  }
}

class LoginParams {
  String userName;
  String password;

  LoginParams({
    required this.userName,
    required this.password,
  });
}

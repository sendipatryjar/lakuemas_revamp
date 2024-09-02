import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_forgot_password_repository.dart';

class ForgotPasswordUc {
  final IForgotPasswordRepository repository;

  ForgotPasswordUc({required this.repository});

  Future<Either<AppFailure, bool>> call(
          String newPassword, String confirmPassword) =>
      repository.forgot(newPassword, confirmPassword);
}

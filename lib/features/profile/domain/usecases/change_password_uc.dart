import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_profile_repository.dart';

class ChangePasswordUc {
  final IProfileRepository repository;

  ChangePasswordUc({required this.repository});

  Future<Either<AppFailure, bool>> call(ChangePasswordParams params) =>
      repository.changePassword(
        oldPassword: params.oldPassword,
        newPassword: params.newPassword,
        newPasswordConfirmation: params.newPasswordConfirmation,
      );
}

class ChangePasswordParams {
  final String? oldPassword;
  final String? newPassword;
  final String? newPasswordConfirmation;

  ChangePasswordParams(
      {this.oldPassword, this.newPassword, this.newPasswordConfirmation});
}

import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/avatar_user_entity.dart';
import '../repositories/i_avatar_repository.dart';

class CreateGuestAccountUc {
  final IAvatarRepository repository;

  CreateGuestAccountUc({required this.repository});

  Future<Either<AppFailure, AvatarUserEntity?>> call() =>
      repository.createGuestAccount();
}

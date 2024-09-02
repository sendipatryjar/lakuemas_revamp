import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/avatar_user_entity.dart';

abstract class IAvatarRepository {
  Future<Either<AppFailure, AvatarUserEntity?>> createGuestAccount();

  /// return token for iframe
  Future<Either<AppFailure, String?>> guestAccountLinking({
    String? userId,
  });

  /// return token for iframe
  Future<Either<AppFailure, bool?>> saveAvatar({
    String? imageUrl,
  });
}

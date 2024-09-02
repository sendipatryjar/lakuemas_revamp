import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_avatar_repository.dart';

class GuestAccountLinkingUc {
  final IAvatarRepository repository;

  GuestAccountLinkingUc({required this.repository});

  Future<Either<AppFailure, String?>> call({String? userId}) =>
      repository.guestAccountLinking(userId: userId);
}

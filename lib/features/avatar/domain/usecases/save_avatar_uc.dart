import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_avatar_repository.dart';

class SaveAvatarUc {
  final IAvatarRepository repository;

  SaveAvatarUc({required this.repository});

  Future<Either<AppFailure, bool?>> call({String? imageUrl}) =>
      repository.saveAvatar(imageUrl: imageUrl);
}

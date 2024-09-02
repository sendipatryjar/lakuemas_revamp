import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/user/domain/entities/user_favorite_entity.dart';
import '../repositories/i_transfer_repository.dart';

class GetUserFavoritesUc {
  final ITransferRepository repository;

  GetUserFavoritesUc({required this.repository});

  Future<Either<AppFailure, List<UserFavoriteEntity>>> call() =>
      repository.userFavorites();
}

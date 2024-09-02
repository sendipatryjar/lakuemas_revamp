import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/social_media_config_entity.dart';
import '../repositories/i_elite_repository.dart';

class GetSocialMediaConfigUc {
  final IEliteRepository repository;

  const GetSocialMediaConfigUc({required this.repository});

  Future<Either<AppFailure, SocialMediaConfigEntity>> call() {
    return repository.getSocialMediaConfig();
  }
}

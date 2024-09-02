import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/user/domain/entities/user_data_entity.dart';
import '../repositories/i_profile_repository.dart';

class GetUserDataUc {
  final IProfileRepository repository;

  GetUserDataUc({required this.repository});

  Future<Either<AppFailure, UserDataEntity?>> call(
          {bool isFromLocal = false}) =>
      repository.getUserData(isFromLocal: isFromLocal);
}

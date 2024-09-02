import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../data/models/update_settings_req.dart';
import '../repositories/i_settings_repository.dart';

class UpdateSettingsUc {
  final ISettingsRepository repository;

  UpdateSettingsUc({required this.repository});

  Future<Either<AppFailure, bool>> call(UpdateSettingsParams params) => repository.updateSettings(
        updateSettingsReq: params,
      );
}

class UpdateSettingsParams extends UpdateSettingsReq {
  const UpdateSettingsParams({
    required bool withPrice,
    required bool withPromo,
  }) : super(withPrice: withPrice, withPromo: withPromo);
}

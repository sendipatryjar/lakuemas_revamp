import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../data/models/update_settings_req.dart';

abstract class ISettingsRepository {
  Future<Either<AppFailure, bool>> updateSettings({
    required UpdateSettingsReq updateSettingsReq,
  });
}

import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../entities/update_address_entity.dart';
import '../repositories/i_profile_repository.dart';

class UpdateAddressUc {
  final IProfileRepository repository;

  UpdateAddressUc({required this.repository});

  Future<Either<AppFailure, bool>> call(List<UpdateAddressEntity> params) {
    return repository.updateAddress(addressDatas: params);
  }
}

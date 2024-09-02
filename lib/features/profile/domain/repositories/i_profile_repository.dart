import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../../../_core/others/domain/entities/terms_and_conditions_entity.dart';
import '../../../_core/user/domain/entities/user_data_entity.dart';
import '../entities/update_address_entity.dart';

abstract class IProfileRepository {
  Future<Either<AppFailure, UserDataEntity?>> getUserData(
      {bool isFromLocal = false});
  Future<Either<AppFailure, bool>> updateUserData({
    String? fullName,
    String? gender,
    String? cob,
    String? pob,
    String? dob,
    String? maritalStatus,
    String? religion,
    String? occupation,
    String? income,
    String? purpose,
    String? email,
    String? phoneNumber,
  });
  Future<Either<AppFailure, bool>> updateAddress({
    List<UpdateAddressEntity> addressDatas,
  });
  Future<Either<AppFailure, bool>> changePassword({
    String? oldPassword,
    String? newPassword,
    String? newPasswordConfirmation,
  });
  Future<Either<AppFailure, bool>> changePin({
    String? oldPin,
    String? newPin,
    String? newPinConfirmation,
  });
  Future<Either<AppFailure, TermsAndConditionsEntity>>
      getTermsAndConditionsProfile();
}

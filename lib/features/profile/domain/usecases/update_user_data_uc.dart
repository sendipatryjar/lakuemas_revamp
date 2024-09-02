import 'package:dartz/dartz.dart';

import '../../../../cores/errors/app_failure.dart';
import '../repositories/i_profile_repository.dart';

class UpdateUserDataUc {
  final IProfileRepository repository;

  UpdateUserDataUc({required this.repository});

  Future<Either<AppFailure, bool>> call(UpdateUserDataParams params) =>
      repository.updateUserData(
        fullName: params.fullName,
        gender: params.gender,
        cob: params.countryOfBirth,
        pob: params.placeOfBirth,
        dob: params.dateOfBirth,
        maritalStatus: params.maritalStatus,
        religion: params.religion,
        occupation: params.occupation,
        income: params.income,
        purpose: params.purpose,
        email: params.email,
        phoneNumber: params.phoneNumber,
      );
}

class UpdateUserDataParams {
  final String? fullName;
  final String? gender;
  final String? countryOfBirth;
  final String? placeOfBirth;
  final String? dateOfBirth;
  final String? maritalStatus;
  final String? religion;
  final String? occupation;
  final String? income;
  final String? purpose;
  final String? email;
  final String? phoneNumber;

  UpdateUserDataParams({
    this.fullName,
    this.gender,
    this.countryOfBirth,
    this.placeOfBirth,
    this.dateOfBirth,
    this.maritalStatus,
    this.religion,
    this.occupation,
    this.income,
    this.purpose,
    this.email,
    this.phoneNumber,
  });
}

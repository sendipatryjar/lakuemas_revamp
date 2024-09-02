import 'package:equatable/equatable.dart';

class UpdateUserDataReq extends Equatable {
  final String? name;
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

  const UpdateUserDataReq({
    this.name,
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

  factory UpdateUserDataReq.fromJson(Map<String, dynamic> json) {
    return UpdateUserDataReq(
      name: json['name'],
      gender: json['gender'],
      countryOfBirth: json['country_of_birth'],
      placeOfBirth: json['place_of_birth'],
      dateOfBirth: json['date_of_birth'],
      maritalStatus: json['marital_status'],
      religion: json['religion'],
      occupation: json['occupation'],
      income: json['income'],
      purpose: json['purpose'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if ((name ?? '').isNotEmpty) data['name'] = name;
    if ((gender ?? '').isNotEmpty) data['gender'] = gender;
    if ((countryOfBirth ?? '').isNotEmpty) {
      data['country_of_birth'] = countryOfBirth;
    }
    if ((placeOfBirth ?? '').isNotEmpty) {
      data['place_of_birth'] = placeOfBirth;
    }
    if ((dateOfBirth ?? '').isNotEmpty) {
      data['date_of_birth'] = dateOfBirth;
    }
    if ((maritalStatus ?? '').isNotEmpty) {
      data['marital_status'] = maritalStatus;
    }
    if ((religion ?? '').isNotEmpty) {
      data['religion'] = religion;
    }
    if ((occupation ?? '').isNotEmpty) {
      data['occupation'] = occupation;
    }
    if ((income ?? '').isNotEmpty) data['income'] = income;
    if ((purpose ?? '').isNotEmpty) data['purpose'] = purpose;
    if ((email ?? '').isNotEmpty) data['email'] = email;
    if ((phoneNumber ?? '').isNotEmpty) {
      data['phone_number'] = phoneNumber;
    }
    return data;
  }

  @override
  List<Object?> get props => [
        name,
        gender,
        placeOfBirth,
        dateOfBirth,
        maritalStatus,
        religion,
        occupation,
        income,
        purpose,
        email,
        phoneNumber,
      ];
}

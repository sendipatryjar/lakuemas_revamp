part of 'profile_update_bloc.dart';

abstract class ProfileUpdateEvent extends Equatable {
  const ProfileUpdateEvent();

  @override
  List<Object> get props => [];
}

class SelfDataUpdatePressed extends ProfileUpdateEvent {
  final String? fullName;
  final String? gender;
  final String? cob;
  final String? pob;
  final String? dob;
  final String? maritalStatus;
  final String? religion;

  const SelfDataUpdatePressed({
    required this.fullName,
    required this.gender,
    required this.cob,
    required this.pob,
    required this.dob,
    required this.maritalStatus,
    required this.religion,
  });

  @override
  List<Object> get props => [
        [fullName, gender, cob, pob, dob, maritalStatus, religion]
      ];
}

class IncomeDataUpdatePressed extends ProfileUpdateEvent {
  final String? occupation;
  final String? income;
  final String? purpose;

  const IncomeDataUpdatePressed({
    required this.occupation,
    required this.income,
    required this.purpose,
  });

  @override
  List<Object> get props => [
        [
          occupation,
          income,
          purpose,
        ]
      ];
}

class PhoneNumberUpdatePressed extends ProfileUpdateEvent {
  final String? phoneNumber;

  const PhoneNumberUpdatePressed({
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [
        [phoneNumber]
      ];
}

class EmailUpdatePressed extends ProfileUpdateEvent {
  final String? email;

  const EmailUpdatePressed({
    required this.email,
  });

  @override
  List<Object> get props => [
        [email]
      ];
}

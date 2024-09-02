part of 'self_data_update_cubit.dart';

class SelfDataUpdateState extends Equatable {
  final UserDataEntity? userDataEntity;
  final String? fullName;
  final String? gender;
  final String? cob;
  final String? pob;
  final String? dob;
  final String? maritalStatus;
  final String? religion;
  //
  final bool? isNameError;
  final String? isNameErrorMessage;
  final bool? isPobError;
  final String? isPobErrorMessage;
  //
  final String? genderErrorMessage;
  final String? dobErrorMessage;
  final String? maritalErrorMessage;
  final String? religionErrorMessage;

  const SelfDataUpdateState({
    this.userDataEntity,
    this.fullName,
    this.gender,
    this.cob,
    this.pob,
    this.dob,
    this.maritalStatus,
    this.religion,
    //
    this.isNameError,
    this.isNameErrorMessage,
    this.isPobError,
    this.isPobErrorMessage,
    //
    this.genderErrorMessage,
    this.dobErrorMessage,
    this.maritalErrorMessage,
    this.religionErrorMessage,
  });

  SelfDataUpdateState copyWith({
    UserDataEntity? userDataEntity,
    String? fullName,
    String? gender,
    String? cob,
    String? pob,
    String? dob,
    String? maritalStatus,
    String? religion,
    //
    bool? isNameError,
    String? isNameErrorMessage,
    bool? isPobError,
    String? isPobErrorMessage,
    //
    String? genderErrorMessage,
    String? dobErrorMessage,
    String? maritalErrorMessage,
    String? religionErrorMessage,
  }) =>
      SelfDataUpdateState(
        userDataEntity: userDataEntity ?? this.userDataEntity,
        fullName: fullName ?? this.fullName,
        gender: gender ?? this.gender,
        cob: cob ?? this.cob,
        pob: pob ?? this.pob,
        dob: dob ?? this.dob,
        maritalStatus: maritalStatus ?? this.maritalStatus,
        religion: religion ?? this.religion,
        //
        isNameError: isNameError ?? this.isNameError,
        isNameErrorMessage: isNameErrorMessage ?? this.isNameErrorMessage,
        isPobError: isPobError ?? this.isPobError,
        isPobErrorMessage: isPobErrorMessage ?? this.isPobErrorMessage,
        //
        genderErrorMessage: genderErrorMessage ?? this.genderErrorMessage,
        dobErrorMessage: dobErrorMessage ?? this.dobErrorMessage,
        maritalErrorMessage: maritalErrorMessage ?? this.maritalErrorMessage,
        religionErrorMessage: religionErrorMessage ?? this.religionErrorMessage,
      );

  @override
  List<Object> get props => [
        [
          userDataEntity,
          fullName,
          gender,
          cob,
          pob,
          dob,
          maritalStatus,
          religion,
          //
          isNameError,
          isNameErrorMessage,
          isPobError,
          isPobErrorMessage,
          //
          genderErrorMessage,
          dobErrorMessage,
          maritalErrorMessage,
          religionErrorMessage,
        ]
      ];
}

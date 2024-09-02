part of 'change_obsecure_cubit.dart';

class ChangeObsecureState extends Equatable {
  final bool isOldPassword;
  final bool isNewPassword;
  final bool isConfirmPassword;

  const ChangeObsecureState({
    this.isOldPassword = true,
    this.isNewPassword = true,
    this.isConfirmPassword = true,
  });

  ChangeObsecureState copyWith({
    bool? isOldPassword,
    bool? isNewPassword,
    bool? isConfirmPassword,
  }) =>
      ChangeObsecureState(
        isOldPassword: isOldPassword ?? this.isOldPassword,
        isNewPassword: isNewPassword ?? this.isNewPassword,
        isConfirmPassword: isConfirmPassword ?? this.isConfirmPassword,
      );

  @override
  List<Object> get props => [
        isOldPassword,
        isNewPassword,
        isConfirmPassword,
      ];
}

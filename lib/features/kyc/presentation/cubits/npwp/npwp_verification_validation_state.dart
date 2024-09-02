part of 'npwp_verification_validation_cubit.dart';

class NpwpVerificationValidationState extends Equatable {
  final bool? isNpwpError;
  final String? npwpErrorMessages;
  final bool? isNpwpPhotoError;
  final String? npwpPhotoErrorMessages;

  const NpwpVerificationValidationState({
    this.isNpwpError,
    this.npwpErrorMessages,
    this.isNpwpPhotoError,
    this.npwpPhotoErrorMessages,
  });

  NpwpVerificationValidationState copyWith({
    bool? isNpwpError,
    String? npwpErrorMessages,
    bool? isNpwpPhotoError,
    String? npwpPhotoErrorMessages,
  }) =>
      NpwpVerificationValidationState(
        isNpwpError: isNpwpError ?? this.isNpwpError,
        npwpErrorMessages: npwpErrorMessages ?? this.npwpErrorMessages,
        isNpwpPhotoError: isNpwpPhotoError ?? this.isNpwpPhotoError,
        npwpPhotoErrorMessages:
            npwpPhotoErrorMessages ?? this.npwpPhotoErrorMessages,
      );

  @override
  List<Object> get props => [
        [
          isNpwpError,
          npwpErrorMessages,
          isNpwpPhotoError,
          npwpPhotoErrorMessages,
        ]
      ];
}

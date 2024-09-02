part of 'otp_validation_cubit.dart';

class OtpValidationState extends Equatable {
  final bool? isError;
  final String? errorMessages;

  const OtpValidationState({
    this.isError = false,
    this.errorMessages,
  });

  OtpValidationState copyWith({
    bool? isError,
    String? errorMessages,
  }) =>
      OtpValidationState(
        isError: isError ?? this.isError,
        errorMessages: errorMessages ?? this.errorMessages,
      );

  @override
  List<Object> get props => [
        [isError, errorMessages]
      ];
}

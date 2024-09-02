part of 'ktp_validation_cubit.dart';

class KtpValidationState extends Equatable {
  final bool? isNikError;
  final String? nikErrorMessages;
  final bool? isNameError;
  final String? nameErrorMessages;
  final bool? isPobError;
  final String? pobErrorMessages;
  final bool? isDobError;
  final String? dobErrorMessages;
  final bool? isKtpPhotoError;
  final String? ktpPhotoErrorMessages;

  //
  final String? ttl;

  const KtpValidationState({
    this.isNikError,
    this.nikErrorMessages,
    this.isNameError,
    this.nameErrorMessages,
    this.isPobError,
    this.pobErrorMessages,
    this.isDobError,
    this.dobErrorMessages,
    this.isKtpPhotoError,
    this.ktpPhotoErrorMessages,

    //
    this.ttl,
  });

  KtpValidationState copyWith({
    bool? isNikError,
    String? nikErrorMessages,
    bool nullifyNikErrorMessages = false,
    bool? isNameError,
    String? nameErrorMessages,
    bool nullifyNameErrorMessages = false,
    bool? isPobError,
    String? pobErrorMessages,
    bool nullifyPobErrorMessages = false,
    bool? isDobError,
    String? dobErrorMessages,
    bool nullifyDobErrorMessages = false,
    bool? isKtpPhotoError,
    String? ktpPhotoErrorMessages,
    bool nullifyKtpPhotoErrorMessages = false,
    //
    String? ttl,
    bool nullifyTtl = false,
  }) =>
      KtpValidationState(
          isNikError: isNikError ?? this.isNikError,
          nikErrorMessages: nullifyNikErrorMessages
              ? null
              : (nikErrorMessages ?? this.nikErrorMessages),
          isNameError: isNameError ?? this.isNameError,
          nameErrorMessages: nullifyNameErrorMessages
              ? null
              : (nameErrorMessages ?? this.nameErrorMessages),
          isPobError: isPobError ?? this.isPobError,
          pobErrorMessages: nullifyPobErrorMessages
              ? null
              : (pobErrorMessages ?? this.pobErrorMessages),
          isDobError: isDobError ?? this.isDobError,
          dobErrorMessages: nullifyDobErrorMessages
              ? null
              : (dobErrorMessages ?? this.dobErrorMessages),
          isKtpPhotoError: isKtpPhotoError ?? this.isKtpPhotoError,
          ktpPhotoErrorMessages: nullifyKtpPhotoErrorMessages
              ? null
              : (ktpPhotoErrorMessages ?? this.ktpPhotoErrorMessages),
          ttl: nullifyTtl ? null : (ttl ?? this.ttl));

  @override
  List<Object> get props => [
        [
          isNikError,
          nikErrorMessages,
          isNameError,
          nameErrorMessages,
          isPobError,
          pobErrorMessages,
          isDobError,
          dobErrorMessages,
          isKtpPhotoError,
          ktpPhotoErrorMessages,
          ttl,
        ]
      ];
}

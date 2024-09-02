part of 'kyc_ktp_bloc.dart';

abstract class KycKtpState extends Equatable {
  const KycKtpState();
}

class KycKtpInitial extends KycKtpState {
  @override
  List<Object?> get props => [];
}

class KycKtpLoadingState extends KycKtpState {
  @override
  List<Object?> get props => [];
}

class KycKtpSuccessState extends KycKtpState {
  const KycKtpSuccessState();

  @override
  List<Object> get props => [];
}

class KycKtpFailureValidateState extends KycKtpState {
  final String? message;
  const KycKtpFailureValidateState(this.message);

  @override
  List<Object> get props => [
        [message]
      ];
}

class KycKtpFailureState extends KycKtpState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const KycKtpFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

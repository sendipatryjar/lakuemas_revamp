part of 'kyc_selfie_bloc.dart';

abstract class KycSelfieState extends Equatable {
  const KycSelfieState();
}

class KycSelfieInitial extends KycSelfieState {
  @override
  List<Object> get props => [];
}

class KycSelfieLoadingState extends KycSelfieState {
  @override
  List<Object?> get props => [];
}

class KycSelfieSuccessState extends KycSelfieState {
  const KycSelfieSuccessState();

  @override
  List<Object> get props => [];
}

class KycSelfieFailureState extends KycSelfieState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const KycSelfieFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

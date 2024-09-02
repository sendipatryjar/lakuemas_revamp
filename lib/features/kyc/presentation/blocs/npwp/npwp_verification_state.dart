part of 'npwp_verification_bloc.dart';

abstract class NpwpVerificationState extends Equatable {
  const NpwpVerificationState();

  @override
  List<Object> get props => [];
}

class NpwpVerificationInitialState extends NpwpVerificationState {}

class NpwpVerificationLoadingState extends NpwpVerificationState {}

class NpwpVerificationSuccessState extends NpwpVerificationState {}

class NpwpVerificationFailureState extends NpwpVerificationState {
  final int? code;
  final String? message;

  const NpwpVerificationFailureState(this.code, this.message);

  @override
  List<Object> get props => [
        [code, message]
      ];
}

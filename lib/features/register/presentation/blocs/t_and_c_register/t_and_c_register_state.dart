part of 't_and_c_register_bloc.dart';

sealed class TAndCRegisterState extends Equatable {
  const TAndCRegisterState();

  @override
  List<Object> get props => [];
}

class TAndCRegisterInitialState extends TAndCRegisterState {}

class TAndCRegisterLoadingState extends TAndCRegisterState {}

class TAndCRegisterSuccessState extends TAndCRegisterState {
  final TermsAndConditionsEntity tAndCRegister;

  const TAndCRegisterSuccessState({
    required this.tAndCRegister,
  });

  @override
  List<Object> get props => [
        tAndCRegister,
      ];
}

class TAndCRegisterFailureState extends TAndCRegisterState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const TAndCRegisterFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

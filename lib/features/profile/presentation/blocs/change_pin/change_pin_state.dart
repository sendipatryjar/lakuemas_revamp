part of 'change_pin_bloc.dart';

abstract class ChangePinState extends Equatable {
  const ChangePinState();

  @override
  List<Object> get props => [];
}

class ChangePinInitialState extends ChangePinState {}

class ChangePinLoadingState extends ChangePinState {}

class ChangePinSuccessState extends ChangePinState {}

class ChangePinFailureState extends ChangePinState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const ChangePinFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

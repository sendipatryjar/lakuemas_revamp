part of 'pin_bloc.dart';

abstract class PinState extends Equatable {
  const PinState();

  @override
  List<Object> get props => [];
}

class PinInitialState extends PinState {}

class PinLoadingState extends PinState {}

class PinSuccessState extends PinState {}

class PinFailureState extends PinState {
  final AppFailure? appFailure;
  final int? code;
  final String? message;
  final Map<String, dynamic>? errors;

  const PinFailureState(this.appFailure, this.code, this.message, this.errors);

  @override
  List<Object> get props => [
        [appFailure, code, message, errors]
      ];
}

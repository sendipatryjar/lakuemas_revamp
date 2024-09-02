part of 'forgot_pin_bloc.dart';

sealed class ForgotPinState extends Equatable {
  const ForgotPinState();

  @override
  List<Object> get props => [];
}

final class ForgotPinInitialState extends ForgotPinState {}

final class ForgotPinLoadingState extends ForgotPinState {}

final class ForgotPinSuccessState extends ForgotPinState {}

final class ForgotPinFailureState extends ForgotPinState {
  final AppFailure? appFailure;
  final int? code;
  final String? message;

  const ForgotPinFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

part of 'forgot_pin_bloc.dart';

sealed class ForgotPinEvent extends Equatable {
  const ForgotPinEvent();

  @override
  List<Object> get props => [];
}

class ForgotPinPressedEvent extends ForgotPinEvent {
  final String newPin;
  final String confirmPin;

  const ForgotPinPressedEvent(
    this.newPin,
    this.confirmPin,
  );

  @override
  List<Object> get props => [newPin, confirmPin];
}

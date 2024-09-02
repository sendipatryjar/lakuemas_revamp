part of 'pin_bloc.dart';

abstract class PinEvent extends Equatable {
  const PinEvent();

  @override
  List<Object> get props => [];
}

class PinCreateSubmitEvent extends PinEvent {
  final String pin;
  final String pinConfirmation;

  const PinCreateSubmitEvent({
    required this.pin,
    required this.pinConfirmation,
  });

  @override
  List<Object> get props => [
        pin,
        pinConfirmation,
      ];
}

class PinValidateEvent extends PinEvent {
  final String pin;

  const PinValidateEvent({required this.pin});

  @override
  List<Object> get props => [pin];
}

class PinInitialFromErrorEvent extends PinEvent {}

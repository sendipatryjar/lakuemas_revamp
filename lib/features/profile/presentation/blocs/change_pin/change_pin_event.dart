part of 'change_pin_bloc.dart';

abstract class ChangePinEvent extends Equatable {
  const ChangePinEvent();

  @override
  List<Object> get props => [];
}

class ChangePinPressed extends ChangePinEvent {
  final String? oldPin;
  final String? newPin;
  final String? newPinConfirmation;

  const ChangePinPressed({
    this.oldPin,
    this.newPin,
    this.newPinConfirmation,
  });

  @override
  List<Object> get props => [
        [oldPin, newPin, newPinConfirmation]
      ];
}

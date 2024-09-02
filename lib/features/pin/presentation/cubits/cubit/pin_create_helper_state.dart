part of 'pin_create_helper_cubit.dart';

class PinCreateHelperState extends Equatable {
  final String pin;
  final String pinConfirmation;
  final int pinType;

  const PinCreateHelperState({
    required this.pin,
    required this.pinConfirmation,
    required this.pinType,
  });

  PinCreateHelperState copyWith({
    String? pin,
    String? pinConfirmation,
    int? pinType,
  }) =>
      PinCreateHelperState(
        pin: pin ?? this.pin,
        pinConfirmation: pinConfirmation ?? this.pinConfirmation,
        pinType: pinType ?? this.pinType,
      );

  @override
  List<Object> get props => [pin, pinConfirmation, pinType];
}

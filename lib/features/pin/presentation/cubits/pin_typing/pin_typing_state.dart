part of 'pin_typing_cubit.dart';

enum PinStateEn { typed, submited }

class PinTypingState extends Equatable {
  final PinStateEn pinStateEn;
  final String pin;
  const PinTypingState({required this.pinStateEn, required this.pin});

  PinTypingState copyWith({
    PinStateEn? pinStateEn,
    String? pin,
  }) =>
      PinTypingState(
        pinStateEn: pinStateEn ?? this.pinStateEn,
        pin: pin ?? this.pin,
      );

  @override
  List<Object> get props => [pinStateEn, pin];
}

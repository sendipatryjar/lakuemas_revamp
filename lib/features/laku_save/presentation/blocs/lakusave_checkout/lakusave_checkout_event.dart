part of 'lakusave_checkout_bloc.dart';

abstract class LakusaveCheckoutEvent extends Equatable {
  const LakusaveCheckoutEvent();

  @override
  List<Object> get props => [];
}

class LakusaveCheckoutDoNowEvent extends LakusaveCheckoutEvent {
  final int? durationId;
  final int? extendedId;
  final double? goldWeight;
  final String? accountNumber;
  final String? accountNumberDest;

  const LakusaveCheckoutDoNowEvent({
    required this.durationId,
    required this.extendedId,
    required this.goldWeight,
    required this.accountNumber,
    required this.accountNumberDest,
  });

  @override
  List<Object> get props => [
        [durationId, extendedId, goldWeight, accountNumber, accountNumberDest]
      ];
}

class LakusaveCheckoutInitEvent extends LakusaveCheckoutEvent {}

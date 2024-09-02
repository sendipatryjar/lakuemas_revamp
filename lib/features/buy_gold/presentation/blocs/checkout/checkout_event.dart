part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class CheckoutNowEvent extends CheckoutEvent {
  final double? amount;
  final String? amountType;

  const CheckoutNowEvent(this.amount, this.amountType);

  @override
  List<Object> get props => [
        [amount, amountType]
      ];
}

part of 'sell_gold_checkout_bloc.dart';

abstract class SellGoldCheckoutEvent extends Equatable {
  const SellGoldCheckoutEvent();

  @override
  List<Object> get props => [];
}

class SellGoldCheckoutNowEvent extends SellGoldCheckoutEvent {
  final double? amount;
  final String? amountType;

  const SellGoldCheckoutNowEvent(this.amount, this.amountType);

  @override
  List<Object> get props => [
        [amount, amountType]
      ];
}

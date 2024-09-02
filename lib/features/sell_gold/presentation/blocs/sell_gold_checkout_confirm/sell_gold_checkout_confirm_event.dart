part of 'sell_gold_checkout_confirm_bloc.dart';

abstract class SellGoldCheckoutConfirmEvent extends Equatable {
  const SellGoldCheckoutConfirmEvent();

  @override
  List<Object> get props => [];
}

class SellGoldCheckoutConfirmNowEvent extends SellGoldCheckoutConfirmEvent {
  final String transactionKey;

  const SellGoldCheckoutConfirmNowEvent(this.transactionKey);

  @override
  List<Object> get props => [transactionKey];
}

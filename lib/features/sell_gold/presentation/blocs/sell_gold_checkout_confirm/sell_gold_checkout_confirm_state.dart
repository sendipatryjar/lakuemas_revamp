part of 'sell_gold_checkout_confirm_bloc.dart';

abstract class SellGoldCheckoutConfirmState extends Equatable {
  const SellGoldCheckoutConfirmState();

  @override
  List<Object> get props => [];
}

class SellGoldCheckoutConfirmInitialState extends SellGoldCheckoutConfirmState {
}

class SellGoldCheckoutConfirmLoadingState extends SellGoldCheckoutConfirmState {
}

class SellGoldCheckoutConfirmSuccessState extends SellGoldCheckoutConfirmState {
  final CheckoutConfirmEntity? checkoutConfirmEntity;

  const SellGoldCheckoutConfirmSuccessState({this.checkoutConfirmEntity});

  @override
  List<Object> get props => [
        [checkoutConfirmEntity]
      ];
}

class SellGoldCheckoutConfirmFailureState extends SellGoldCheckoutConfirmState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const SellGoldCheckoutConfirmFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

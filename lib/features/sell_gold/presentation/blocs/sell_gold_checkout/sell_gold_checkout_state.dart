part of 'sell_gold_checkout_bloc.dart';

abstract class SellGoldCheckoutState extends Equatable {
  const SellGoldCheckoutState();

  @override
  List<Object> get props => [];
}

class SellGoldCheckoutInitialState extends SellGoldCheckoutState {}

class SellGoldCheckoutLoadingState extends SellGoldCheckoutState {}

class SellGoldCheckoutSuccessState extends SellGoldCheckoutState {
  final CheckoutEntity? checkoutEntity;

  const SellGoldCheckoutSuccessState({this.checkoutEntity});

  @override
  List<Object> get props => [
        [checkoutEntity]
      ];
}

class SellGoldCheckoutFailureState extends SellGoldCheckoutState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const SellGoldCheckoutFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

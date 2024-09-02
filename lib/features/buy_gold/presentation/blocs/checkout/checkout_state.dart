part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

class CheckoutInitialState extends CheckoutState {}

class CheckoutLoadingState extends CheckoutState {}

class CheckoutSuccessState extends CheckoutState {
  final CheckoutEntity? checkoutEntity;

  const CheckoutSuccessState({this.checkoutEntity});

  @override
  List<Object> get props => [
        [checkoutEntity]
      ];
}

class CheckoutFailureState extends CheckoutState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const CheckoutFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

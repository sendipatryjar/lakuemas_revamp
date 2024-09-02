part of 'payment_method_bloc.dart';

abstract class PaymentMethodState extends Equatable {
  const PaymentMethodState();

  @override
  List<Object> get props => [];
}

class PaymentMethodInitialState extends PaymentMethodState {}

class PaymentMethodLoadingState extends PaymentMethodState {}

class PaymentMethodSuccessState extends PaymentMethodState {
  final List<PaymentMethodEntity> paymentMethods;

  const PaymentMethodSuccessState(this.paymentMethods);

  @override
  List<Object> get props => [paymentMethods];
}

class PaymentMethodFailureState extends PaymentMethodState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const PaymentMethodFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

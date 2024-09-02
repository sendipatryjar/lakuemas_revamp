part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitialState extends PaymentState {}

class PaymentLoadingState extends PaymentState {}

class PaymentSuccessState extends PaymentState {
  final PaymentEntity? payment;

  const PaymentSuccessState(this.payment);

  @override
  List<Object> get props => [
        [payment]
      ];
}

class PaymentFailureState extends PaymentState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const PaymentFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

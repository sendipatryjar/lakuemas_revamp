part of 'transfer_checkout_bloc.dart';

abstract class TransferCheckoutState extends Equatable {
  const TransferCheckoutState();

  @override
  List<Object> get props => [];
}

class TransferCheckoutInitialState extends TransferCheckoutState {}

class TransferCheckoutLoadingState extends TransferCheckoutState {}

class TransferCheckoutSuccessState extends TransferCheckoutState {
  final String transactionCode;

  const TransferCheckoutSuccessState({required this.transactionCode});

  @override
  List<Object> get props => [transactionCode];
}

class TransferCheckoutFailureState extends TransferCheckoutState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const TransferCheckoutFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

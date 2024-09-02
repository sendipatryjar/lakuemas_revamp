part of 'transfer_checkout_bloc.dart';

abstract class TransferCheckoutEvent extends Equatable {
  const TransferCheckoutEvent();

  @override
  List<Object> get props => [];
}

class TransferCheckoutNowEvent extends TransferCheckoutEvent {
  final String transactionKey;

  const TransferCheckoutNowEvent({required this.transactionKey});

  @override
  List<Object> get props => [transactionKey];
}

class TransferCheckoutInitEvent extends TransferCheckoutEvent {}

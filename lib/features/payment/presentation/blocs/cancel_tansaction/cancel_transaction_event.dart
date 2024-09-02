part of 'cancel_transaction_bloc.dart';

sealed class CancelTransactionEvent extends Equatable {
  const CancelTransactionEvent();

  @override
  List<Object> get props => [];
}

class CancelTransactionNowEvent extends CancelTransactionEvent {
  final String? transactionCode;
  final bool isUpdateStatusFirst;

  const CancelTransactionNowEvent({
    required this.transactionCode,
    required this.isUpdateStatusFirst,
  });

  @override
  List<Object> get props => [
        [transactionCode, isUpdateStatusFirst]
      ];
}

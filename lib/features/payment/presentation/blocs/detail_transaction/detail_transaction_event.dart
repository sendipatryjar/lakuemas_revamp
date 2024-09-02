part of 'detail_transaction_bloc.dart';

abstract class DetailTransactionEvent extends Equatable {
  const DetailTransactionEvent();

  @override
  List<Object> get props => [];
}

class DetailTransactionGetEvent extends DetailTransactionEvent {
  final int transactionDetailType;
  final String transactionCode;

  const DetailTransactionGetEvent({
    required this.transactionDetailType,
    required this.transactionCode,
  });

  @override
  List<Object> get props => [
        [transactionDetailType, transactionCode]
      ];
}

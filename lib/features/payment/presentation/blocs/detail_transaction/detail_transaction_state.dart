part of 'detail_transaction_bloc.dart';

abstract class DetailTransactionState extends Equatable {
  const DetailTransactionState();

  @override
  List<Object> get props => [];
}

class DetailTransactionInitialState extends DetailTransactionState {}

class DetailTransactionLoadingState extends DetailTransactionState {}

class DetailTransactionSuccessState extends DetailTransactionState {
  final DetailTransactionEntity detailTransaction;

  const DetailTransactionSuccessState(this.detailTransaction);

  @override
  List<Object> get props => [detailTransaction];
}

class DetailTransactionFailureState extends DetailTransactionState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const DetailTransactionFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

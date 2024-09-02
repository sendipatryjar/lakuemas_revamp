part of 'cancel_transaction_bloc.dart';

sealed class CancelTransactionState extends Equatable {
  const CancelTransactionState();

  @override
  List<Object> get props => [];
}

class CancelTransactionInitialState extends CancelTransactionState {}

class CancelTransactionLoadingState extends CancelTransactionState {}

class CancelTransactionSuccessState extends CancelTransactionState {
  final bool isUpdateStatusSuccess;

  const CancelTransactionSuccessState({required this.isUpdateStatusSuccess});

  @override
  List<Object> get props => [
        [isUpdateStatusSuccess]
      ];
}

class CancelTransactionFailureState extends CancelTransactionState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const CancelTransactionFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

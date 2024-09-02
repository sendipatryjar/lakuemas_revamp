part of 'withdrawal_bloc.dart';

sealed class WithdrawalState extends Equatable {
  const WithdrawalState();

  @override
  List<Object> get props => [];
}

class WithdrawalInitialState extends WithdrawalState {}

class WithdrawalLoadingState extends WithdrawalState {}

class WithdrawalSuccessState extends WithdrawalState {
  final WithdrawalEntity? withdrawalEntity;

  const WithdrawalSuccessState({this.withdrawalEntity});

  @override
  List<Object> get props => [
        [WithdrawalEntity]
      ];
}

class WithdrawalFailureState extends WithdrawalState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const WithdrawalFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

part of 'close_account_bloc.dart';

abstract class CloseAccountState extends Equatable {
  const CloseAccountState();

  @override
  List<Object> get props => [];
}

class CloseAccountInitialState extends CloseAccountState {}

class CloseAccountLoadingState extends CloseAccountState {}

class CloseAccountSuccessState extends CloseAccountState {}

class CloseAccountFailureState extends CloseAccountState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const CloseAccountFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

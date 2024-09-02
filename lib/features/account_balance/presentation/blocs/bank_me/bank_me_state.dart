part of 'bank_me_bloc.dart';

sealed class BankMeState extends Equatable {
  const BankMeState();

  @override
  List<Object> get props => [];
}

class BankMeInitialState extends BankMeState {}

class BankMeLoadingState extends BankMeState {}

class BankMeSuccessState extends BankMeState {
  final BankMeEntity? bankMeEntity;

  const BankMeSuccessState({this.bankMeEntity});

  @override
  List<Object> get props => [
        [bankMeEntity]
      ];
}

class BankMeFailureState extends BankMeState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const BankMeFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

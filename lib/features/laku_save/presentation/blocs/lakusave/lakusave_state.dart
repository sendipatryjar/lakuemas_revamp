part of 'lakusave_bloc.dart';

abstract class LakusaveState extends Equatable {
  const LakusaveState();

  @override
  List<Object> get props => [];
}

class LakusaveInitialState extends LakusaveState {}

class LakusaveLoadingState extends LakusaveState {}

class LakusaveSuccessState extends LakusaveState {
  final List<TransactionEntity> data;

  const LakusaveSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class LakusaveFailureState extends LakusaveState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const LakusaveFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

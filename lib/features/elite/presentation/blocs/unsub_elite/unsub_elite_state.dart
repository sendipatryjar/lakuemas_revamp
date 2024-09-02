part of 'unsub_elite_bloc.dart';

sealed class UnsubEliteState extends Equatable {
  const UnsubEliteState();

  @override
  List<Object> get props => [];
}

final class UnsubEliteInitial extends UnsubEliteState {}

final class UnsubEliteLoadingState extends UnsubEliteState {}

final class UnsubEliteSuccessState extends UnsubEliteState {}

final class UnsubEliteFailureState extends UnsubEliteState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const UnsubEliteFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

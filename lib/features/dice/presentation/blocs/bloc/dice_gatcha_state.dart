part of 'dice_gatcha_bloc.dart';

sealed class DiceGatchaState extends Equatable {
  const DiceGatchaState();

  @override
  List<Object> get props => [];
}

class DiceGatchaInitialState extends DiceGatchaState {}

class DiceGatchaLoadingState extends DiceGatchaState {}

class DiceGatchaSuccessState extends DiceGatchaState {
  const DiceGatchaSuccessState();

  @override
  List<Object> get props => [];
}

class DiceGatchaFailureState extends DiceGatchaState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const DiceGatchaFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

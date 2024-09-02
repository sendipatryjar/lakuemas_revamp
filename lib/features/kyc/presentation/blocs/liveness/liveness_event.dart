part of 'liveness_bloc.dart';

sealed class LivenessEvent extends Equatable {
  const LivenessEvent();

  @override
  List<Object> get props => [];
}

class LivenessGenerateUrlEvent extends LivenessEvent {}

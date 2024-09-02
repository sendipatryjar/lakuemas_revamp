part of 'liveness_bloc.dart';

sealed class LivenessState extends Equatable {
  const LivenessState();

  @override
  List<Object> get props => [];
}

class LivenessInitial extends LivenessState {
  @override
  List<Object> get props => [];
}

class LivenessLoadingState extends LivenessState {}

class LivenessSuccessState extends LivenessState {
  final String? url;
  const LivenessSuccessState({this.url});

  @override
  List<Object> get props => [
        [url]
      ];
}

class LivenessFailureState extends LivenessState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const LivenessFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

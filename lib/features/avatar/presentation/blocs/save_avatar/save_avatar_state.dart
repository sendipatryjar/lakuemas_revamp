part of 'save_avatar_bloc.dart';

sealed class SaveAvatarState extends Equatable {
  const SaveAvatarState();

  @override
  List<Object> get props => [];
}

class SaveAvatarInitialState extends SaveAvatarState {}

class SaveAvatarLoadingState extends SaveAvatarState {}

class SaveAvatarSuccessState extends SaveAvatarState {}

class SaveAvatarFailureState extends SaveAvatarState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const SaveAvatarFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

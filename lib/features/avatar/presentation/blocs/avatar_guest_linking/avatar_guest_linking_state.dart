part of 'avatar_guest_linking_bloc.dart';

sealed class AvatarGuestLinkingState extends Equatable {
  const AvatarGuestLinkingState();

  @override
  List<Object> get props => [];
}

class AvatarGuestLinkingInitialState extends AvatarGuestLinkingState {}

class AvatarGuestLinkingLoadingState extends AvatarGuestLinkingState {}

class AvatarGuestLinkingSuccessState extends AvatarGuestLinkingState {
  final String? token;

  const AvatarGuestLinkingSuccessState({this.token});

  @override
  List<Object> get props => [
        [token]
      ];
}

class AvatarGuestLinkingFailureState extends AvatarGuestLinkingState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const AvatarGuestLinkingFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

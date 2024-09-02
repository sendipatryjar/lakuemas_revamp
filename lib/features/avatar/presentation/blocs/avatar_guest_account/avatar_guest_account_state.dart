part of 'avatar_guest_account_bloc.dart';

sealed class AvatarGuestAccountState extends Equatable {
  const AvatarGuestAccountState();

  @override
  List<Object> get props => [];
}

class AvatarGuestAccountInitialState extends AvatarGuestAccountState {}

class AvatarGuestAccountLoadingState extends AvatarGuestAccountState {}

class AvatarGuestAccountSuccessState extends AvatarGuestAccountState {
  final AvatarUserEntity? avatarUserEntity;

  const AvatarGuestAccountSuccessState({this.avatarUserEntity});

  @override
  List<Object> get props => [
        [avatarUserEntity]
      ];
}

class AvatarGuestAccountFailureState extends AvatarGuestAccountState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const AvatarGuestAccountFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

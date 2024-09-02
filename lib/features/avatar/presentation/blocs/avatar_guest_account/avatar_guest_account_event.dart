part of 'avatar_guest_account_bloc.dart';

sealed class AvatarGuestAccountEvent extends Equatable {
  const AvatarGuestAccountEvent();

  @override
  List<Object> get props => [];
}

class AvatarGuestAccountCreateEvent extends AvatarGuestAccountEvent {}

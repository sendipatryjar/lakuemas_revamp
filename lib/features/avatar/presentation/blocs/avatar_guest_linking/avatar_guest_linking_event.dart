part of 'avatar_guest_linking_bloc.dart';

sealed class AvatarGuestLinkingEvent extends Equatable {
  const AvatarGuestLinkingEvent();

  @override
  List<Object> get props => [];
}

class AvatarGuestLinkingGetEvent extends AvatarGuestLinkingEvent {
  final String? userId;

  const AvatarGuestLinkingGetEvent({this.userId});

  @override
  List<Object> get props => [
        [userId]
      ];
}

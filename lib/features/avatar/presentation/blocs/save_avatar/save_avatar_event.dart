part of 'save_avatar_bloc.dart';

sealed class SaveAvatarEvent extends Equatable {
  const SaveAvatarEvent();

  @override
  List<Object> get props => [];
}

class SaveAvatarNowEvent extends SaveAvatarEvent {
  final String? imageUrl;

  const SaveAvatarNowEvent(this.imageUrl);

  @override
  List<Object> get props => [
        [imageUrl]
      ];
}

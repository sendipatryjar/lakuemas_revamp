part of 'get_social_media_config_bloc.dart';

sealed class GetSocialMediaConfigEvent extends Equatable {
  const GetSocialMediaConfigEvent();

  @override
  List<Object> get props => [];
}

class GetSocialMediaConfigLoadEvent extends GetSocialMediaConfigEvent {
  final HelperDataEliteCubit helperDataEliteCubit;

  const GetSocialMediaConfigLoadEvent({required this.helperDataEliteCubit});

  @override
  List<Object> get props => [helperDataEliteCubit];
}

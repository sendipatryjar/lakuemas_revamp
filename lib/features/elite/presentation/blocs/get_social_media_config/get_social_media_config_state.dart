part of 'get_social_media_config_bloc.dart';

sealed class GetSocialMediaConfigState extends Equatable {
  const GetSocialMediaConfigState();

  @override
  List<Object> get props => [];
}

final class GetSocialMediaConfigInitial extends GetSocialMediaConfigState {}

final class GetSocialMediaConfigLoadingState
    extends GetSocialMediaConfigState {}

final class GetSocialMediaConfigSuccessState extends GetSocialMediaConfigState {
  final SocialMediaConfigEntity socialMediaConfigEntity;

  const GetSocialMediaConfigSuccessState(this.socialMediaConfigEntity);

  @override
  List<Object> get props => [
        [socialMediaConfigEntity],
      ];
}

final class GetSocialMediaConfigFailureState extends GetSocialMediaConfigState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const GetSocialMediaConfigFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

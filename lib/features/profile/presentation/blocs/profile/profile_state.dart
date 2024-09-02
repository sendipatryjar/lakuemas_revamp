part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileState {}

class ProfileLoadingState extends ProfileState {}

class ProfileSuccessState extends ProfileState {
  final UserDataEntity? userDataEntity;

  const ProfileSuccessState(this.userDataEntity);

  @override
  List<Object> get props => [
        [userDataEntity]
      ];
}

class ProfileFailureState extends ProfileState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const ProfileFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

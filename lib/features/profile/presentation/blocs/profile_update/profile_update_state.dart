part of 'profile_update_bloc.dart';

abstract class ProfileUpdateState extends Equatable {
  const ProfileUpdateState();

  @override
  List<Object> get props => [];
}

class ProfileUpdateInitialState extends ProfileUpdateState {}

class ProfileUpdateLoadingState extends ProfileUpdateState {}

class ProfileUpdateSuccessState extends ProfileUpdateState {}

class ProfileUpdateFailureState extends ProfileUpdateState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const ProfileUpdateFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

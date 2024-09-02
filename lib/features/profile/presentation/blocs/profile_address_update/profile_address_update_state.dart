part of 'profile_address_update_bloc.dart';

abstract class ProfileAddressUpdateState extends Equatable {
  const ProfileAddressUpdateState();

  @override
  List<Object> get props => [];
}

class ProfileAddressUpdateInitialState extends ProfileAddressUpdateState {}

class ProfileAddressUpdateLoadingState extends ProfileAddressUpdateState {}

class ProfileAddressUpdateSuccessState extends ProfileAddressUpdateState {}

class ProfileAddressUpdateFailureState extends ProfileAddressUpdateState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const ProfileAddressUpdateFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

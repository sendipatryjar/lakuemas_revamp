part of 'terms_and_conditions_profile_bloc.dart';

sealed class TAndCProfileState extends Equatable {
  const TAndCProfileState();

  @override
  List<Object> get props => [];
}

class TAndCProfileInitialState extends TAndCProfileState {}

class TAndCProfileLoadingState extends TAndCProfileState {}

class TAndCProfileSuccessState extends TAndCProfileState {
  final TermsAndConditionsEntity? tAndCProfile;

  const TAndCProfileSuccessState({
    required this.tAndCProfile,
  });

  @override
  List<Object> get props => [
        [tAndCProfile]
      ];
}

class TAndCProfileFailureState extends TAndCProfileState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const TAndCProfileFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

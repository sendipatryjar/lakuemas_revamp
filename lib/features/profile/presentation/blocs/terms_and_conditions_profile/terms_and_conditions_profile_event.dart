part of 'terms_and_conditions_profile_bloc.dart';

sealed class TAndCProfileEvent extends Equatable {
  const TAndCProfileEvent();

  @override
  List<Object> get props => [];
}

class TAndCProfileGetEvent extends TAndCProfileEvent {
  final HelperDataCubit helperDataCubit;

  const TAndCProfileGetEvent({required this.helperDataCubit});

  @override
  List<Object> get props => [helperDataCubit];
}

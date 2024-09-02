part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  final dynamic data;
  const ProfileEvent(this.data);

  @override
  List<Object> get props => [data];
}

class ProfileGetDataEvent extends ProfileEvent {
  final HelperDataCubit? helperDataCubit;
  final EliteCubit? eliteCubit;

  ProfileGetDataEvent({
    this.helperDataCubit,
    this.eliteCubit,
  }) : super([
          helperDataCubit,
          eliteCubit,
        ]);
}

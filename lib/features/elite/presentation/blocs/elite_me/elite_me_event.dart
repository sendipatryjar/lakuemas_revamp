part of 'elite_me_bloc.dart';

sealed class EliteMeEvent extends Equatable {
  const EliteMeEvent();

  @override
  List<Object> get props => [];
}

class EliteMeGetEvent extends EliteMeEvent {
  final HelperDataEliteCubit helperDataEliteCubit;

  const EliteMeGetEvent({required this.helperDataEliteCubit});

  @override
  List<Object> get props => [helperDataEliteCubit];
}

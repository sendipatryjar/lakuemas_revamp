part of 'mutation_onprocess_bloc.dart';

abstract class MutationOnprocessEvent extends Equatable {
  const MutationOnprocessEvent();

  @override
  List<Object> get props => [];
}

class MutationOnprocessGetEvent extends MutationOnprocessEvent {
  final HelperDataCubit helperDataCubit;

  const MutationOnprocessGetEvent({required this.helperDataCubit});

  @override
  List<Object> get props => [helperDataCubit];
}

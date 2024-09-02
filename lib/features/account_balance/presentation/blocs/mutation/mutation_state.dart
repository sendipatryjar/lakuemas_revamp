part of 'mutation_bloc.dart';

abstract class MutationState extends Equatable {
  const MutationState();

  @override
  List<Object> get props => [];
}

class MutationInitialState extends MutationState {}

class MutationLoadingState extends MutationState {}

class MutationSuccessState extends MutationState {
  final List<MutationEntity> mutation;

  const MutationSuccessState({
    required this.mutation,
  });

  @override
  List<Object> get props => [
        [mutation]
      ];
}

class MutationFailureState extends MutationState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const MutationFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

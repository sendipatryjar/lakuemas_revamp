part of 'mutation_onprocess_bloc.dart';

abstract class MutationOnprocessState extends Equatable {
  const MutationOnprocessState();

  @override
  List<Object> get props => [];
}

class MutationOnprocessInitialState extends MutationOnprocessState {}

class MutationOnprocessLoadingState extends MutationOnprocessState {}

class MutationOnprocessSuccessState extends MutationOnprocessState {
  final List<MutationEntity> mutation;

  const MutationOnprocessSuccessState({
    required this.mutation,
  });

  @override
  List<Object> get props => [
        [mutation]
      ];
}

class MutationOnprocessFailureState extends MutationOnprocessState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const MutationOnprocessFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

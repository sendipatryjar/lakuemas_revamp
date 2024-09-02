part of 'stores_bloc.dart';

abstract class StoresState extends Equatable {
  const StoresState();

  @override
  List<Object> get props => [];
}

class StoresInitial extends StoresState {}

class StoresLoadingState extends StoresState {}

class StoresSuccessState extends StoresState {
  final List<StoreEntity> data;

  const StoresSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class StoresFailureState extends StoresState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const StoresFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

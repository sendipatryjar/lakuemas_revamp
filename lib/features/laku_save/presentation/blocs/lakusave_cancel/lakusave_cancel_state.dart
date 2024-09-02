part of 'lakusave_cancel_bloc.dart';

abstract class LakusaveCancelState extends Equatable {
  const LakusaveCancelState();

  @override
  List<Object> get props => [];
}

class LakusaveCancelInitialState extends LakusaveCancelState {}

class LakusaveCancelLoadingState extends LakusaveCancelState {}

class LakusaveCancelSuccessState extends LakusaveCancelState {}

class LakusaveCancelFailureState extends LakusaveCancelState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const LakusaveCancelFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

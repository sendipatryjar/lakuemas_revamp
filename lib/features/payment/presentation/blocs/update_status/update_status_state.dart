part of 'update_status_bloc.dart';

abstract class UpdateStatusState extends Equatable {
  const UpdateStatusState();

  @override
  List<Object> get props => [];
}

class UpdateStatusInitialState extends UpdateStatusState {}

class UpdateStatusLoadingState extends UpdateStatusState {}

class UpdateStatusSuccessState extends UpdateStatusState {
  final UpdateStatusEntity? updateStatus;

  const UpdateStatusSuccessState(this.updateStatus);

  @override
  List<Object> get props => [
        [updateStatus]
      ];
}

class UpdateStatusFailureState extends UpdateStatusState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const UpdateStatusFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

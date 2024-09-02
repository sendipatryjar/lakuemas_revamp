part of 'lakusave_update_extend_bloc.dart';

abstract class LakusaveUpdateExtendState extends Equatable {
  const LakusaveUpdateExtendState();

  @override
  List<Object> get props => [];
}

class LakusaveUpdateExtendInitialState extends LakusaveUpdateExtendState {}

class LakusaveUpdateExtendLoadingState extends LakusaveUpdateExtendState {}

class LakusaveUpdateExtendSuccessState extends LakusaveUpdateExtendState {}

class LakusaveUpdateExtendFailureState extends LakusaveUpdateExtendState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const LakusaveUpdateExtendFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

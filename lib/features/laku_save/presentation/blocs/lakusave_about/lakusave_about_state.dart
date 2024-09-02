part of 'lakusave_about_bloc.dart';

abstract class LakusaveAboutState extends Equatable {
  const LakusaveAboutState();

  @override
  List<Object> get props => [];
}

class LakusaveAboutInitialState extends LakusaveAboutState {}

class LakusaveAboutLoadingState extends LakusaveAboutState {}

class LakusaveAboutSuccessState extends LakusaveAboutState {
  final String? data;

  const LakusaveAboutSuccessState({required this.data});

  @override
  List<Object> get props => [
        [data]
      ];
}

class LakusaveAboutFailureState extends LakusaveAboutState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const LakusaveAboutFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

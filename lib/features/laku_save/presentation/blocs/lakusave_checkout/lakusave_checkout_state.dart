part of 'lakusave_checkout_bloc.dart';

abstract class LakusaveCheckoutState extends Equatable {
  const LakusaveCheckoutState();

  @override
  List<Object> get props => [];
}

class LakusaveCheckoutInitialState extends LakusaveCheckoutState {}

class LakusaveCheckoutLoadingState extends LakusaveCheckoutState {}

class LakusaveCheckoutSuccessState extends LakusaveCheckoutState {}

class LakusaveCheckoutFailureState extends LakusaveCheckoutState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const LakusaveCheckoutFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

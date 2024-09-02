part of 'support_faq_bloc.dart';

sealed class SupportFaqState extends Equatable {
  const SupportFaqState();

  @override
  List<Object> get props => [];
}

class SupportFaqInitialState extends SupportFaqState {}

class SupportFaqLoadingState extends SupportFaqState {}

class SupportFaqSuccessState extends SupportFaqState {
  final List<SupportFaqEntity> data;

  const SupportFaqSuccessState({required this.data});

  @override
  List<Object> get props => [data];
}

class SupportFaqFailureState extends SupportFaqState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const SupportFaqFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

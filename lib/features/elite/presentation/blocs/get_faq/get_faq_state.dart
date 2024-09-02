part of 'get_faq_bloc.dart';

abstract class GetFaqState extends Equatable {
  const GetFaqState();

  @override
  List<Object> get props => [];
}

class GetFaqInitial extends GetFaqState {}

class GetFaqLoadingState extends GetFaqState {}

class GetFaqSuccessState extends GetFaqState {
  final List<FaqEntity> data;

  const GetFaqSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class GetFaqFailureState extends GetFaqState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const GetFaqFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

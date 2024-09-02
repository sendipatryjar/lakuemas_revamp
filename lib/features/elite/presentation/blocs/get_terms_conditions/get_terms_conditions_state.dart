part of 'get_terms_conditions_bloc.dart';

abstract class GetTermsConditionsState extends Equatable {
  const GetTermsConditionsState();

  @override
  List<Object> get props => [];
}

class GetTermsConditionsInitial extends GetTermsConditionsState {}

class GetTermsConditionsLoadingState extends GetTermsConditionsState {}

class GetTermsConditionsSuccessState extends GetTermsConditionsState {
  final String data;

  const GetTermsConditionsSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class GetTermsConditionsFailureState extends GetTermsConditionsState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const GetTermsConditionsFailureState(
      this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

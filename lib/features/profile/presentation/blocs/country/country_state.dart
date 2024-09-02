part of 'country_bloc.dart';

sealed class CountryState extends Equatable {
  const CountryState();

  @override
  List<Object> get props => [];
}

class CountryInitialState extends CountryState {}

class CountryLoadingState extends CountryState {}

class CountrySuccessState extends CountryState {
  final List<CountryEntity> data;

  const CountrySuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class CountryFailureState extends CountryState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const CountryFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

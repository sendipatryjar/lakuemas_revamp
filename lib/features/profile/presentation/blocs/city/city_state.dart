part of 'city_bloc.dart';

abstract class CityState extends Equatable {
  const CityState();

  @override
  List<Object> get props => [];
}

class CityInitialState extends CityState {}

class CityLoadingState extends CityState {}

class CitySuccessState extends CityState {
  final List<CityEntity> data;

  const CitySuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class CityFailureState extends CityState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const CityFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

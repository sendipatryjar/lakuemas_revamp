part of 'province_bloc.dart';

abstract class ProvinceState extends Equatable {
  const ProvinceState();

  @override
  List<Object> get props => [];
}

class ProvinceInitialState extends ProvinceState {}

class ProvinceLoadingState extends ProvinceState {}

class ProvinceSuccessState extends ProvinceState {
  final List<ProvinceEntity> data;

  const ProvinceSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class ProvinceFailureState extends ProvinceState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const ProvinceFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

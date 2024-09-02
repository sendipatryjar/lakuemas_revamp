part of 'district_bloc.dart';

abstract class DistrictState extends Equatable {
  const DistrictState();

  @override
  List<Object> get props => [];
}

class DistrictInitialState extends DistrictState {}

class DistrictLoadingState extends DistrictState {}

class DistrictSuccessState extends DistrictState {
  final List<DistrictEntity> data;

  const DistrictSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

class DistrictFailureState extends DistrictState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const DistrictFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

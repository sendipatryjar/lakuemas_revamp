part of 'detail_district_bloc.dart';

sealed class DetailDistrictState extends Equatable {
  const DetailDistrictState();

  @override
  List<Object> get props => [];
}

final class DetailDistrictInitial extends DetailDistrictState {}

final class DetailDistrictLoadingState extends DetailDistrictState {}

final class DetailDistrictSuccessState extends DetailDistrictState {
  final DetailDistrictEntity data;

  const DetailDistrictSuccessState(this.data);

  @override
  List<Object> get props => [data];
}

final class DetailDistrictFailureState extends DetailDistrictState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const DetailDistrictFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

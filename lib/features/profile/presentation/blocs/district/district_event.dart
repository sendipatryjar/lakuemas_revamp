part of 'district_bloc.dart';

abstract class DistrictEvent extends Equatable {
  const DistrictEvent();

  @override
  List<Object> get props => [];
}

class DistrictGetEvent extends DistrictEvent {
  final int? limit;
  final int? page;
  final int? cityId;
  final String? sortBy;
  final String? orderBy;

  const DistrictGetEvent(
      {this.limit, this.page, this.cityId, this.sortBy, this.orderBy});

  @override
  List<Object> get props => [
        [limit, page, cityId, sortBy, orderBy]
      ];
}

class DistrictBackToInitEvent extends DistrictEvent {}

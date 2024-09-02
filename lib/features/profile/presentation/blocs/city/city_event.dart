part of 'city_bloc.dart';

abstract class CityEvent extends Equatable {
  const CityEvent();

  @override
  List<Object> get props => [];
}

class CityGetEvent extends CityEvent {
  final int? limit;
  final int? page;
  final int? provinceId;
  final String? sortBy;
  final String? orderBy;
  final String? keyword;

  const CityGetEvent(
      {this.limit,
      this.page,
      this.provinceId,
      this.sortBy,
      this.orderBy,
      this.keyword});

  @override
  List<Object> get props => [
        [limit, page, provinceId, sortBy, orderBy, keyword]
      ];
}

class CityBackToInitEvent extends CityEvent {}

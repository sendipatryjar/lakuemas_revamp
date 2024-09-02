part of 'province_bloc.dart';

abstract class ProvinceEvent extends Equatable {
  const ProvinceEvent();

  @override
  List<Object> get props => [];
}

class ProvinceGetEvent extends ProvinceEvent {
  final int? limit;
  final int? page;
  final String? sortBy;
  final String? orderBy;

  const ProvinceGetEvent({this.limit, this.page, this.sortBy, this.orderBy});

  @override
  List<Object> get props => [
        [limit, page, sortBy, orderBy]
      ];
}

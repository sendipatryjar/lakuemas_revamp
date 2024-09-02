part of 'stores_bloc.dart';

abstract class StoresEvent extends Equatable {
  const StoresEvent();

  @override
  List<Object> get props => [];
}

class StoresGetEvent extends StoresEvent {
  final int? limit;
  final int? page;
  final int? cityId;
  final String? sortBy;
  final String? orderBy;

  const StoresGetEvent(
      {this.limit, this.page, this.cityId, this.sortBy, this.orderBy});

  @override
  List<Object> get props => [
        [limit, page, cityId, sortBy, orderBy]
      ];
}

class StoresBackToInitEvent extends StoresEvent {}

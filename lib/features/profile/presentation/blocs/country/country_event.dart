part of 'country_bloc.dart';

sealed class CountryEvent extends Equatable {
  const CountryEvent();

  @override
  List<Object> get props => [];
}

class CountryGetEvent extends CountryEvent {
  final int? limit;
  final int? page;
  final String? sortBy;
  final String? orderBy;

  const CountryGetEvent({
    this.limit,
    this.page,
    this.sortBy,
    this.orderBy,
  });

  @override
  List<Object> get props => [
        [limit, page, sortBy, orderBy]
      ];
}

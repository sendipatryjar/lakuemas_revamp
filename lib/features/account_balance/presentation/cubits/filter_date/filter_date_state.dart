part of 'filter_date_cubit.dart';

class FilterDateState extends Equatable {
  final List<DateTime?>? date;
  const FilterDateState({
    this.date,
  });

  FilterDateState copyWith({
    List<DateTime?>? date,
  }) =>
      FilterDateState(
        date: date ?? this.date,
      );

  @override
  List<Object> get props => [
        [date]
      ];
}

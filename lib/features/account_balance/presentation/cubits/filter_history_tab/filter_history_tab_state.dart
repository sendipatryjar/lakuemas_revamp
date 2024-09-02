part of 'filter_history_tab_cubit.dart';

enum EnFilterPeriod { sevenDays, thirtyDays, ninetyDays, byDate }

class FilterHistoryTabState extends Equatable {
  final EnFilterPeriod enFilterPeriod;
  const FilterHistoryTabState({
    required this.enFilterPeriod,
  });

  FilterHistoryTabState copyWith({
    EnFilterPeriod? enFilterPeriod,
  }) =>
      FilterHistoryTabState(
        enFilterPeriod: enFilterPeriod ?? this.enFilterPeriod,
      );

  @override
  List<Object> get props => [
        enFilterPeriod,
      ];
}

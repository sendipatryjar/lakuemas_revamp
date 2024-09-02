part of 'filter_tab_cubit.dart';

enum EnFilteredTab { sevenDays, oneMonth, thirdMonth, sixMonth }

class FilterTabState extends Equatable {
  final EnFilteredTab? enFilteredTab;
  const FilterTabState({
    this.enFilteredTab,
  });

  FilterTabState copyWith({
    EnFilteredTab? enFilteredTab,
  }) =>
      FilterTabState(enFilteredTab: enFilteredTab ?? this.enFilteredTab);

  @override
  List<Object?> get props => [enFilteredTab];
}

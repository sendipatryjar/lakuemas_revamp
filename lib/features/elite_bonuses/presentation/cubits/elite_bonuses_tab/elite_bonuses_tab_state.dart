part of 'elite_bonuses_tab_cubit.dart';

enum EnEliteBonusTab { tradeBonus, myReward }

class EliteBonusesTabState extends Equatable {
  final EnEliteBonusTab enEliteBonusTab;
  const EliteBonusesTabState({
    required this.enEliteBonusTab,
  });

  EliteBonusesTabState copyWith({
    EnEliteBonusTab? enEliteBonusTab,
  }) =>
      EliteBonusesTabState(
        enEliteBonusTab: enEliteBonusTab ?? this.enEliteBonusTab,
      );

  @override
  List<Object> get props => [enEliteBonusTab];
}

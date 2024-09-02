part of 'elite_history_cubit.dart';

enum EnFilterPeriod { sevenDays, thirtyDays, ninetyDays, byDate }

class EliteHistoryCubitState extends Equatable {
  final EnFilterPeriod enFilterPeriod;
  final List<EliteHistoryEntity> eliteHistoryEntity;
  final List<ListReferralEntity> listReferralEntity;
  final bool isLoading;
  final bool isError;
  final MetaDataApi? meta;
  final List<DateTime?>? date;
  final String? dateSubsElite;

  const EliteHistoryCubitState({
    required this.enFilterPeriod,
    this.eliteHistoryEntity = const [],
    this.listReferralEntity = const [],
    this.isLoading = false,
    this.isError = false,
    this.meta,
    this.date,
    this.dateSubsElite,
  });

  EliteHistoryCubitState copyWith({
    EnFilterPeriod? enFilterPeriod,
    List<EliteHistoryEntity>? eliteHistoryEntity,
    List<ListReferralEntity>? listReferralEntity,
    bool? isLoading,
    bool? isError,
    MetaDataApi? meta,
    List<DateTime?>? date,
    String? dateSubsElite,
  }) =>
      EliteHistoryCubitState(
        enFilterPeriod: enFilterPeriod ?? this.enFilterPeriod,
        eliteHistoryEntity: eliteHistoryEntity ?? this.eliteHistoryEntity,
        listReferralEntity: listReferralEntity ?? this.listReferralEntity,
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError,
        meta: meta ?? this.meta,
        date: date ?? this.date,
        dateSubsElite: dateSubsElite ?? this.dateSubsElite,
      );

  @override
  List<Object> get props => [
        enFilterPeriod,
        eliteHistoryEntity,
        listReferralEntity,
        isLoading,
        isError,
        [meta, date, dateSubsElite],
      ];
}

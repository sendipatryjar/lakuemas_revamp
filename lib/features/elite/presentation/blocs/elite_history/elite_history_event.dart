part of 'elite_history_bloc.dart';

sealed class EliteHistoryEvent extends Equatable {
  const EliteHistoryEvent();

  @override
  List<Object> get props => [];
}

class EliteHistoryGetEvent extends EliteHistoryEvent {
  final int? limit;
  final int? page;
  final String? startDate;
  final String? endDate;
  final String? orderBy;
  final String? sortBy;
  final int? statuses;
  final String? period;
  final List<EliteHistoryEntity> eliteHistory;
  final bool isInitData;

  const EliteHistoryGetEvent({
    this.limit,
    this.page,
    this.startDate,
    this.endDate,
    this.orderBy,
    this.sortBy,
    this.statuses,
    this.period,
    this.eliteHistory = const [],
    this.isInitData = false,
  });

  @override
  List<Object> get props => [
        [
          limit,
          page,
          startDate,
          endDate,
          orderBy,
          sortBy,
          statuses,
          period,
          eliteHistory,
          isInitData,
        ]
      ];
}

class GetEliteReferralsLoadEvent extends EliteHistoryEvent {
  final int? limit;
  final int? page;
  final String? startDate;
  final String? endDate;
  final String? startValidDate;
  final String? endValidDate;
  final List<ListReferralEntity> eliteReferrals;
  final bool isInitData;

  const GetEliteReferralsLoadEvent({
    this.limit,
    this.page,
    this.startDate,
    this.endDate,
    this.startValidDate,
    this.endValidDate,
    this.eliteReferrals = const [],
    this.isInitData = false,
  });

  @override
  List<Object> get props => [
        [
          limit,
          page,
          startDate,
          endDate,
          startValidDate,
          endValidDate,
          eliteReferrals,
          isInitData,
        ]
      ];
}

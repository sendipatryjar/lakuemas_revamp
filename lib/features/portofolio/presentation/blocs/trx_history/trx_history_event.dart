part of 'trx_history_bloc.dart';

abstract class TrxHistoryEvent extends Equatable {
  const TrxHistoryEvent();

  @override
  List<Object> get props => [];
}

class TrxHistoryGetEvent extends TrxHistoryEvent {
  final int? limit;
  final int? page;
  final String? sortBy;
  final String? orderBy;
  final int? status;
  final String? type;
  final String? period;
  final String? startDate;
  final String? endDate;
  final bool isInitData;

  const TrxHistoryGetEvent({
    this.limit,
    this.page,
    this.sortBy,
    this.orderBy,
    this.status,
    this.type,
    this.period,
    this.startDate,
    this.endDate,
    this.isInitData = false,
  });

  @override
  List<Object> get props => [
        [
          limit,
          page,
          sortBy,
          orderBy,
          status,
          type,
          period,
          startDate,
          endDate,
          isInitData,
        ]
      ];
}

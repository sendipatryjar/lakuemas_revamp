part of 'trx_history_cubit.dart';

class TrxHistoryCubitState extends Equatable {
  final int? trxTypeSelected;
  final int? trxStatusSelected;
  final int? trxDateSelected;
  final int? trxStatus;
  final String? filterTrxType;
  final String? trxType;
  final String? filterTrxStatus;
  final String? filterTrxDate;
  final String? trxDate;
  final List<TrxHistoryEntity> trxHistory;
  final bool isLoading;
  final bool isError;
  final MetaDataApi? meta;
  final List<DateTime?>? date;

  const TrxHistoryCubitState({
    this.trxTypeSelected = 0,
    this.trxStatusSelected = 0,
    this.trxDateSelected = 0,
    this.trxStatus,
    this.filterTrxType,
    this.trxType,
    this.filterTrxStatus,
    this.filterTrxDate,
    this.trxDate,
    this.trxHistory = const [],
    this.isLoading = false,
    this.isError = false,
    this.meta,
    this.date,
  });

  TrxHistoryCubitState copyWith({
    int? trxTypeSelected,
    int? trxStatusSelected,
    int? trxDateSelected,
    int? trxStatus,
    bool nullifyTrxStatus = false,
    String? filterTrxType,
    String? trxType,
    String? filterTrxStatus,
    String? filterTrxDate,
    String? trxDate,
    List<TrxHistoryEntity>? trxHistory,
    bool? isLoading,
    bool? isError,
    MetaDataApi? meta,
    List<DateTime?>? date,
  }) =>
      TrxHistoryCubitState(
        trxTypeSelected: trxTypeSelected ?? this.trxTypeSelected,
        trxStatusSelected: trxStatusSelected ?? this.trxStatusSelected,
        trxDateSelected: trxDateSelected ?? this.trxDateSelected,
        trxStatus: nullifyTrxStatus ? null : (trxStatus ?? this.trxStatus),
        filterTrxType: filterTrxType ?? this.filterTrxType,
        trxType: trxType ?? this.trxType,
        filterTrxStatus: filterTrxStatus ?? this.filterTrxStatus,
        filterTrxDate: filterTrxDate ?? this.filterTrxDate,
        trxDate: trxDate ?? this.trxDate,
        trxHistory: trxHistory ?? this.trxHistory,
        isLoading: isLoading ?? this.isLoading,
        isError: isError ?? this.isError,
        meta: meta ?? this.meta,
        date: date ?? this.date,
      );

  @override
  List<Object> get props => [
        [
          trxTypeSelected,
          trxStatusSelected,
          trxDateSelected,
          trxStatus,
          filterTrxType,
          trxType,
          filterTrxStatus,
          filterTrxDate,
          trxDate,
          trxHistory,
          isLoading,
          isError,
          meta,
          date,
        ]
      ];
}

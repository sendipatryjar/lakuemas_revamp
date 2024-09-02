part of 'elite_history_bloc.dart';

sealed class EliteHistoryState extends Equatable {
  const EliteHistoryState();

  @override
  List<Object> get props => [];
}

final class EliteHistoryInitial extends EliteHistoryState {}

final class EliteHistoryLoadingState extends EliteHistoryState {}

final class EliteHistorySuccessState extends EliteHistoryState {
  final MetaDataApi? metaData;
  final List<EliteHistoryEntity>? eliteHistory;
  final List<ListReferralEntity>? listReferralEntity;
  final bool isInitData;

  const EliteHistorySuccessState({
    required this.metaData,
    this.eliteHistory,
    this.listReferralEntity,
    this.isInitData = false,
  });

  @override
  List<Object> get props => [
        [eliteHistory, listReferralEntity, metaData],
        isInitData
      ];
}

final class EliteHistoryFailureState extends EliteHistoryState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const EliteHistoryFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

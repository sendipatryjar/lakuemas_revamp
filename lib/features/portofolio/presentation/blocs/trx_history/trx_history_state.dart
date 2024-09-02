part of 'trx_history_bloc.dart';

abstract class TrxHistoryState extends Equatable {
  const TrxHistoryState();

  @override
  List<Object> get props => [];
}

class TrxHistoryInitialState extends TrxHistoryState {}

class TrxHistoryLoadingState extends TrxHistoryState {}

class TrxHistorySuccessState extends TrxHistoryState {
  final MetaDataApi? metaData;
  final bool isInitData;
  final List<TrxHistoryEntity> trxHistory;

  const TrxHistorySuccessState({
    required this.metaData,
    this.isInitData = false,
    required this.trxHistory,
  });

  @override
  List<Object> get props => [
        trxHistory,
        isInitData,
        [metaData]
      ];
}

class TrxHistoryFailureState extends TrxHistoryState {
  final AppFailure appFailure;
  final int? code;
  final String? message;

  const TrxHistoryFailureState(this.appFailure, this.code, this.message);

  @override
  List<Object> get props => [
        [appFailure, code, message]
      ];
}

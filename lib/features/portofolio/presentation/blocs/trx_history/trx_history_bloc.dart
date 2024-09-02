import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/models/data_with_meta.dart';
import '../../../domain/entities/trx_history_entity.dart';
import '../../../domain/usecases/trx_history_uc.dart';

part 'trx_history_event.dart';
part 'trx_history_state.dart';

class TrxHistoryBloc extends Bloc<TrxHistoryEvent, TrxHistoryState> {
  final TrxHistoryUc trxHistoryUc;
  TrxHistoryBloc({required this.trxHistoryUc})
      : super(TrxHistoryInitialState()) {
    on<TrxHistoryGetEvent>((event, emit) async {
      emit(TrxHistoryLoadingState());
      final result = await trxHistoryUc(
        GetTrxHistory(
          limit: event.limit,
          page: event.page,
          sortBy: event.sortBy,
          orderBy: event.orderBy,
          status: event.status,
          period: event.period,
          startDate: event.startDate,
          endDate: event.endDate,
          type: event.type,
        ),
      );
      result.fold(
        (l) => emit(TrxHistoryFailureState(l, l.code, l.messages)),
        (r) {
          var data = r.data;
          emit(TrxHistorySuccessState(
            isInitData: event.isInitData,
            metaData: r.meta,
            trxHistory: data,
          ));
        },
      );
    });
  }
}

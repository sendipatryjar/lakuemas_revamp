import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../../domain/usecases/lakusave_get_transactions_uc.dart';

part 'lakusave_event.dart';
part 'lakusave_state.dart';

class LakusaveBloc extends Bloc<LakusaveEvent, LakusaveState> {
  final LakusaveGetTransactionsUc getTransactionsUc;

  LakusaveBloc({
    required this.getTransactionsUc,
  }) : super(LakusaveInitialState()) {
    on<LakusaveGetTransactionsEvent>((event, emit) async {
      emit(LakusaveLoadingState());
      final result = await getTransactionsUc(
          params: GetTransactionsParams(
        type: 'deposit',
        page: 1,
        limit: 1000,
        orderBy: 'created_at',
        sortBy: 'desc',
        status: event.status,
      ));
      result.fold(
        (l) => emit(LakusaveFailureState(l, l.code, l.messages)),
        (r) => emit(LakusaveSuccessState(data: r)),
      );
    });
  }
}

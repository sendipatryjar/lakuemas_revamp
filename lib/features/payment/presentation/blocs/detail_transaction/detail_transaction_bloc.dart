import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../cores/constants/transaction_detail_type.dart';
import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/detail_transaction_entity.dart';
import '../../../domain/usecases/get_detail_transaction_elite_uc.dart';
import '../../../domain/usecases/get_detail_transaction_withdraw_uc.dart';
import '../../../domain/usecases/get_transaction_detail_uc.dart';

part 'detail_transaction_event.dart';
part 'detail_transaction_state.dart';

class DetailTransactionBloc
    extends Bloc<DetailTransactionEvent, DetailTransactionState> {
  final GetTransactionDetailUc getTransactionDetailUc;
  final GetDetailTransactionWithdrawUc getDetailTransactionWithdrawUc;
  final GetDetailTransactionEliteUc getDetailTransactionEliteUc;
  DetailTransactionBloc({
    required this.getTransactionDetailUc,
    required this.getDetailTransactionWithdrawUc,
    required this.getDetailTransactionEliteUc,
  }) : super(DetailTransactionInitialState()) {
    on<DetailTransactionGetEvent>((event, emit) async {
      emit(DetailTransactionLoadingState());
      Either<AppFailure, DetailTransactionEntity> result;
      if (event.transactionDetailType == TransactionDetailType.withdrawal) {
        result = await getDetailTransactionWithdrawUc(event.transactionCode);
      } else if (event.transactionDetailType == TransactionDetailType.elite) {
        result = await getDetailTransactionEliteUc(event.transactionCode);
      } else {
        result = await getTransactionDetailUc(event.transactionCode);
      }
      result.fold(
        (l) => emit(DetailTransactionFailureState(l, l.code, l.messages)),
        (r) => emit(DetailTransactionSuccessState(r)),
      );
    });
  }
}

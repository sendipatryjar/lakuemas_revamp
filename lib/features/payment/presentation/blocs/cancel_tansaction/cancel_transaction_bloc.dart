import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/constants/transaction_status.dart';
import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/cancel_transaction_uc.dart';
import '../../../domain/usecases/update_status_uc.dart';

part 'cancel_transaction_event.dart';
part 'cancel_transaction_state.dart';

class CancelTransactionBloc extends Bloc<CancelTransactionEvent, CancelTransactionState> {
  final UpdateStatusUc updateStatusUc;
  final CancelTransactionUc cancelTransactionUc;

  CancelTransactionBloc({
    required this.updateStatusUc,
    required this.cancelTransactionUc,
  }) : super(CancelTransactionInitialState()) {
    on<CancelTransactionNowEvent>((event, emit) async {
      emit(CancelTransactionLoadingState());
      if (event.isUpdateStatusFirst == false) {
        await _cancelTransaction(
          trxCode: event.transactionCode,
          onFailed: (l) {
            emit(CancelTransactionFailureState(l, l.code, l.messages));
          },
          onSuccess: (r) {
            emit(const CancelTransactionSuccessState(isUpdateStatusSuccess: false));
          },
        );
        return;
      }
      final result = await updateStatusUc(event.transactionCode ?? "");
      if (result.isRight()) {
        final usresult = result.toOption().toNullable();
        if (usresult?.status == TransactionStatus.success || usresult?.status == TransactionStatus.debetSuccess) {
          emit(const CancelTransactionSuccessState(isUpdateStatusSuccess: true));
          return;
        }

        await _cancelTransaction(
          trxCode: event.transactionCode,
          onFailed: (l) {
            emit(CancelTransactionFailureState(l, l.code, l.messages));
          },
          onSuccess: (r) {
            emit(const CancelTransactionSuccessState(isUpdateStatusSuccess: false));
            return;
          },
        );
      } else {
        emit(CancelTransactionInitialState());
        return;
      }
    });
  }

  Future _cancelTransaction(
      {required String? trxCode,
      required Function(AppFailure l) onFailed,
      required Function(String? r) onSuccess}) async {
    final resultCancel = await cancelTransactionUc(trxCode);
    resultCancel.fold(
      (l) => onFailed(l),
      (r) => onSuccess(r),
    );
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/transfer_checkout_uc.dart';

part 'transfer_checkout_event.dart';
part 'transfer_checkout_state.dart';

class TransferCheckoutBloc
    extends Bloc<TransferCheckoutEvent, TransferCheckoutState> {
  final TransferCheckoutUc transferCheckoutUc;

  TransferCheckoutBloc({required this.transferCheckoutUc})
      : super(TransferCheckoutInitialState()) {
    on<TransferCheckoutNowEvent>((event, emit) async {
      emit(TransferCheckoutLoadingState());
      final result =
          await transferCheckoutUc(transactionKey: event.transactionKey);
      result.fold(
        (l) => emit(TransferCheckoutFailureState(l, l.code, l.messages)),
        (r) => emit(TransferCheckoutSuccessState(
            transactionCode: r?.transactionCode ?? '')),
      );
    });

    on<TransferCheckoutInitEvent>(
        (event, emit) => emit(TransferCheckoutInitialState()));
  }
}

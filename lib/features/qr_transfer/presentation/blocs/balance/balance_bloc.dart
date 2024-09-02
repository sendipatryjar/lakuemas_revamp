import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../features/qr_transfer/domain/usecases/get_balances_uc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../_core/user/domain/entities/balance_entity.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class QRTransferBalanceBloc
    extends Bloc<QRTransferBalanceEvent, QRTransferBalanceState> {
  final QRTransferGetBalanceUc qrTransferGetBalanceUc;

  QRTransferBalanceBloc({
    required this.qrTransferGetBalanceUc,
  }) : super(QRTransferInitialState()) {
    on<QRTransferBalanceGetEvent>((event, emit) async {
      emit(QRTransferLoadingState());
      final result = await qrTransferGetBalanceUc();
      result.fold(
        (l) => emit(QrTransferFailureState(l, l.code, l.messages)),
        (r) {
          final gBalance = r
              .where((element) => element.type?.toLowerCase() == 'gold_balance')
              .first;
          emit(QRTransferSuccessState(
            goldBalanceEntity: gBalance,
            name: event.accountName,
          ));
        },
      );
    });
  }
}

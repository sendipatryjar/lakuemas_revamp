import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/laku_trade_checkout_entity.dart';
import '../../../domain/usecases/laku_trade_checkout_uc.dart';

part 'laku_trade_checkout_event.dart';
part 'laku_trade_checkout_state.dart';

class LakuTradeCheckoutBloc
    extends Bloc<LakuTradeCheckoutEvent, LakuTradeCheckoutState> {
  final LakuTradeCheckoutUc lakuTradeCheckoutUc;

  LakuTradeCheckoutBloc({required this.lakuTradeCheckoutUc})
      : super(LakuTradeCheckoutInitialState()) {
    on<LakuTradeCheckoutNowEvent>((event, emit) async {
      emit(LakuTradeCheckoutLoadingState());
      final result = await lakuTradeCheckoutUc(code: event.qrcode);
      result.fold(
        (l) => emit(LakuTradeCheckoutFailureState(l, l.code, l.messages)),
        (r) => emit(LakuTradeCheckoutSuccessState(data: r)),
      );
    });
  }
}

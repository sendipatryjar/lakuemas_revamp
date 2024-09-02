import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../_core/transaction/domain/entities/checkout_entity.dart';
import '../../../domain/usecases/sell_gold_checkout_uc.dart';

part 'sell_gold_checkout_event.dart';
part 'sell_gold_checkout_state.dart';

class SellGoldCheckoutBloc
    extends Bloc<SellGoldCheckoutEvent, SellGoldCheckoutState> {
  final SellGoldCheckoutUc sellGoldCheckoutUc;

  SellGoldCheckoutBloc({required this.sellGoldCheckoutUc})
      : super(SellGoldCheckoutInitialState()) {
    on<SellGoldCheckoutNowEvent>((event, emit) async {
      emit(SellGoldCheckoutLoadingState());
      final result = await sellGoldCheckoutUc(
        amount: event.amount,
        amountType: event.amountType,
      );
      result.fold(
        (l) => emit(SellGoldCheckoutFailureState(l, l.code, l.messages)),
        (r) {
          emit(SellGoldCheckoutSuccessState(checkoutEntity: r));
        },
      );
    });
  }
}

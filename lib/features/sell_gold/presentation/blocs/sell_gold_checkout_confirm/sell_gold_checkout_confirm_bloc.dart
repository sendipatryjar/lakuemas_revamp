import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/checkout_confirm_entity.dart';
import '../../../domain/usecases/sell_gold_checkout_confirm_uc.dart';

part 'sell_gold_checkout_confirm_event.dart';
part 'sell_gold_checkout_confirm_state.dart';

class SellGoldCheckoutConfirmBloc
    extends Bloc<SellGoldCheckoutConfirmEvent, SellGoldCheckoutConfirmState> {
  final SellGoldCheckoutConfirmUc sellGoldCheckoutConfirmUc;

  SellGoldCheckoutConfirmBloc({required this.sellGoldCheckoutConfirmUc})
      : super(SellGoldCheckoutConfirmInitialState()) {
    on<SellGoldCheckoutConfirmNowEvent>((event, emit) async {
      emit(SellGoldCheckoutConfirmLoadingState());
      final resutl =
          await sellGoldCheckoutConfirmUc(transactionKey: event.transactionKey);
      resutl.fold(
        (l) => emit(SellGoldCheckoutConfirmFailureState(l, l.code, l.messages)),
        (r) =>
            emit(SellGoldCheckoutConfirmSuccessState(checkoutConfirmEntity: r)),
      );
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../_core/transaction/domain/entities/checkout_entity.dart';
import '../../../domain/usecases/checkout_uc.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutUc checkoutUc;
  CheckoutBloc({required this.checkoutUc}) : super(CheckoutInitialState()) {
    on<CheckoutNowEvent>((event, emit) async {
      emit(CheckoutLoadingState());
      final result = await checkoutUc(
        amount: event.amount,
        amountType: event.amountType,
      );
      result.fold(
        (l) => emit(CheckoutFailureState(l, l.code, l.messages)),
        (r) {
          emit(CheckoutSuccessState(checkoutEntity: r));
        },
      );
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/usecases/lakusave_checkout_uc.dart';

part 'lakusave_checkout_event.dart';
part 'lakusave_checkout_state.dart';

class LakusaveCheckoutBloc
    extends Bloc<LakusaveCheckoutEvent, LakusaveCheckoutState> {
  final LakusaveCheckoutUc lakusaveCheckoutUc;

  LakusaveCheckoutBloc({required this.lakusaveCheckoutUc})
      : super(LakusaveCheckoutInitialState()) {
    on<LakusaveCheckoutDoNowEvent>((event, emit) async {
      emit(LakusaveCheckoutLoadingState());
      final result = await lakusaveCheckoutUc(LakusaveChekcoutParams(
        durationId: event.durationId,
        extendedId: event.extendedId,
        goldWeight: event.goldWeight,
        accountNumber: event.accountNumber,
        accountNumberDest: event.accountNumberDest,
      ));
      result.fold(
        (l) => emit(LakusaveCheckoutFailureState(l, l.code, l.messages)),
        (r) => emit(LakusaveCheckoutSuccessState()),
      );
    });

    on<LakusaveCheckoutInitEvent>(
        (event, emit) => emit(LakusaveCheckoutInitialState()));
  }
}

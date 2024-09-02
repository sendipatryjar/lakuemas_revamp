import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../domain/entities/payment_method_entity.dart';
import '../../../domain/usecases/get_payment_methods_uc.dart';

part 'payment_method_event.dart';
part 'payment_method_state.dart';

class PaymentMethodBloc extends Bloc<PaymentMethodEvent, PaymentMethodState> {
  final GetPaymentMethodsUc getPaymentMethodsUc;

  PaymentMethodBloc({required this.getPaymentMethodsUc})
      : super(PaymentMethodInitialState()) {
    on<PaymentMethodsGetEvent>((event, emit) async {
      if (event.helperDataCubit.state.paymentMethods.isNotEmpty) {
        emit(PaymentMethodSuccessState(
            event.helperDataCubit.state.paymentMethods));
        return;
      }
      emit(PaymentMethodLoadingState());
      final result = await getPaymentMethodsUc(event.actionType);
      result.fold(
        (l) => emit(PaymentMethodFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataCubit.updatePaymentMethods(r);
          emit(PaymentMethodSuccessState(r));
        },
      );
    });
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/payment_debet_entity.dart';
import '../../../domain/entities/payment_entity.dart';
import '../../../domain/usecases/payment_uc.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentUc paymentUc;

  PaymentBloc({required this.paymentUc}) : super(PaymentInitialState()) {
    on<PaymentDoNowEvent>((event, emit) async {
      emit(PaymentLoadingState());
      final result = await paymentUc(PaymentParams(
        paymentMethodId: event.paymentMethodId,
        transactionKey: event.transactionKey,
        jeniusCashtag: event.jeniusCashtag,
        couponCode: event.couponCode,
        phoneNumber: event.phoneNumber,
        paymentDebetEntity: event.paymentDebetEntity,
      ));
      result.fold(
        (l) => emit(PaymentFailureState(l, l.code, l.messages)),
        (r) => emit(PaymentSuccessState(r)),
      );
    });
  }
}

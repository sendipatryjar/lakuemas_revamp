import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../coupon/domain/usecases/coupon_validation_uc.dart';

part 'payment_coupon_validation_event.dart';
part 'payment_coupon_validation_state.dart';

class PaymentCouponValidationBloc
    extends Bloc<PaymentCouponValidationEvent, PaymentCouponValidationState> {
  final CouponValidationUc couponValidationUc;
  PaymentCouponValidationBloc({required this.couponValidationUc})
      : super(PaymentCouponValidationInitialState()) {
    on<PaymentCouponValidationTriggerEvent>((event, emit) async {
      emit(PaymentCouponValidationLoadingState());
      final result = await couponValidationUc(
        couponCode: event.couponCode,
        amount: event.amount,
        paymentMethodId: event.paymentMethodId,
      );
      result.fold(
        (l) => emit(PaymentCouponValidationFailureState(l, l.code, l.messages)),
        (r) => emit(PaymentCouponValidationSuccessState(isValid: r)),
      );
    });
  }
}

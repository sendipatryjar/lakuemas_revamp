import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../coupon/domain/usecases/coupon_validation_uc.dart';

part 'coupon_validation_event.dart';
part 'coupon_validation_state.dart';

class CouponValidationBloc
    extends Bloc<CouponValidationEvent, CouponValidationState> {
  final CouponValidationUc couponValidationUc;
  CouponValidationBloc({required this.couponValidationUc})
      : super(CouponValidationInitialState()) {
    on<CouponValidationTriggerEvent>((event, emit) async {
      emit(CouponValidationLoadingState());
      final result = await couponValidationUc(
        couponCode: event.couponCode,
        amount: event.amount,
        paymentMethodId: event.paymentMethodId,
      );
      result.fold(
        (l) => emit(CouponValidationFailureState(l, l.code, l.messages)),
        (r) => emit(CouponValidationSuccessState(isValid: r)),
      );
    });
  }
}

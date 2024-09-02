import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/coupon_entity.dart';
import '../../../domain/usecases/get_coupons_uc.dart';

part 'coupon_event.dart';
part 'coupon_state.dart';

class CouponBloc extends Bloc<CouponEvent, CouponState> {
  final GetCouponsUc getCouponsUc;

  CouponBloc({
    required this.getCouponsUc,
  }) : super(CouponInitialState()) {
    on<CouponsGetEvent>((event, emit) async {
      emit(CouponLoadingState());
      final result = await getCouponsUc();
      result.fold(
          (l) => emit(CouponFailureState(l, l.code, l.messages)),
          (r) => emit(CouponSuccessState(
                coupons: r,
              )));
    });
  }
}

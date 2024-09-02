import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/coupon_detail_entity.dart';
import '../../../domain/usecases/get_coupon_detail_uc.dart';

part 'coupon_detail_event.dart';
part 'coupon_detail_state.dart';

class CouponDetailBloc extends Bloc<CouponDetailEvent, CouponDetailState> {
  final GetCouponDetailUc getCouponDetailUc;

  CouponDetailBloc({
    required this.getCouponDetailUc,
  }) : super(CouponDetailInitialState()) {
    on<CouponDetailGetEvent>((event, emit) async {
      emit(CouponDetailLoadingState());
      final result = await getCouponDetailUc(couponCode: event.couponCode);
      result.fold(
        (l) => emit(CouponDetailFailureState(l, l.code, l.messages)),
        (r) => emit(CouponDetailSuccessState(couponDetail: r)),
      );
    });

    on<CouponDetailInitEvent>(
      (event, emit) => emit(CouponDetailInitialState()),
    );
  }
}

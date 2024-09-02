import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/voucher_redeem_entity.dart';
import '../../../domain/usecases/voucher_redeem_check_uc.dart';

part 'redeem_check_event.dart';
part 'redeem_check_state.dart';

class RedeemCheckBloc extends Bloc<RedeemCheckEvent, RedeemCheckState> {
  final VoucherRedeemCheckUc voucherRedeemCheckUc;

  RedeemCheckBloc({required this.voucherRedeemCheckUc})
      : super(RedeemCheckInitialState()) {
    on<RedeemCheckNowEvent>((event, emit) async {
      if (event.voucherCode.isEmpty) {
        return emit(const RedeemCheckFailureState(
            MobileValidationFailure(), null, null));
      }
      emit(RedeemCheckLoadingState());
      final result = await voucherRedeemCheckUc(voucherCode: event.voucherCode);
      result.fold(
        (l) => emit(RedeemCheckFailureState(l, l.code, l.messages)),
        (r) => emit(RedeemCheckSuccessState(voucherRedeemEntity: r)),
      );
    });

    on<RedeemCheckResetEvent>((event, emit) => emit(RedeemCheckInitialState()));
  }
}

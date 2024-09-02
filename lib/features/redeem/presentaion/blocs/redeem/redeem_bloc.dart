import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/voucher_redeemed_entity.dart';
import '../../../domain/usecases/voucher_redeem_uc.dart';

part 'redeem_event.dart';
part 'redeem_state.dart';

class RedeemBloc extends Bloc<RedeemEvent, RedeemState> {
  final VoucherRedeemUc voucherRedeemUc;
  RedeemBloc({required this.voucherRedeemUc}) : super(RedeemInitialState()) {
    on<RedeemNowEvent>((event, emit) async {
      emit(RedeemLoadingState());
      final result = await voucherRedeemUc(
        voucherCode: event.voucherCode,
        goldRedeemed: event.goldRedeemed,
      );
      result.fold(
        (l) => emit(RedeemFailureState(l, l.code, l.messages)),
        (r) => emit(RedeemSuccessState(voucherRedeemedEntity: r)),
      );
    });
  }
}

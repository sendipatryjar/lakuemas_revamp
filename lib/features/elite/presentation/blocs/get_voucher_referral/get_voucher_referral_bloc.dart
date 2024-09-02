import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../features/elite/domain/usecases/get_voucher_referral_uc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data_elite/helper_data_elite_cubit.dart';
import '../../../domain/entities/voucher_referral_entity.dart';

part 'get_voucher_referral_event.dart';
part 'get_voucher_referral_state.dart';

class GetVoucherReferralBloc
    extends Bloc<GetVoucherReferralEvent, GetVoucherReferralState> {
  final GetVoucherReferralUc getVoucherReferralUc;

  GetVoucherReferralBloc({required this.getVoucherReferralUc})
      : super(GetVoucherReferralInitial()) {
    on<GetVoucherReferralLoadEvent>((event, emit) async {
      // if ((event.helperDataEliteCubit.state.listVoucherReferralEntity ?? [])
      //     .isNotEmpty) {
      //   emit(GetVoucherReferralSuccessState(
      //       event.helperDataEliteCubit.state.listVoucherReferralEntity!));
      //   return;
      // }
      emit(GetVoucherReferralLoadingState());
      final result = await getVoucherReferralUc();
      result.fold(
        (l) => emit(GetVoucherReferralFailureState(l, l.code, l.messages)),
        (r) {
          var listVoucher = r;
          listVoucher.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

          event.helperDataEliteCubit
              .updateListVoucherReferralEntity(listVoucher);
          emit(GetVoucherReferralSuccessState(r));
        },
      );
    });
  }
}

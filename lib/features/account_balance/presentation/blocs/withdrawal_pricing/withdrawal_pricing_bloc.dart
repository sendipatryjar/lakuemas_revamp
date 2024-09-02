import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../_core/transaction/domain/entities/price_entity.dart';
import '../../../domain/usecases/withdrawal_get_price_uc.dart';

part 'withdrawal_pricing_event.dart';
part 'withdrawal_pricing_state.dart';

class WithdrawalPricingBloc
    extends Bloc<WithdrawalPricingEvent, WithdrawalPricingState> {
  final WithdrawalGetPriceUc withdrawalGetPriceUc;

  WithdrawalPricingBloc({required this.withdrawalGetPriceUc})
      : super(WithdrawalPricingInitialState()) {
    on<WithdrawalPricingGetEvent>((event, emit) async {
      if (event.helperDataCubit.state.priceSettingsWithdrawal != null) {
        emit(WithdrawalPricingSuccessState(
            priceEntity: event.helperDataCubit.state.priceSettingsWithdrawal));
        return;
      }
      emit(WithdrawalPricingLoadingState());
      final result = await withdrawalGetPriceUc();
      result.fold(
        (l) => emit(WithdrawalPricingFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataCubit.updatePriceWithdrawal(r);
          emit(WithdrawalPricingSuccessState(priceEntity: r));
        },
      );
    });
  }
}

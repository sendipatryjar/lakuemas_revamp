import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../_core/transaction/domain/entities/price_entity.dart';
import '../../../domain/usecases/get_price_uc.dart';

part 'sgold_pricing_event.dart';
part 'sgold_pricing_state.dart';

class SgoldPricingBloc extends Bloc<SgoldPricingEvent, SgoldPricingState> {
  final GetPriceUc getPriceUc;

  SgoldPricingBloc({required this.getPriceUc})
      : super(SgoldPricingInitialState()) {
    on<SgoldPricingGetEvent>((event, emit) async {
      if (event.helperDataCubit.state.priceSettingsSellGold != null) {
        emit(SgoldPricingSuccessState(
            priceEntity: event.helperDataCubit.state.priceSettingsSellGold));
        return;
      }
      emit(SgoldPricingLoadingState());
      final result = await getPriceUc();
      result.fold(
        (l) => emit(SgoldPricingFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataCubit.updatePriceSettingsSellGold(r);
          emit(SgoldPricingSuccessState(priceEntity: r));
        },
      );
    });
  }
}

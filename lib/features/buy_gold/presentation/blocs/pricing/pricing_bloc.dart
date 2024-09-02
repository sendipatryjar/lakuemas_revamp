import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../_core/transaction/domain/entities/price_entity.dart';
import '../../../domain/usecases/get_price_uc.dart';

part 'pricing_event.dart';
part 'pricing_state.dart';

class PricingBloc extends Bloc<PricingEvent, PricingState> {
  final GetPriceUc getPriceUc;

  PricingBloc({required this.getPriceUc}) : super(PricingInitialState()) {
    on<PricingGetEvent>((event, emit) async {
      if (event.helperDataCubit.state.priceSettingsBuyGold != null) {
        emit(PricingSuccessState(
            priceEntity: event.helperDataCubit.state.priceSettingsBuyGold));
        return;
      }
      emit(PricingLoadingState());
      final result = await getPriceUc();
      result.fold(
        (l) => emit(PricingFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataCubit.updatePriceSettingsBuyGold(r);
          emit(PricingSuccessState(priceEntity: r));
        },
      );
    });
  }
}

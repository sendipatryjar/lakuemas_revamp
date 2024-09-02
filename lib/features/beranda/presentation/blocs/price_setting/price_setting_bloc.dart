import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../_core/transaction/domain/entities/price_entity.dart';
import '../../../domain/usecases/get_price_setting_uc.dart';

part 'price_setting_event.dart';
part 'price_setting_state.dart';

class PriceSettingBloc extends Bloc<PriceSettingEvent, PriceSettingState> {
  final GetPriceSettingUc getPriceSettingUc;

  PriceSettingBloc({required this.getPriceSettingUc})
      : super(PriceSettingInitialState()) {
    on<PriceSettingGetEvent>((event, emit) async {
      if (event.helperDataCubit.state.priceSettings != null &&
          event.isNeedRefresh == false) {
        emit(PriceSettingSuccessState(
            priceEntity: event.helperDataCubit.state.priceSettings!));
        return;
      }
      emit(PriceSettingLoadingState());
      final result = await getPriceSettingUc();
      result.fold(
        (l) => emit(PriceSettingFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataCubit.updatePriceSettings(r);
          emit(PriceSettingSuccessState(priceEntity: r));
        },
      );
    });
  }
}

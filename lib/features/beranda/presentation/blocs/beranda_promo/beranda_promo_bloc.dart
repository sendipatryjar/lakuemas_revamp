import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../domain/entities/promo_entity.dart';
import '../../../domain/usecases/get_promos_uc.dart';

part 'beranda_promo_event.dart';
part 'beranda_promo_state.dart';

class BerandaPromoBloc extends Bloc<BerandaPromoEvent, BerandaPromoState> {
  final GetPromosUc getPromosUc;

  BerandaPromoBloc({required this.getPromosUc})
      : super(BerandaPromosInitialState()) {
    on<BerandaPromoGetEvent>((event, emit) async {
      if (event.helperDataCubit.state.promos.isNotEmpty) {
        emit(BerandaPromosSuccessState(
            promoEntities: event.helperDataCubit.state.promos));
        return;
      }
      emit(BerandaPromosLoadingState());
      final result = await getPromosUc();
      result.fold(
        (l) => emit(BerandaPromosFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataCubit.updatePromos(r);
          emit(BerandaPromosSuccessState(promoEntities: r));
        },
      );
    });
  }
}

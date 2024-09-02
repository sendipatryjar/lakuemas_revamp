import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/promo_entity.dart';
import '../../../domain/usecases/get_promo_by_id_uc.dart';

part 'beranda_promo_detail_event.dart';
part 'beranda_promo_detail_state.dart';

class BerandaPromoDetailBloc extends Bloc<BerandaPromoDetailEvent, BerandaPromoDetailState> {
  final GetPromoByIdUc getPromoByIdUc;

  BerandaPromoDetailBloc({required this.getPromoByIdUc}) : super(BerandaPromoDetailInitialState()) {
    on<BerandaPromoDetailGetEvent>((event, emit) async {
      emit(BerandaPromoDetailLoadingState());
      final result = await getPromoByIdUc(id: event.id);
      result.fold(
        (l) => emit(BerandaPromoDetailFailureState(l, l.code, l.messages)),
        (r) => emit(BerandaPromoDetailSuccessState(promo: r)),
      );
    });
  }
}

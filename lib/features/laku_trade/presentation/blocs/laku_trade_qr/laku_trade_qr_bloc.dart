import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/laku_trade_qr_data_entity.dart';
import '../../../domain/usecases/get_qr_data_laku_trade_uc.dart';

part 'laku_trade_qr_event.dart';
part 'laku_trade_qr_state.dart';

class LakuTradeQrBloc extends Bloc<LakuTradeQrEvent, LakuTradeQrState> {
  final GetQrDataLakuTradeUc getQrDataLakuTradeUc;

  LakuTradeQrBloc({required this.getQrDataLakuTradeUc})
      : super(LakuTradeQrInitialState()) {
    on<LakuTradeQrGetDataEvent>((event, emit) async {
      emit(LakuTradeQrLoadingState());
      final result = await getQrDataLakuTradeUc(code: event.code);
      result.fold(
        (l) => emit(LakuTradeQrFailureState(l, l.code, l.messages)),
        (r) => emit(LakuTradeQrSuccessState(data: r)),
      );
    });
  }
}

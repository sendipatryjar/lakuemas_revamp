import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../features/physical_pull/domain/usecases/charge_uc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../_core/transaction/domain/entities/checkout_entity.dart';

part 'charge_event.dart';
part 'charge_state.dart';

class ChargeBloc extends Bloc<ChargeEvent, ChargeState> {
  final ChargeUc chargeUc;
  ChargeBloc({required this.chargeUc}) : super(ChargeInitialState()) {
    on<ChargePostEvent>((event, emit) async {
      emit(ChargeLoadingState());
      final result = await chargeUc(
          ChargeParams(listPhysicalPullReq: event.listPhysicalPullReq));
      result.fold(
        (l) => emit(ChargeFailureState(l, l.code, l.messages)),
        (r) => emit(ChargeSuccessState(r)),
      );
    });
  }
}

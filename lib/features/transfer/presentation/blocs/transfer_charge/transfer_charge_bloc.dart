import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/transfer_charge_entity.dart';
import '../../../domain/usecases/transfer_charge_uc.dart';

part 'transfer_charge_event.dart';
part 'transfer_charge_state.dart';

class TransferChargeBloc
    extends Bloc<TransferChargeEvent, TransferChargeState> {
  final TransferChargeUc transferChargeUc;

  TransferChargeBloc({required this.transferChargeUc})
      : super(TransferChargeInitialState()) {
    on<TransferChargeNowEvent>((event, emit) async {
      emit(TransferChargeLoadingState());
      final result = await transferChargeUc(
        isAddFavorite: event.isAddFavorite,
        goldWeight: event.goldWeight,
        accountNumber: event.accountNumber,
        note: event.note,
      );
      result.fold(
        (l) => emit(TransferChargeFailureState(l, l.code, l.messages)),
        (r) => emit(TransferChargeSuccessState(r)),
      );
    });
    on<TransferChargeInitEvent>(
        (event, emit) => emit(TransferChargeInitialState()));
  }
}

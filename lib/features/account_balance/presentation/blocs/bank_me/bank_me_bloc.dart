import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../domain/entities/bank_me_entity.dart';
import '../../../domain/usecases/get_bank_me_uc.dart';

part 'bank_me_event.dart';
part 'bank_me_state.dart';

class BankMeBloc extends Bloc<BankMeEvent, BankMeState> {
  final GetBankMeUc getBankMeUc;

  BankMeBloc({required this.getBankMeUc}) : super(BankMeInitialState()) {
    on<BankMeGetEvent>((event, emit) async {
      if (event.helperDataCubit.state.bankMeEntity != null) {
        emit(BankMeSuccessState(
            bankMeEntity: event.helperDataCubit.state.bankMeEntity));
        return;
      }
      emit(BankMeLoadingState());
      final result = await getBankMeUc();
      result.fold(
        (l) => emit(BankMeFailureState(l, l.code, l.messages)),
        (r) {
          event.helperDataCubit.updateBankMeEntity(r);
          emit(BankMeSuccessState(bankMeEntity: r));
        },
      );
    });
  }
}

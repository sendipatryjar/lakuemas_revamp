import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../domain/entities/withdrawal_entity.dart';
import '../../../domain/usecases/withdraw_uc.dart';

part 'withdrawal_event.dart';
part 'withdrawal_state.dart';

class WithdrawalBloc extends Bloc<WithdrawalEvent, WithdrawalState> {
  final WithdrawUc withdrawUc;

  WithdrawalBloc({required this.withdrawUc}) : super(WithdrawalInitialState()) {
    on<WithdrawalNowEvent>((event, emit) async {
      emit(WithdrawalLoadingState());
      final resul = await withdrawUc(amount: event.amount);
      resul.fold(
        (l) => emit(WithdrawalFailureState(l, l.code, l.messages)),
        (r) => emit(WithdrawalSuccessState(withdrawalEntity: r)),
      );
    });
  }
}

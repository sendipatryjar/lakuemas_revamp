import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../_core/user/domain/entities/balance_entity.dart';
import '../../../domain/usecases/get_balances_uc.dart';

part 'sgold_balance_event.dart';
part 'sgold_balance_state.dart';

class SgoldBalanceBloc extends Bloc<SgoldBalanceEvent, SgoldBalanceState> {
  final GetBalancesUc getBalancesUc;

  SgoldBalanceBloc({required this.getBalancesUc})
      : super(SgoldBalanceInitialState()) {
    on<SgoldGetBalanceEvent>((event, emit) async {
      if (event.helperDataCubit.state.balances.isNotEmpty) {
        final goldBalance = event.helperDataCubit.state.balances
            .where((element) => element.type?.toLowerCase() == 'gold_balance');
        if (goldBalance.isNotEmpty) {
          emit(SgoldBalanceSuccessState(balanceEntity: goldBalance.first));
          return;
        }
      }
      emit(SgoldBalanceLoadingState());
      final result = await getBalancesUc();
      result.fold(
        (l) => emit(SgoldBalanceFailureState(l, l.code, l.messages)),
        (r) {
          final balances = r.where(
              (element) => element.type?.toLowerCase() == 'gold_balance');
          BalanceEntity? balanceNeeded;
          if (balances.isNotEmpty) {
            balanceNeeded = balances.first;
          }
          emit(SgoldBalanceSuccessState(balanceEntity: balanceNeeded));
        },
      );
    });
  }
}

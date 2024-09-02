import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../_core/user/domain/entities/balance_entity.dart';
import '../../../domain/usecases/get_balances_uc.dart';

part 'bgold_balance_event.dart';
part 'bgold_balance_state.dart';

class BgoldBalanceBloc extends Bloc<BgoldBalanceEvent, BgoldBalanceState> {
  final GetBalancesUc getBalancesUc;

  BgoldBalanceBloc({required this.getBalancesUc})
      : super(BgoldBalanceInitialState()) {
    on<BgoldGetBalanceEvent>((event, emit) async {
      if (event.helperDataCubit.state.balances.isNotEmpty) {
        final goldBalance = event.helperDataCubit.state.balances
            .where((element) => element.type?.toLowerCase() == 'gold_balance');
        if (goldBalance.isNotEmpty) {
          emit(BgoldBalanceSuccessState(balanceEntity: goldBalance.first));
          return;
        }
      }
      emit(BgoldBalanceLoadingState());
      final result = await getBalancesUc();
      result.fold(
        (l) => emit(BgoldBalanceFailureState(l, l.code, l.messages)),
        (r) {
          final balances = r.where(
              (element) => element.type?.toLowerCase() == 'gold_balance');
          BalanceEntity? balanceNeeded;
          if (balances.isNotEmpty) {
            balanceNeeded = balances.first;
          }
          emit(BgoldBalanceSuccessState(balanceEntity: balanceNeeded));
        },
      );
    });
  }
}

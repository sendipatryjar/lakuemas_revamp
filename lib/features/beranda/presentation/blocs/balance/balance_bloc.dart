import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../_core/user/domain/entities/balance_entity.dart';
import '../../../domain/usecases/get_gold_balance_uc.dart';

part 'balance_event.dart';
part 'balance_state.dart';

class BerandaBalancesBloc
    extends Bloc<BerandaBalancesEvent, BerandaBalancesState> {
  final BerandaGetBalancesUc berandaGetBalancesUc;

  BerandaBalancesBloc({required this.berandaGetBalancesUc})
      : super(BerandaBalancesInitialState()) {
    on<BerandaBalancesGetEvent>((event, emit) async {
      if (event.helperDataCubit.state.balances.isEmpty) {
        emit(BerandaBalancesLoadingState());
        final result = await berandaGetBalancesUc();
        result.fold(
          (l) => emit(BerandaBalancesFailureState(l, l.code, l.messages)),
          (r) {
            event.helperDataCubit.updateBalances(r);
            var balances = _separateBalance(r);
            emit(BerandaBalancesSuccessState(
              goldBalanceEntity: balances[0],
              accountBalanceEntity: balances[1],
              lakusaveBalance: balances[2],
            ));
          },
        );
        return;
      }
      var balances = _separateBalance(event.helperDataCubit.state.balances);
      emit(BerandaBalancesSuccessState(
        goldBalanceEntity: balances[0],
        accountBalanceEntity: balances[1],
        lakusaveBalance: balances[2],
      ));
    });

    on<BerandaBalancesCopyValueEvent>((event, emit) async {
      emit(event.berandaBalanceBloc.state);
    });
  }

  List _separateBalance(List<BalanceEntity> r) {
    final gBalance = r
        .where((element) => element.type?.toLowerCase() == 'gold_balance')
        .firstOrNull;
    final accBalance = r
        .where((element) => element.type?.toLowerCase() == 'account_balance')
        .firstOrNull;
    final depoBalance = r
        .where((element) => element.type?.toLowerCase() == 'deposit_balance')
        .toList();

    double depoBalanceTotal = 0;
    if (depoBalance.isNotEmpty) {
      depoBalanceTotal = depoBalance
          .map((e) => double.parse(e.gramationBalance ?? '0'))
          .reduce((value, element) => value + element);
    }
    return [gBalance, accBalance, depoBalanceTotal];
  }
}

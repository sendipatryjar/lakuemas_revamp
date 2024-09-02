import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../cores/errors/app_failure.dart';
import '../../../../_core/user/domain/entities/balance_entity.dart';
import '../../../domain/usecases/get_gold_details_balance_uc.dart';

part 'gold_details_balances_event.dart';
part 'gold_details_balances_state.dart';

class GoldDetailsBalancesBloc
    extends Bloc<GoldDetailsBalancesEvent, GoldDetailsBalancesState> {
  final GetGoldDetailsBalanceUc getGoldDetailsBalanceUc;

  GoldDetailsBalancesBloc({required this.getGoldDetailsBalanceUc})
      : super(GoldDetailsBalancesInitialState()) {
    on<GoldDetailsBalancesEvent>((event, emit) async {
      emit(GoldDetailsBalanceLoadingState());
      final result = await getGoldDetailsBalanceUc();
      result.fold(
        (l) => emit(GoldDetailsBalanceFailureState(l, l.code, l.messages)),
        (r) {
          final gBalance = r
              .where((element) => element.type?.toLowerCase() == 'gold_balance')
              .first;
          final depBalance = r
              .where(
                  (element) => element.type?.toLowerCase() == 'deposit_balance')
              .toList();

          var totalListDepBalance = r.where(
              (element) => element.type?.toLowerCase() == 'deposit_balance');

          final totalDepBalance = totalListDepBalance.isNotEmpty
              ? totalListDepBalance
                  .map(
                      (e) => double.parse(e.gramationBalance ?? '0').toDouble())
                  .reduce((a, b) => (a + b))
              : 0;
          final totalDepNominalBalance = totalListDepBalance.isNotEmpty
              ? totalListDepBalance
                  .map((e) => e.nominalBalance)
                  .reduce((a, b) => (a! + b!))
              : 0;
          final totalGold =
              double.parse(gBalance.gramationBalance ?? '0') + totalDepBalance;
          final totalNominal =
              gBalance.nominalBalance! + totalDepNominalBalance!;

          emit(GoldDetailsBalanceSuccessState(
            goldBalanceEntity: gBalance,
            depositBalanceEntity: depBalance,
            totalDepBalance: totalDepBalance.toStringAsFixed(4),
            totalGold: totalGold.toStringAsFixed(4),
            totalNominal: totalNominal,
          ));
        },
      );
    });
  }
}

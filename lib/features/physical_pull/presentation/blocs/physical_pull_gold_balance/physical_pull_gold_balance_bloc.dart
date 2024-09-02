import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../features/physical_pull/domain/usecases/physical_pull_gold_balance_uc.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../_core/user/domain/entities/balance_entity.dart';

part 'physical_pull_gold_balance_event.dart';
part 'physical_pull_gold_balance_state.dart';

class PhysicalPullGoldBalanceBloc
    extends Bloc<PhysicalPullGoldBalanceEvent, PhysicalPullGoldBalanceState> {
  final PhysicalPullGoldBalanceUc physicalPullGoldBalanceUc;
  PhysicalPullGoldBalanceBloc({required this.physicalPullGoldBalanceUc})
      : super(PhysicalPullGoldBalanceInitialState()) {
    on<PhysicalPullGoldBalanceEvent>((event, emit) async {
      emit(PhysicalPullGoldBalanceLoadingState());
      final result = await physicalPullGoldBalanceUc();
      result.fold(
        (l) => emit(PhysicalPullGoldBalanceFailureState(l, l.code, l.messages)),
        (r) {
          final gBalance = r
              .where((element) => element.type?.toLowerCase() == 'gold_balance')
              .first;

          emit(PhysicalPullGoldBalanceSuccessState(
            goldBalanceEntity: gBalance,
          ));
        },
      );
    });
  }
}

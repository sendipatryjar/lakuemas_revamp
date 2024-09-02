import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../cores/errors/app_failure.dart';
import '../../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../_core/user/domain/entities/balance_entity.dart';
import '../../../domain/usecases/get_account_balance_uc.dart';

part 'account_balance_event.dart';
part 'account_balance_state.dart';

class AccountBalanceBloc
    extends Bloc<AccountBalanceEvent, AccountBalanceState> {
  final GetAccountBalanceUc getAccountBalanceUc;

  AccountBalanceBloc({required this.getAccountBalanceUc})
      : super(AccountBalanceInitialState()) {
    on<AccountBalanceGetEvent>((event, emit) async {
      if (event.helperDataCubit.state.balances.isNotEmpty) {
        final accBalance = event.helperDataCubit.state.balances.where(
            (element) => element.type?.toLowerCase() == 'account_balance');
        if (accBalance.isNotEmpty) {
          emit(AccountBalanceSuccessState(accBalance.first));
          return;
        }
      }
      emit(AccountBalanceLoadingState());
      final result = await getAccountBalanceUc();
      result.fold(
        (l) => emit(AccountBalanceFailureState(l, l.code, l.messages)),
        (r) => emit(AccountBalanceSuccessState(r)),
      );
    });
  }
}

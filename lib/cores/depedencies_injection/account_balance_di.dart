import '../../features/account_balance/data/data_sources/account_balance_remote_data_source.dart';
import '../../features/account_balance/data/data_sources/interfaces/i_account_balance_remote_data_source.dart';
import '../../features/account_balance/data/repositories/account_balance_repository.dart';
import '../../features/account_balance/domain/repositories/i_account_balance_repository.dart';
import '../../features/account_balance/domain/usecases/get_bank_me_uc.dart';
import '../../features/account_balance/domain/usecases/get_faq_uc.dart';
import '../../features/account_balance/domain/usecases/get_mutations_uc.dart';
import '../../features/account_balance/domain/usecases/withdraw_uc.dart';
import '../../features/account_balance/domain/usecases/withdrawal_get_price_uc.dart';
import '../../features/account_balance/presentation/blocs/bank_me/bank_me_bloc.dart';
import '../../features/account_balance/presentation/blocs/faq/faq_bloc.dart';
import '../../features/account_balance/presentation/blocs/mutation/mutation_bloc.dart';
import '../../features/account_balance/presentation/blocs/mutation_onprocess/mutation_onprocess_bloc.dart';
import '../../features/account_balance/presentation/blocs/withdrawal/withdrawal_bloc.dart';
import '../../features/account_balance/presentation/blocs/withdrawal_pricing/withdrawal_pricing_bloc.dart';
import '../../features/account_balance/presentation/cubits/cash_withdrawal/cash_withdrawal_cubit.dart';
import '../../features/account_balance/presentation/cubits/filter_date/filter_date_cubit.dart';
import '../../features/account_balance/presentation/cubits/filter_history_tab/filter_history_tab_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IAccountBalanceRemoteDataSource>(
      () => AccountBalanceRemoteDataSource(
            apiService: sl(),
          ));

  //! repositories
  sl.registerFactory<IAccountBalanceRepository>(() => AccountBalanceRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => GetMutationsUc(repository: sl()));
  sl.registerFactory(() => GetFaqUc(repository: sl()));
  sl.registerFactory(() => WithdrawalGetPriceUc(repository: sl()));
  sl.registerFactory(() => GetBankMeUc(repository: sl()));
  sl.registerFactory(() => WithdrawUc(repository: sl()));

  //! bloc
  sl.registerFactory(() => MutationBloc(getMutationsUc: sl()));
  sl.registerFactory(() => MutationOnprocessBloc(getMutationsUc: sl()));
  sl.registerFactory(() => AccountBalanceFaqBloc(getFaqUc: sl()));
  sl.registerFactory(() => WithdrawalPricingBloc(withdrawalGetPriceUc: sl()));
  sl.registerFactory(() => BankMeBloc(getBankMeUc: sl()));
  sl.registerFactory(() => WithdrawalBloc(withdrawUc: sl()));

  //! cubit
  sl.registerFactory(() => CashWithdrawalCubit());
  sl.registerFactory(() => FilterHistoryTabCubit());
  sl.registerFactory(() => FilterDateCubit());
}

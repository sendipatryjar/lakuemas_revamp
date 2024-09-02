import '../../features/payment/data/data_sources/interfaces/i_payment_remote_data_source.dart';
import '../../features/payment/data/data_sources/payment_remote_data_source.dart';
import '../../features/payment/data/repositories/payment_repository.dart';
import '../../features/payment/domain/repositories/i_payment_repository.dart';
import '../../features/payment/domain/usecases/cancel_transaction_uc.dart';
import '../../features/payment/domain/usecases/get_account_balance_uc.dart';
import '../../features/payment/domain/usecases/get_detail_transaction_elite_uc.dart';
import '../../features/payment/domain/usecases/get_detail_transaction_withdraw_uc.dart';
import '../../features/payment/domain/usecases/get_payment_methods_uc.dart';
import '../../features/payment/domain/usecases/get_transaction_detail_uc.dart';
import '../../features/payment/domain/usecases/payment_uc.dart';
import '../../features/payment/domain/usecases/update_status_uc.dart';
import '../../features/payment/presentation/blocs/account_balance/account_balance_bloc.dart';
import '../../features/payment/presentation/blocs/cancel_tansaction/cancel_transaction_bloc.dart';
import '../../features/payment/presentation/blocs/detail_transaction/detail_transaction_bloc.dart';
import '../../features/payment/presentation/blocs/payment/payment_bloc.dart';
import '../../features/payment/presentation/blocs/payment_coupon_validation/payment_coupon_validation_bloc.dart';
import '../../features/payment/presentation/blocs/payment_method/payment_method_bloc.dart';
import '../../features/payment/presentation/blocs/update_status/update_status_bloc.dart';
import '../../features/payment/presentation/cubits/payment/payment_cubit.dart';
import 'depedency_injection.dart';

Future<void> init() async {
  //! data sources
  sl.registerFactory<IPaymentRemoteDataSource>(() => PaymentRemoteDataSource(
        apiService: sl(),
      ));

  //! repositories
  sl.registerFactory<IPaymentRepository>(() => PaymentRepository(
        remoteDataSource: sl(),
        tokenLocalDataSource: sl(),
      ));

  //! usecases
  sl.registerFactory(() => GetPaymentMethodsUc(
        repository: sl(),
      ));
  sl.registerFactory(() => GetAccountBalanceUc(
        repository: sl(),
      ));
  sl.registerFactory(() => PaymentUc(
        repository: sl(),
      ));
  sl.registerFactory(() => GetTransactionDetailUc(
        repository: sl(),
      ));
  sl.registerFactory(() => GetDetailTransactionWithdrawUc(
        repository: sl(),
      ));
  sl.registerFactory(() => GetDetailTransactionEliteUc(
        repository: sl(),
      ));
  sl.registerFactory(() => UpdateStatusUc(
        repository: sl(),
      ));
  sl.registerFactory(() => CancelTransactionUc(
        repository: sl(),
      ));

  //! bloc
  sl.registerFactory(() => PaymentMethodBloc(
        getPaymentMethodsUc: sl(),
      ));
  sl.registerFactory(() => AccountBalanceBloc(
        getAccountBalanceUc: sl(),
      ));
  sl.registerFactory(() => PaymentBloc(
        paymentUc: sl(),
      ));
  sl.registerFactory(() => DetailTransactionBloc(
        getTransactionDetailUc: sl(),
        getDetailTransactionWithdrawUc: sl(),
        getDetailTransactionEliteUc: sl(),
      ));
  sl.registerFactory(() => UpdateStatusBloc(
        updateStatusUc: sl(),
      ));
  sl.registerFactory(() => PaymentCouponValidationBloc(
        couponValidationUc: sl(),
      ));
  sl.registerFactory(() => CancelTransactionBloc(
        updateStatusUc: sl(),
        cancelTransactionUc: sl(),
      ));

  //! cubit
  sl.registerFactory(() => PaymentCubit());
}

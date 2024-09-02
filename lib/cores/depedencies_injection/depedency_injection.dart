import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../services/api_service.dart';
import '../services/cubits/elite/elite_cubit.dart';
import '../services/cubits/helper_data/helper_data_cubit.dart';
import '../services/local_data_source/i_token_local_data_source.dart';
import '../services/local_data_source/token_local_data_source.dart';
import '../services/secure_storage_service.dart';
import '../widgets/checkbox/cubit/main_checkbox_cubit.dart';
import 'language_di.dart' as language;
import 'login_di.dart' as login;
import 'register_di.dart' as register;
import 'forgot_di.dart' as forgot;
import 'otp_di.dart' as otp;
import 'pin_di.dart' as pin;
import 'beranda_di.dart' as beranda;
import 'profile_di.dart' as profile;
import 'close_account_di.dart' as close_account;
import 'settings_di.dart' as settings;
import 'kyc_di.dart' as kyc;
import 'bank_account_di.dart' as bank_account;
import 'elite_di.dart' as elite;
import 'buy_gold_di.dart' as buy_gold;
import 'sell_gold_di.dart' as sell_gold;
import 'payment_di.dart' as payment;
import 'redeem_di.dart' as redeem;
import 'physical_pull_di.dart' as physical_pull;
import 'laku_save_di.dart' as laku_save;
import 'transfer_di.dart' as transfer;
import 'gold_price_chart_di.dart' as gold_price_chart;
import 'gold_details_di.dart' as gold_details;
import 'account_balance_di.dart' as account_balance;
import 'notification_di.dart' as notification;
import 'support_di.dart' as support;
import 'elite_bonuses_di.dart' as elite_bonuses;
import 'article_di.dart' as article;
import 'coupon_di.dart' as coupon;
import 'qr_transfer_di.dart' as qr_transfer;
import 'portofolio_di.dart' as portofolio;
import 'laku_trade_di.dart' as laku_trade;
import 'avatar_di.dart' as avatar;
import 'dice_di.dart' as dice;

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => Dio());
  sl.registerFactory(() => SecureStorageService());
  sl.registerFactory<ITokenLocalDataSource>(() => TokenLocalDataSource(secureStorageService: sl()));
  sl.registerFactory(() => ApiService(
        dio: sl(),
        tokenDio: sl(),
        secureStorageService: sl(),
      ));
  // sl.registerFactory(() => InternetConnectionService());
  sl.registerFactory(() => MainCheckboxCubit());
  sl.registerFactory(() => EliteCubit());
  sl.registerFactory(() => HelperDataCubit());
  await Future.wait([
    language.init(),
    login.init(),
    register.init(),
    forgot.init(),
    otp.init(),
    pin.init(),
    beranda.init(),
    profile.init(),
    close_account.init(),
    settings.init(),
    // npwp.init();
    kyc.init(),
    bank_account.init(),
    elite.init(),
    buy_gold.init(),
    payment.init(),
    sell_gold.init(),
    redeem.init(),
    physical_pull.init(),
    laku_save.init(),
    transfer.init(),
    gold_price_chart.init(),
    gold_details.init(),
    account_balance.init(),
    notification.init(),
    support.init(),
    elite_bonuses.init(),
    article.init(),
    coupon.init(),
    qr_transfer.init(),
    portofolio.init(),
    laku_trade.init(),
    avatar.init(),
    dice.init(),
  ]);
}

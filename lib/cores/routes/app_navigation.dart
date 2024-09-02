import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

import '../../features/_core/transaction/domain/entities/checkout_entity.dart';
import '../../features/_core/transaction/domain/entities/price_entity.dart';
import '../../features/_core/user/domain/entities/balance_entity.dart';
import '../../features/account_balance/domain/entities/bank_me_entity.dart';
import '../../features/account_balance/presentation/account_balance_faq_screen.dart';
import '../../features/account_balance/presentation/cash_withdrawal_details_screen.dart';
import '../../features/article/domain/entities/article_entity.dart';
import '../../features/article/presentation/article_detail_screen.dart';
import '../../features/article/presentation/article_screen.dart';
import '../../features/account_balance/presentation/account_balance_screen.dart';
import '../../features/account_balance/presentation/cash_withdrawal_history_screen.dart';
import '../../features/account_balance/presentation/cash_withdrawal_screen.dart';
import '../../features/avatar/presentation/avatar_screen.dart';
import '../../features/beranda/domain/entities/promo_entity.dart';
import '../../features/beranda/presentation/blocs/balance/balance_bloc.dart';
import '../../features/beranda/presentation/blocs/beranda_articles/beranda_articles_bloc.dart';
import '../../features/beranda/presentation/blocs/beranda_menus/beranda_menus_bloc.dart';
import '../../features/beranda/presentation/blocs/beranda_promo/beranda_promo_bloc.dart';
import '../../features/beranda/presentation/blocs/price_setting/price_setting_bloc.dart';
import '../../features/beranda/presentation/cubits/fab_cubit/fab_cubit.dart';
import '../../features/beranda/presentation/promo_detail_screen.dart';
import '../../features/buy_gold/presentation/buy_gold_screen.dart';
import '../../features/close_account/presentation/close_account_screen.dart';
import '../../features/close_account/presentation/close_my_account_screen.dart';
import '../../features/close_account/presentation/gold_forfeit_screen.dart';
import '../../features/close_account/presentation/how_long_screen.dart';
import '../../features/coupon/domain/entities/coupon_detail_entity.dart';
import '../../features/coupon/presentation/coupon_detail_screen.dart';
import '../../features/coupon/presentation/coupon_redeem_screen.dart';
import '../../features/elite/data/models/elite_register_req.dart';
import '../../features/elite/domain/entities/elite_register_entity.dart';
import '../../features/elite/presentation/detail_gold_voucher_screen.dart';
import '../../features/elite/presentation/elite_change_payment_method_screen.dart';
import '../../features/elite/presentation/elite_code_referal_screen.dart';
import '../../features/elite/presentation/elite_combined_screen.dart';
import '../../features/elite/presentation/elite_details_order_screen.dart';
import '../../features/elite/presentation/elite_history_screen.dart';
import '../../features/elite/presentation/elite_order_success_screen.dart.dart';
import '../../features/elite/presentation/elite_payment_method_screen.dart';
import '../../features/elite/presentation/elite_subscription_method_screen.dart';
import '../../features/elite/presentation/elite_terms_condition_screen.dart';
import '../../features/elite/presentation/elite_unsubscribe_screen.dart';
import '../../features/elite/presentation/elite_unsubscribe_success_screen.dart';
import '../../features/elite/presentation/list_gold_voucher_screen.dart';
import '../../features/elite/presentation/list_offer_screen.dart';
import '../../features/elite/presentation/offer_detail_screen.dart';
import '../../features/elite_bonuses/presentation/elite_bonus_details_screen.dart';
import '../../features/elite_bonuses/presentation/elite_bonus_history_screen.dart';
import '../../features/elite_bonuses/presentation/elite_bonuses_exp_details_screen.dart';
import '../../features/elite_bonuses/presentation/elite_bonuses_screen.dart';
import '../../features/forgot/presentation/blocs/otp_forgot/otp_forgot_bloc.dart';
import '../../features/forgot/presentation/forgot_password_screen.dart';
import '../../features/beranda/presentation/beranda_screen.dart';
import '../../features/forgot/presentation/new_password_screen.dart';
import '../../features/forgot/presentation/otp_forgot_screen.dart';
import '../../features/dice/presentation/dice_screen.dart';
import '../../features/gold_details/presentation/gold_details_screen.dart';
import '../../features/gold_price_chart/presentation/gold_price_chart_screen.dart';
import '../../features/kyc/presentation/ui/account_verification_screen.dart';
import '../../features/kyc/presentation/ui/bank_account/bank_account_verification_screen.dart';
import '../../features/kyc/presentation/ui/ktp/ktp_verification_result_screen.dart';
import '../../features/kyc/presentation/ui/ktp/ktp_verification_guide_screen.dart';
import '../../features/kyc/presentation/ui/npwp/npwp_verification_result_screen.dart';
import '../../features/kyc/presentation/ui/npwp/npwp_verification_screen.dart';
import '../../features/kyc/presentation/ui/photo_selfie/liveness_selfie_screen.dart';
import '../../features/kyc/presentation/ui/photo_selfie/photo_selfie_verification_result_screen.dart';
import '../../features/kyc/presentation/ui/photo_selfie/photo_selfie_verification_screen.dart';
import '../../features/kyc/presentation/ui/photo_selfie/photo_selfie_verification_guide_screen.dart';
import '../../features/laku_save/presentation/about_laku_save_screen.dart';
import '../../features/laku_save/presentation/blocs/master_data/master_data_lakusave_bloc.dart';
import '../../features/laku_save/presentation/cubits/lakusave/lakusave_cubit.dart';
import '../../features/laku_save/presentation/laku_save_auto_deposit_screen.dart';
import '../../features/laku_save/presentation/laku_save_deposit_screen.dart';
import '../../features/laku_save/presentation/laku_save_detail_screen.dart';
import '../../features/laku_save/presentation/laku_save_screen.dart';
import '../../features/laku_trade/domain/entities/laku_trade_qr_data_entity.dart';
import '../../features/laku_trade/presentation/laku_trade_detail_screen.dart';
import '../../features/laku_trade/presentation/laku_trade_screen.dart';
import '../../features/login/presentation/blocs/login/login_bloc.dart';
import '../../features/login/presentation/login_privy_screen.dart';
import '../../features/login/presentation/login_screen.dart';
import '../../features/navigation/presentation/navigation_screen.dart';
import '../../features/notification/presentation/notification_screen.dart';
import '../../features/otp/domain/entities/otp_choose_entity.dart';
import '../../features/otp/presentation/blocks/otp/otp_bloc.dart';
import '../../features/otp/presentation/otp_choose_screen.dart';
import '../../features/otp/presentation/otp_screen.dart';
import '../../features/payment/presentation/cubits/payment/payment_cubit.dart';
import '../../features/payment/presentation/payment_confirmation_screen.dart';
import '../../features/payment/presentation/payment_method_screen.dart';
import '../../features/payment/presentation/payment_waiting_screen.dart';
import '../../features/physical_pull/data/models/physical_pull_checkout_req.dart';
import '../../features/physical_pull/presentation/physical_pull_payment_screen.dart';
import '../../features/physical_pull/presentation/physical_pull_screen.dart';
import '../../features/physical_pull/presentation/withdrawal_method_screen.dart';
import '../../features/physical_trade/presentation/physical_trade_detail_payment_screen.dart';
import '../../features/physical_trade/presentation/physical_trade_faq_screen.dart';
import '../../features/physical_trade/presentation/physical_trade_screen.dart';
import '../../features/physical_trade/presentation/pickup_store_screen.dart';
import '../../features/physical_trade/presentation/pt_withdrawal_method_screen.dart';
import '../../features/pin/presentation/new_pin_screen.dart';
import '../../features/pin/presentation/pin_screen.dart';
import '../../features/portofolio/presentation/portofolio_screen.dart';
import '../../features/profile/presentation/about_us_screen.dart';
import '../../features/profile/presentation/address_update_screen.dart';
import '../../features/profile/presentation/blocs/profile/profile_bloc.dart';
import '../../features/profile/presentation/blocs/terms_and_conditions_profile/terms_and_conditions_profile_bloc.dart';
import '../../features/profile/presentation/change_password_screen.dart';
import '../../features/profile/presentation/change_pin_screen.dart';
import '../../features/profile/presentation/email_update_screen.dart';
import '../../features/profile/presentation/income_data_update_screen.dart';
import '../../features/profile/presentation/phone_number_update_screen.dart';
import '../../features/profile/presentation/self_data_screen.dart';
import '../../features/profile/presentation/self_data_update_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/qr_transfer/presentation/qr_transfer_screen.dart';
import '../../features/redeem/presentaion/redeem_screen.dart';
import '../../features/register/presentation/register_screen.dart';
import '../../features/sell_gold/presentation/sell_gold_confirmation_screen.dart';
import '../../features/sell_gold/presentation/sell_gold_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/support/presentation/chat_us_screen.dart';
import '../../features/support/presentation/faq_screen.dart';
import '../../features/support/presentation/support_screen.dart';
import '../../features/transfer/domain/entities/transfer_charge_entity.dart';
import '../../features/transfer/presentation/transfer_details_screen.dart';
import '../../features/transfer/presentation/transfer_screen.dart';
import '../constants/app_color.dart';
import '../constants/transaction_detail_type.dart';
import '../depedencies_injection/depedency_injection.dart';
import '../services/cubits/elite/elite_cubit.dart';
import '../../features/kyc/presentation/ui/camera_overlay_screen.dart';
import '../services/cubits/helper_data/helper_data_cubit.dart';
import '../utils/app_utils.dart';
import '../widgets/errors/not_found_screen.dart';
import '../widgets/errors/server_error_screen.dart';
import '../widgets/main_back_button.dart';
import 'app_routes.dart';
import 'go_router_observer.dart';

class AppNavigation {
  static GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>();

  static _backToBeranda(BuildContext context, {Map<String, dynamic>? extra}) {
    context.goNamed(AppRoutes.beranda, extra: extra);
  }

  static _backToElite(BuildContext context, {Map<String, dynamic>? extra}) {
    context.goNamed(
      AppRoutes.elite,
      extra: extra,
    );
  }

  static _backToProfile(BuildContext context) {
    context.goNamed(
      AppRoutes.profile,
    );
  }

  static Widget _swipeBackWidget(
      {required Function() onSwipeRight, required Widget child}) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 2000) {
          onSwipeRight();
        }
      },
      child: child,
    );
  }

  static GoRouter router(String initialLocation) {
    return GoRouter(
      initialLocation: '/$initialLocation',
      navigatorKey: rootNavigatorKey,
      debugLogDiagnostics: true,
      observers: [GoRouterObserver()],
      redirect: (context, state) {
        appPrint("fullPath: ${state.fullPath}");
        appPrint("matchedLocation: ${state.matchedLocation}");
        appPrint("name: ${state.name}");
        appPrint("path: ${state.path}");
        appPrint("uri: ${state.uri}");
        appPrint("uri.query: ${state.uri.query}");
        appPrint("uri.queryParameters: ${state.uri.queryParameters}");
        appPrint("uri.queryParametersAll: ${state.uri.queryParametersAll}");
        appPrint("pathParameters: ${state.pathParameters}");
        appPrint("extra: ${state.extra}");

        if ((state.fullPath ?? "").isEmpty ||
            (state.fullPath == "/${AppRoutes.login}") ||
            state.fullPath == "/${AppRoutes.beranda}") {
          return null;
        }

        var extra = state.extra as Map<String, dynamic>?;
        if ((state.fullPath ==
                "/${AppRoutes.login}/${AppRoutes.otpChooseLogin}") ||
            (state.fullPath ==
                "/${AppRoutes.login}/${AppRoutes.otpChooseLogin}/${AppRoutes.otpLogin}") ||
            (state.fullPath ==
                "/${AppRoutes.login}/${AppRoutes.otpChooseForgotPassword}") ||
            (state.fullPath ==
                "/${AppRoutes.login}/${AppRoutes.otpChooseForgotPassword}/${AppRoutes.forgotPassword}") ||
            (state.fullPath ==
                "/${AppRoutes.login}/${AppRoutes.otpChooseForgotPassword}/${AppRoutes.forgotPassword}/${AppRoutes.otpForgotPassword}") ||
            (state.fullPath ==
                "/${AppRoutes.login}/${AppRoutes.otpChooseForgotPassword}/${AppRoutes.forgotPassword}/${AppRoutes.otpForgotPassword}/${AppRoutes.newPassword}") ||
            (state.fullPath ==
                "/${AppRoutes.login}/${AppRoutes.register}/${AppRoutes.otpChooseRegister}") ||
            (state.fullPath ==
                "/${AppRoutes.login}/${AppRoutes.register}/${AppRoutes.otpChooseRegister}/${AppRoutes.otpRegister}")) {
          if (extra == null) {
            return "/${AppRoutes.login}";
          }
        }

        if ((state.fullPath ==
                "/${AppRoutes.pin}/${AppRoutes.otpChooseForgotPin}") ||
            (state.fullPath ==
                "/${AppRoutes.pin}/${AppRoutes.otpChooseForgotPin}/${AppRoutes.otpPin}") ||
            (state.fullPath ==
                "/${AppRoutes.pin}/${AppRoutes.otpChooseForgotPin}/${AppRoutes.otpPin}/${AppRoutes.newPin}")) {
          if (extra == null) {
            return "/${AppRoutes.pin}";
          }
        }

        if (((state.fullPath ?? "").startsWith("/${AppRoutes.login}") ==
                false) &&
            ((state.fullPath ?? "").startsWith("/${AppRoutes.pin}") == false)) {
          bool isAlreadyInputPin =
              context.read<HelperDataCubit>().state.isAlreadyInputPin;
          if (isAlreadyInputPin != true) {
            return "/${AppRoutes.pin}";
          }
        }

        return null;
      },
      errorBuilder: (context, state) => const NotFoundScreen(),
      routes: [
        GoRoute(
          name: AppRoutes.serverError,
          path: "/${AppRoutes.serverError}",
          builder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            var parentScreenName = (state.extra as Map?)?['parentScreenName'];
            return BlocProvider(
              create: (context) => sl<EliteCubit>()..init(sIsElite),
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  context.goNamed(
                    parentScreenName,
                    pathParameters: state.pathParameters,
                    queryParameters: state.uri.queryParameters,
                    extra: {
                      "isBack": "true",
                      ...((state.extra as Map?) ?? {}),
                    },
                  );
                },
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: clrBlack101,
                    title: const Text("Error"),
                    centerTitle: true,
                    leading: MainBackButton(
                      onPressed: () {
                        context.goNamed(
                          parentScreenName,
                          extra: {
                            "isBack": "true",
                            ...((state.extra as Map?) ?? {}),
                          },
                        );
                      },
                    ),
                  ),
                  body: const ServerErrorScreen(),
                ),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.login,
          path: '/${AppRoutes.login}',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const LoginScreen(),
          ),
          routes: [
            GoRoute(
              name: AppRoutes.loginPrivy,
              path: AppRoutes.loginPrivy,
              builder: (context, state) {
                return BlocProvider.value(
                  value: (state.extra as Map)['loginBloc'] as LoginBloc,
                  child: const LoginPrivyScreen(),
                );
              },
            ),
            GoRoute(
              name: AppRoutes.otpChooseLogin,
              path: AppRoutes.otpChooseLogin,
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => sl<OtpBloc>(),
                    ),
                    BlocProvider.value(
                      value: (state.extra as Map)['loginBloc'] as LoginBloc,
                    ),
                  ],
                  child: OtpChooseScreen(
                    parentScreenName:
                        (state.extra as Map?)?['parentScreenName'],
                    otpChooseEntity: OtpChooseEntity(
                      phoneNumber: (state.extra as Map?)?['phoneNumber'],
                      email: (state.extra as Map?)?['email'],
                    ),
                    isForgotPassword:
                        (state.extra as Map?)?['isForgotPassword'] ?? false,
                    isForgotPin: (state.extra as Map?)?['isForgotPin'] ?? false,
                    isPrivyRegister:
                        (state.extra as Map?)?['isPrivyRegister'] ?? false,
                    nextScreen:
                        (state.extra as Map?)?['nextScreenOtpChoose'] ?? '',
                    backScreen:
                        (state.extra as Map?)?['backScreenOtpChoose'] ?? '',
                    extra: (state.extra as Map<String, Object?>?) ?? {},
                  ),
                ),
              ),
              routes: [
                GoRoute(
                  name: AppRoutes.otpLogin,
                  path: AppRoutes.otpLogin,
                  pageBuilder: (context, state) {
                    return MaterialPage(
                      key: state.pageKey,
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: (state.extra as Map)['bloc'] as OtpBloc,
                          ),
                          BlocProvider.value(
                            value:
                                (state.extra as Map)['loginBloc'] as LoginBloc,
                          ),
                        ],
                        child: OtpScreen(
                          parentScreenName:
                              (state.extra as Map?)?['parentScreenName'],
                          otpChooseEntity: OtpChooseEntity(
                            phoneNumber: (state.extra as Map?)?['phoneNumber'],
                            email: (state.extra as Map?)?['email'],
                          ),
                          otpType: int.tryParse(
                              (state.extra as Map?)?['otpType'] ?? ''),
                          username: (state.extra as Map?)?['username'] ?? '',
                          isPrivyRegister:
                              (state.extra as Map?)?['isPrivyRegister'] ??
                                  false,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            //! forgot password
            GoRoute(
              name: AppRoutes.otpChooseForgotPassword,
              path: AppRoutes.otpChooseForgotPassword,
              builder: (context, state) => BlocProvider(
                create: (context) => sl<OtpBloc>(),
                child: OtpChooseScreen(
                  parentScreenName: (state.extra as Map?)?['parentScreenName'],
                  otpChooseEntity: OtpChooseEntity(
                    phoneNumber: (state.extra as Map?)?['phoneNumber'],
                    email: (state.extra as Map?)?['email'],
                  ),
                  isForgotPassword:
                      (state.extra as Map?)?['isForgotPassword'] ?? false,
                  isForgotPin: (state.extra as Map?)?['isForgotPin'] ?? false,
                  // nextScreen: state.pathParameters['nextScreen'] ?? '',
                  // backScreen: state.pathParameters['backScreen'] ?? '',
                  extra: (state.extra as Map<String, Object?>?) ?? {},
                ),
              ),
              routes: [
                GoRoute(
                  name: AppRoutes.forgotPassword,
                  path: AppRoutes.forgotPassword,
                  builder: (context, state) => ForgotPasswordScreen(
                    smsOTP: (state.extra as Map?)?['smsOTP'] ?? false,
                    emailOTP: (state.extra as Map?)?['emailOTP'] ?? false,
                    extra: (state.extra as Map<String, Object?>?) ?? {},
                  ),
                  routes: [
                    GoRoute(
                      name: AppRoutes.otpForgotPassword,
                      path: AppRoutes.otpForgotPassword,
                      builder: (context, state) {
                        final updatedExtra = {
                          ...(state.extra as Map<String, Object?>?) ?? {},
                          'isForgotPassword': true,
                        };

                        return BlocProvider.value(
                          value: (state.extra as Map)['bloc'] as OtpForgotBloc,
                          child: OtpForgotScreen(
                            parentScreenName:
                                (state.extra as Map)['parentScreenName'],
                            otpChooseEntity: OtpChooseEntity(
                              phoneNumber: (state.extra as Map)['phoneNumber'],
                              email: (state.extra as Map)['email'],
                            ),
                            otpType: int.tryParse(
                                (state.extra as Map?)?['otpType'] ?? ''),
                            username: (state.extra as Map?)?['username'] ?? '',
                            smsOTP: (state.extra as Map?)?['smsOTP'] ?? false,
                            emailOTP:
                                (state.extra as Map?)?['emailOTP'] ?? false,
                            nextScreen:
                                state.pathParameters['nextScreen'] ?? '',
                            backScreen:
                                state.pathParameters['backScreen'] ?? '',
                            extra: updatedExtra,
                          ),
                        );
                      },
                      routes: [
                        GoRoute(
                          name: AppRoutes.newPassword,
                          path: AppRoutes.newPassword,
                          builder: (context, state) {
                            final updatedExtra = {
                              ...(state.extra as Map<String, Object?>?) ?? {},
                              'isForgotPassword': true,
                            };

                            return NewPasswordScreen(
                              extra: updatedExtra,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              name: AppRoutes.register,
              path: AppRoutes.register,
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const RegisterScreen(),
              ),
              routes: [
                GoRoute(
                  name: AppRoutes.otpChooseRegister,
                  path: AppRoutes.otpChooseRegister,
                  builder: (context, state) => BlocProvider(
                    create: (context) => sl<OtpBloc>(),
                    child: OtpChooseScreen(
                      parentScreenName:
                          (state.extra as Map?)?['parentScreenName'],
                      otpChooseEntity: OtpChooseEntity(
                        phoneNumber: (state.extra as Map?)?['phoneNumber'],
                        email: (state.extra as Map?)?['email'],
                      ),
                      isForgotPassword:
                          (state.extra as Map?)?['isForgotPassword'] ?? false,
                      isForgotPin:
                          (state.extra as Map?)?['isForgotPin'] ?? false,
                      extra: (state.extra as Map<String, Object?>?) ?? {},
                    ),
                  ),
                  routes: [
                    GoRoute(
                      name: AppRoutes.otpRegister,
                      path: AppRoutes.otpRegister,
                      builder: (context, state) {
                        return BlocProvider.value(
                          value: (state.extra as Map)['bloc'] as OtpBloc,
                          child: OtpScreen(
                            parentScreenName:
                                (state.extra as Map?)?['parentScreenName'],
                            otpChooseEntity: OtpChooseEntity(
                              phoneNumber:
                                  (state.extra as Map?)?['phoneNumber'],
                              email: (state.extra as Map?)?['email'],
                            ),
                            otpType: int.tryParse(
                                (state.extra as Map?)?['otpType'] ?? ''),
                            username: (state.extra as Map?)?['username'] ?? '',
                            // nextScreen:
                            //     (state.extra as Map?)?['nextScreen'] ?? '',
                            // backScreen:
                            //     (state.extra as Map?)?['backScreen'] ?? '',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.otpChooseValidate,
          path: '/${AppRoutes.otpChooseValidate}',
          builder: (context, state) => BlocProvider(
            create: (context) => sl<OtpBloc>(),
            child: _swipeBackWidget(
              onSwipeRight: () {
                _backToProfile(context);
              },
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  _backToProfile(context);
                },
                child: OtpChooseScreen(
                  parentScreenName: (state.extra as Map?)?['parentScreenName'],
                  otpChooseEntity: OtpChooseEntity(
                    phoneNumber: (state.extra as Map?)?['phoneNumber'],
                    email: (state.extra as Map?)?['email'],
                  ),
                  isForgotPassword:
                      (state.extra as Map?)?['isForgotPassword'] ?? false,
                  isForgotPin: (state.extra as Map?)?['isForgotPin'] ?? false,
                  // nextScreen: state.pathParameters['nextScreen'] ?? '',
                  // backScreen: state.pathParameters['backScreen'] ?? '',
                  extra: (state.extra as Map<String, Object?>?) ?? {},
                ),
              ),
            ),
          ),
          routes: [
            GoRoute(
              name: AppRoutes.otpValidate,
              path: '${AppRoutes.otpValidate}/:otpType/:username',
              builder: (context, state) {
                return BlocProvider.value(
                  value: (state.extra as Map)['bloc'] as OtpBloc,
                  child: OtpScreen(
                    parentScreenName:
                        state.uri.queryParameters['parentScreenName'],
                    otpChooseEntity: OtpChooseEntity(
                      phoneNumber: (state.extra as Map)['phoneNumber'],
                      email: (state.extra as Map)['email'],
                    ),
                    otpType:
                        int.tryParse(state.pathParameters['otpType'] ?? ''),
                    username: state.pathParameters['username'] ?? '',
                    // nextScreen: state.pathParameters['nextScreen'] ?? '',
                    // backScreen: state.pathParameters['backScreen'] ?? '',
                    // extra: updatedExtra,
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.pin,
          // path: '/${AppRoutes.pin}/:pinType/:nextScreen/:backScreen',
          path: '/${AppRoutes.pin}',
          builder: (context, state) {
            var eliteCubit =
                (state.extra as Map?)?['eliteCubit'] as EliteCubit?;
            if (eliteCubit != null) {
              return BlocProvider.value(
                value: eliteCubit,
                child: PinScreen(
                  initialPinType:
                      int.tryParse((state.extra as Map?)?['pinType'] ?? '') ??
                          2,
                  nextScreen: (state.extra as Map?)?['nextScreenPin'] ?? '',
                  backScreen: (state.extra as Map?)?['backScreenPin'] ?? '',
                  extra: (state.extra as Map<String, Object?>?) ?? {},
                ),
              );
            }
            return PinScreen(
              initialPinType:
                  int.tryParse((state.extra as Map?)?['pinType'] ?? '') ?? 2,
              nextScreen: (state.extra as Map?)?['nextScreenPin'] ?? '',
              backScreen: (state.extra as Map?)?['backScreenPin'] ?? '',
              extra: (state.extra as Map<String, Object?>?) ?? {},
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.otpChooseForgotPin,
              path: AppRoutes.otpChooseForgotPin,
              builder: (context, state) {
                var updatedExtra = {
                  ...(state.extra as Map<String, Object?>?) ?? {},
                };
                return BlocProvider(
                  create: (context) => sl<OtpBloc>(),
                  child: OtpChooseScreen(
                    parentScreenName:
                        (state.extra as Map?)?['parentScreenName'],
                    otpChooseEntity: OtpChooseEntity(
                      phoneNumber: (state.extra as Map?)?['phoneNumber'],
                      email: (state.extra as Map?)?['email'],
                    ),
                    isForgotPassword:
                        (state.extra as Map?)?['isForgotPassword'] ?? false,
                    isForgotPin: (state.extra as Map?)?['isForgotPin'] ?? true,
                    nextScreen:
                        (state.extra as Map?)?['nextScreenOtpChoose'] ?? '',
                    backScreen:
                        (state.extra as Map?)?['backScreenOtpChoose'] ?? '',
                    extra: updatedExtra,
                  ),
                );
              },
              routes: [
                GoRoute(
                  name: AppRoutes.otpPin,
                  path: AppRoutes.otpPin,
                  builder: (context, state) {
                    var updatedExtra = {
                      ...(state.extra as Map<String, Object?>?) ?? {},
                    };
                    return BlocProvider.value(
                      value: (state.extra as Map)['bloc'] as OtpBloc,
                      child: OtpScreen(
                        parentScreenName:
                            (state.extra as Map?)?['parentScreenName'],
                        otpChooseEntity: OtpChooseEntity(
                          phoneNumber: (state.extra as Map?)?['phoneNumber'],
                          email: (state.extra as Map?)?['email'],
                        ),
                        otpType: int.tryParse(
                            (state.extra as Map?)?['otpType'] ?? ''),
                        username: (state.extra as Map?)?['username'] ?? '',
                        nextScreen:
                            (state.extra as Map?)?['nextScreenOtpPin'] ?? '',
                        backScreen:
                            (state.extra as Map?)?['backScreenOtpPin'] ?? '',
                        extra: updatedExtra,
                      ),
                    );
                  },
                  routes: [
                    GoRoute(
                      name: AppRoutes.newPin,
                      path: AppRoutes.newPin,
                      builder: (context, state) {
                        var updatedExtra = {
                          ...(state.extra as Map<String, Object?>?) ?? {},
                        };

                        return BlocProvider.value(
                          value: (state.extra as Map)['bloc'] as OtpBloc,
                          child: NewPinScreen(
                            extra: updatedExtra,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.changePin,
          path: '/${AppRoutes.changePin}/:backScreen',
          builder: (context, state) {
            return _swipeBackWidget(
              onSwipeRight: () {
                _backToProfile(context);
              },
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  final routeName =
                      state.pathParameters['backScreen'] ?? AppRoutes.pin;
                  switch (routeName) {
                    case AppRoutes.pin:
                      context.goNamed(routeName, pathParameters: {
                        'pinType': '2',
                        'nextScreen': (state.extra as Map?)?['pinNextScreen'],
                        'backScreen': (state.extra as Map?)?['pinBackScreen'],
                      });
                      break;
                    default:
                      context.goNamed(routeName);
                  }
                },
                child: ChangePinScreen(
                  backScreen:
                      state.pathParameters['backScreen'] ?? AppRoutes.pin,
                  pinBackScreen: (state.extra as Map?)?['pinBackScreen'],
                  pinNextScreen: (state.extra as Map?)?['pinNextScreen'],
                ),
              ),
            );
          },
        ),
        ShellRoute(
          navigatorKey: shellNavigatorKey,
          pageBuilder: (context, state, child) {
            var sIsElite = (state.extra as Map?)?['isElite'];

            return NoTransitionPage(
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => sl<EliteCubit>()..init(sIsElite),
                  ),
                  BlocProvider(
                    create: (context) => sl<ProfileBloc>()
                      ..add(ProfileGetDataEvent(
                        helperDataCubit: context.read<HelperDataCubit>(),
                        eliteCubit: context.read<EliteCubit>(),
                      )),
                  ),
                  BlocProvider(
                    create: (context) => sl<BerandaBalancesBloc>()
                      ..add(BerandaBalancesGetEvent(
                        helperDataCubit: context.read<HelperDataCubit>(),
                      )),
                  ),
                  BlocProvider(
                    create: (context) => sl<BerandaMenusBloc>()
                      ..add(BerandaMenusGetEvent(
                        helperDataCubit: context.read<HelperDataCubit>(),
                      )),
                  ),
                  BlocProvider(
                    create: (context) => sl<BerandaArticlesBloc>()
                      ..add(BerandaArticlesGetEvent(
                        helperDataCubit: context.read<HelperDataCubit>(),
                      )),
                  ),
                  BlocProvider(
                    create: (context) => sl<PriceSettingBloc>()
                      ..add(PriceSettingGetEvent(
                        helperDataCubit: context.read<HelperDataCubit>(),
                      )),
                  ),
                  BlocProvider(
                    create: (context) => sl<BerandaPromoBloc>()
                      ..add(BerandaPromoGetEvent(
                        helperDataCubit: context.read<HelperDataCubit>(),
                      )),
                  ),
                  BlocProvider(
                    create: (context) => sl<FabCubit>(),
                  ),
                ],
                child: NavigationScreen(
                  content: child,
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.beranda,
              path: '/${AppRoutes.beranda}',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  child: PopScope(
                    canPop: false,
                    onPopInvoked: (val) {
                      var helperDataCbt = context.read<HelperDataCubit>();
                      DateTime now = DateTime.now();
                      if (helperDataCbt.state.currentBackPressTime == null ||
                          now.difference(
                                  helperDataCbt.state.currentBackPressTime ??
                                      now) >
                              const Duration(milliseconds: 1500)) {
                        helperDataCbt.updateCurrentBackPressTime(now);
                        EasyLoading.showToast(
                          'Tap back again to leave',
                          duration: const Duration(milliseconds: 1000),
                          toastPosition: EasyLoadingToastPosition.bottom,
                          maskType: EasyLoadingMaskType.black,
                          dismissOnTap: true,
                        );
                      }
                      helperDataCbt.updateCurrentBackPressTime(null);
                      SystemNavigator.pop();
                    },
                    child: BerandaScreen(),
                  ),
                );
              },
            ),
            GoRoute(
              name: AppRoutes.portofolio,
              path: '/${AppRoutes.portofolio}',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  child: PopScope(
                    canPop: false,
                    onPopInvoked: (val) {
                      context.goNamed(AppRoutes.beranda);
                    },
                    child: PortofolioScreen(
                      isFromTrx: (state.extra as Map?)?['isFromTrx'] as bool?,
                    ),
                  ),
                );
              },
              routes: [
                GoRoute(
                  parentNavigatorKey: rootNavigatorKey,
                  name: AppRoutes.paymentWaitingTrx,
                  path: AppRoutes.paymentWaitingTrx,
                  builder: (context, state) => BlocProvider.value(
                    value:
                        ((state.extra as Map?)?['eliteCubit'] as EliteCubit?) ??
                            sl<EliteCubit>(),
                    child: PaymentWaitingScreen(
                      transactionCode:
                          (state.extra as Map?)?['transactionCode'] as String?,
                      backScreen:
                          (state.extra as Map?)?['backScreen'] as String?,
                      transactionDetailType:
                          (state.extra as Map?)?['transactionDetailType'] ??
                              TransactionDetailType.general,
                      extra: (state.extra as Map<String, dynamic>?) ??
                          <String, dynamic>{},
                    ),
                  ),
                ),
              ],
            ),
            GoRoute(
              name: AppRoutes.elite,
              path: '/${AppRoutes.elite}',
              pageBuilder: (context, state) {
                var sIsElite = (state.extra as Map?)?['isElite'];
                var isFromGrafik =
                    (state.extra as Map?)?['isFromGrafik'] ?? false;

                PriceEntity? priceEntity =
                    (state.extra as Map?)?['priceEntity'];

                return NoTransitionPage(
                  child: PopScope(
                    canPop: false,
                    onPopInvoked: (val) {
                      if (isFromGrafik) {
                        context.goNamed(
                          AppRoutes.goldPriceChart,
                          extra: {
                            'priceEntity': priceEntity,
                            'isElite': sIsElite
                          },
                        );
                        return;
                      }

                      context.goNamed(AppRoutes.beranda);
                    },
                    child: EliteCombinedScreen(
                      isFromHome: (state.extra as Map?)?['isFromHome'] as bool?,
                      isFromReferral:
                          (state.extra as Map?)?['isFromReferral'] as bool?,
                      isFromOffers:
                          (state.extra as Map?)?['isFromOffers'] as bool?,
                      isFromGrafik: isFromGrafik,
                      priceEntity: priceEntity,
                    ),
                  ),
                );
              },
            ),
            GoRoute(
              name: AppRoutes.profile,
              path: '/${AppRoutes.profile}',
              pageBuilder: (context, state) {
                return NoTransitionPage(
                  child: BlocProvider(
                    create: (context) => sl<TAndCProfileBloc>()
                      ..add(TAndCProfileGetEvent(
                          helperDataCubit: context.read<HelperDataCubit>())),
                    child: PopScope(
                      canPop: false,
                      onPopInvoked: (val) {
                        context.goNamed(AppRoutes.beranda);
                      },
                      child: const ProfileScreen(),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.qrTransfer,
          path: '/${AppRoutes.qrTransfer}',
          pageBuilder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            BerandaBalancesBloc? berandaBalancesBloc = (state.extra
                as Map?)?['berandaBalancesBloc'] as BerandaBalancesBloc?;
            return NoTransitionPage(
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  context.goNamed(AppRoutes.beranda);
                },
                child: berandaBalancesBloc != null
                    ? MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: berandaBalancesBloc,
                          ),
                          BlocProvider(
                            create: (context) =>
                                sl<EliteCubit>()..change(isElite),
                          ),
                        ],
                        child: const QRTransferScreen(),
                      )
                    : const QRTransferScreen(),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.eliteTermsCondition,
          path: '/${AppRoutes.eliteTermsCondition}',
          builder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            return BlocProvider(
              create: (context) => sl<EliteCubit>()..change(isElite),
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  context.goNamed(
                    AppRoutes.elite,
                    extra: {
                      'isElite': sIsElite,
                      'isFromHome': true,
                    },
                  );
                },
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    context.goNamed(
                      AppRoutes.elite,
                      extra: {
                        'isElite': sIsElite,
                        'isFromHome': true,
                      },
                    );
                  },
                  child: const EliteTermsConditionScreen(),
                ),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.eliteReferal,
          path: '/${AppRoutes.eliteReferal}',
          pageBuilder: (context, state) {
            bool? isBack = (state.extra as Map?)?['isBack'] ?? false;
            Future.delayed(const Duration(milliseconds: 200)).then((value) {
              isBack = null;
            });
            return CustomTransitionPage(
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                var begin = (isBack == true)
                    ? const Offset(-1.0, 0.0)
                    : const Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  context.goNamed(AppRoutes.elite);
                },
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    context.goNamed(AppRoutes.elite);
                  },
                  child: const EliteCodeReferalScreen(),
                ),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.eliteSubscriptionMethod,
          path: '/${AppRoutes.eliteSubscriptionMethod}',
          builder: (context, state) {
            var eliteCubit = (state.extra as Map?)?['eliteCubit'] as EliteCubit;
            var backScreen = (state.extra as Map?)?['backScreen'];
            return BlocProvider.value(
              value: eliteCubit,
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  (backScreen == AppRoutes.eliteReferal)
                      ? context.goNamed(
                          AppRoutes.eliteReferal,
                          extra: {'isBack': true},
                        )
                      : context.goNamed(
                          AppRoutes.elite,
                          extra: {
                            'isElite': eliteCubit.state.toString(),
                          },
                        );
                },
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    if (backScreen == AppRoutes.eliteReferal) {
                      context.goNamed(
                        AppRoutes.eliteReferal,
                        extra: {'isBack': true},
                      );
                      return;
                    }
                    context.goNamed(
                      AppRoutes.elite,
                      extra: {
                        'isElite': eliteCubit.state.toString(),
                      },
                    );
                  },
                  child: EliteSubscriptionMethodScreen(
                    eliteRegisterReq: (state.extra as Map?)?['eliteRegisterReq']
                        as EliteRegisterReq,
                    backScreen: backScreen,
                  ),
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.elitePaymentMethod,
              path: AppRoutes.elitePaymentMethod,
              builder: (context, state) {
                var eliteCubit =
                    (state.extra as Map?)?['eliteCubit'] as EliteCubit;
                var backScreen = (state.extra as Map?)?['backScreen'];
                return BlocProvider.value(
                  value: eliteCubit,
                  child: ElitePaymentMethodScreen(
                    eliteRegisterReq: (state.extra as Map?)?['eliteRegisterReq']
                        as EliteRegisterReq,
                    backScreen: backScreen,
                  ),
                );
              },
              routes: [
                GoRoute(
                  name: AppRoutes.eliteChangePaymentMethod,
                  path: AppRoutes.eliteChangePaymentMethod,
                  builder: (context, state) {
                    var eliteCubit =
                        (state.extra as Map?)?['eliteCubit'] as EliteCubit;
                    var backScreen = (state.extra as Map?)?['backScreen'];
                    var eliteRegisterReq = (state.extra
                        as Map?)?['eliteRegisterReq'] as EliteRegisterReq;
                    return BlocProvider.value(
                      value: eliteCubit,
                      child: EliteChangePaymentMethodScreen(
                        eliteRegisterReq: eliteRegisterReq,
                        backScreen: backScreen,
                      ),
                    );
                  },
                  routes: [
                    GoRoute(
                      name: AppRoutes.eliteDetailsOrder,
                      path: AppRoutes.eliteDetailsOrder,
                      pageBuilder: (context, state) {
                        var eliteCubit =
                            (state.extra as Map?)?['eliteCubit'] as EliteCubit;
                        var eliteRegisterReq = (state.extra
                            as Map?)?['eliteRegisterReq'] as EliteRegisterReq;
                        var backScreen = (state.extra as Map?)?['backScreen'];
                        bool? isBack =
                            (state.extra as Map?)?['isBack'] ?? false;
                        Future.delayed(const Duration(milliseconds: 200))
                            .then((value) {
                          isBack = null;
                        });
                        return CustomTransitionPage(
                          transitionsBuilder: (
                            BuildContext context,
                            Animation<double> animation,
                            Animation<double> secondaryAnimation,
                            Widget child,
                          ) {
                            var begin = (isBack == true)
                                ? const Offset(-1.0, 0.0)
                                : const Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve));
                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                          child: BlocProvider.value(
                            value: eliteCubit,
                            child: EliteDetailsOrderScreen(
                              eliteRegisterEntity:
                                  (state.extra as Map?)?['eliteRegisterEntity']
                                      as EliteRegisterEntity,
                              eliteRegisterReq: eliteRegisterReq,
                              isValidated:
                                  (state.extra as Map?)?['isValidated'] ??
                                      false,
                              backScreen: backScreen,
                            ),
                          ),
                        );
                      },
                      routes: [
                        GoRoute(
                          name: AppRoutes.eliteTermsConditionDetailOrder,
                          path: AppRoutes.eliteTermsConditionDetailOrder,
                          builder: (context, state) {
                            var eliteCubit = (state.extra
                                as Map?)?['eliteCubit'] as EliteCubit;
                            var eliteRegisterReq =
                                (state.extra as Map?)?['eliteRegisterReq']
                                    as EliteRegisterReq;
                            var backScreen =
                                (state.extra as Map?)?['backScreen'];
                            return BlocProvider.value(
                              value: eliteCubit,
                              child: EliteTermsConditionScreen(
                                eliteRegisterEntity: (state.extra
                                        as Map?)?['eliteRegisterEntity']
                                    as EliteRegisterEntity,
                                eliteRegisterReq: eliteRegisterReq,
                                isValidated:
                                    (state.extra as Map?)?['isValidated'] ??
                                        false,
                                backScreen: backScreen,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              name: AppRoutes.eliteDetailsOrderVoucher,
              path: AppRoutes.eliteDetailsOrderVoucher,
              builder: (context, state) {
                var eliteCubit =
                    (state.extra as Map?)?['eliteCubit'] as EliteCubit;
                var eliteRegisterReq = (state.extra
                    as Map?)?['eliteRegisterReq'] as EliteRegisterReq;
                var backScreen = (state.extra as Map?)?['backScreen'];
                return BlocProvider.value(
                  value: eliteCubit,
                  child: EliteDetailsOrderScreen(
                    eliteRegisterEntity: (state.extra
                        as Map?)?['eliteRegisterEntity'] as EliteRegisterEntity,
                    eliteRegisterReq: eliteRegisterReq,
                    isValidated: (state.extra as Map?)?['isValidated'] ?? false,
                    backScreen: backScreen,
                  ),
                );
              },
              routes: [
                GoRoute(
                  name: AppRoutes.eliteTermsConditionDetailOrderVoucher,
                  path: AppRoutes.eliteTermsConditionDetailOrderVoucher,
                  builder: (context, state) {
                    var eliteCubit =
                        (state.extra as Map?)?['eliteCubit'] as EliteCubit;
                    var eliteRegisterReq = (state.extra
                        as Map?)?['eliteRegisterReq'] as EliteRegisterReq;
                    var backScreen = (state.extra as Map?)?['backScreen'];
                    return BlocProvider.value(
                      value: eliteCubit,
                      child: EliteTermsConditionScreen(
                        eliteRegisterEntity:
                            (state.extra as Map?)?['eliteRegisterEntity']
                                as EliteRegisterEntity,
                        eliteRegisterReq: eliteRegisterReq,
                        isValidated:
                            (state.extra as Map?)?['isValidated'] ?? false,
                        backScreen: backScreen,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        // GoRoute(
        //   name: AppRoutes.elitePaymentMethod,
        //   path: '/${AppRoutes.elitePaymentMethod}',
        //   builder: (context, state) {
        //     var eliteCubit = (state.extra as Map?)?['eliteCubit'] as EliteCubit;
        //     return BlocProvider.value(
        //       value: eliteCubit,
        //       child: PopScope(
        //         child: ElitePaymentMethodScreen(
        //           eliteRegisterReq: (state.extra as Map?)?['eliteRegisterReq']
        //               as EliteRegisterReq,
        //         ),
        //         canPop: false,
        // onPopInvoked: (val) {
        //           context.goNamed(
        //             AppRoutes.elite,
        //             extra: {
        //               'isElite': eliteCubit.state.toString(),
        //             },
        //           );
        //
        //         },
        //       ),
        //     );
        //   },
        // ),
        // GoRoute(
        //   name: AppRoutes.eliteChangePaymentMethod,
        //   path: '/${AppRoutes.eliteChangePaymentMethod}',
        //   builder: (context, state) {
        //     var eliteCubit = (state.extra as Map?)?['eliteCubit'] as EliteCubit;
        //     return BlocProvider.value(
        //       value: eliteCubit,
        //       child: PopScope(
        //         child: EliteChangePaymentMethodScreen(
        //           eliteRegisterReq: (state.extra as Map?)?['eliteRegisterReq']
        //               as EliteRegisterReq,
        //         ),
        //         canPop: false,
        // onPopInvoked: (val) {
        //           context.goNamed(
        //             AppRoutes.elite,
        //             extra: {
        //               'isElite': eliteCubit.state.toString(),
        //             },
        //           );
        //
        //         },
        //       ),
        //     );
        //   },
        // ),
        // GoRoute(
        //   name: AppRoutes.eliteDetailsOrder,
        //   path: '/${AppRoutes.eliteDetailsOrder}',
        //   builder: (context, state) {
        //     var eliteCubit = (state.extra as Map?)?['eliteCubit'] as EliteCubit;
        //     return BlocProvider.value(
        //       value: eliteCubit,
        //       child: PopScope(
        //         child: EliteDetailsOrderScreen(
        //           eliteRegisterEntity: (state.extra
        //               as Map?)?['eliteRegisterEntity'] as EliteRegisterEntity,
        //         ),
        //         canPop: false,
        // onPopInvoked: (val) {
        //           context.goNamed(
        //             AppRoutes.elite,
        //             extra: {
        //               'isElite': eliteCubit.state.toString(),
        //             },
        //           );
        //
        //         },
        //       ),
        //     );
        //   },
        // ),
        GoRoute(
          name: AppRoutes.eliteOrderSuccess,
          path: '/${AppRoutes.eliteOrderSuccess}',
          builder: (context, state) {
            var eliteCubit = (state.extra as Map?)?['eliteCubit'] as EliteCubit;
            return BlocProvider.value(
              value: eliteCubit,
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  context.read<HelperDataCubit>().resetDataAfterTrx();
                  context.goNamed(
                    AppRoutes.beranda,
                  );
                },
                child: EliteOrderSuccessScreen(
                  eliteRegisterEntity: (state.extra
                      as Map?)?['eliteRegisterEntity'] as EliteRegisterEntity,
                ),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.eliteHistory,
          path: '/${AppRoutes.eliteHistory}',
          pageBuilder: (context, state) {
            var eliteCubit = (state.extra as Map?)?['eliteCubit'] as EliteCubit;
            var backScreen = (state.extra as Map?)?['backScreen'];
            bool? isBack = (state.extra as Map?)?['isBack'] ?? false;
            Future.delayed(const Duration(milliseconds: 200)).then((value) {
              isBack = null;
            });
            return CustomTransitionPage(
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                var begin = (isBack == true)
                    ? const Offset(-1.0, 0.0)
                    : const Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
              child: BlocProvider.value(
                value: eliteCubit,
                child: PopScope(
                  canPop: false,
                  onPopInvoked: (val) {
                    context.goNamed(
                      AppRoutes.elite,
                      extra: {
                        'isElite': eliteCubit.state.toString(),
                        'isFromReferral': backScreen == null ? true : false,
                      },
                    );
                  },
                  child: _swipeBackWidget(
                    onSwipeRight: () {
                      context.goNamed(
                        AppRoutes.elite,
                        extra: {
                          'isElite': eliteCubit.state.toString(),
                          'isFromReferral': backScreen == null ? true : false,
                        },
                      );
                    },
                    child: EliteHistoryScreen(
                      backScreen: backScreen,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.eliteUnsubscribe,
          path: '/${AppRoutes.eliteUnsubscribe}',
          builder: (context, state) {
            var eliteCubit = (state.extra as Map?)?['eliteCubit'] as EliteCubit;
            return BlocProvider.value(
              value: eliteCubit,
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  context.goNamed(
                    AppRoutes.elite,
                    extra: {
                      'isElite': eliteCubit.state.toString(),
                      'isFromHome': true,
                    },
                  );
                },
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    context.goNamed(AppRoutes.elite, extra: {
                      'isElite': 'true',
                      'isFromHome': true,
                    });
                  },
                  child: const EliteUnsubscribeScreen(),
                ),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.offerDetail,
          path: '/${AppRoutes.offerDetail}',
          builder: (context, state) {
            var eliteCubit = (state.extra as Map?)?['eliteCubit'] as EliteCubit;
            var backScreen = (state.extra as Map?)?['backScreen'];
            return BlocProvider.value(
              value: eliteCubit,
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  Map<String, dynamic> addExtra = {};
                  if (backScreen == AppRoutes.listOffer) {
                    addExtra = {'isBack': true};
                  }
                  context.goNamed(
                    backScreen,
                    extra: {
                      'isElite': eliteCubit.state.toString(),
                      'eliteCubit': eliteCubit,
                      'isFromOffers': true,
                      ...addExtra,
                    },
                  );
                },
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    Map<String, dynamic> addExtra = {};
                    if (backScreen == AppRoutes.listOffer) {
                      addExtra = {'isBack': true};
                    }
                    context.goNamed(
                      backScreen,
                      extra: {
                        'isElite': eliteCubit.state.toString(),
                        'eliteCubit': eliteCubit,
                        'isFromOffers': true,
                        ...addExtra,
                      },
                    );
                  },
                  child: OfferDetailScreen(
                    backScreen: backScreen,
                    offerID: (state.extra as Map?)?['offerID'],
                  ),
                ),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.listOffer,
          path: '/${AppRoutes.listOffer}',
          pageBuilder: (context, state) {
            var eliteCubit = (state.extra as Map?)?['eliteCubit'] as EliteCubit;
            var isBack = (state.extra as Map?)?['isBack'] as bool?;
            Future.delayed(const Duration(milliseconds: 200)).then((value) {
              isBack = null;
            });
            return CustomTransitionPage(
              key: state.pageKey,
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                var begin = (isBack == true)
                    ? const Offset(-1.0, 0.0)
                    : const Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
              child: BlocProvider.value(
                value: eliteCubit,
                child: PopScope(
                  canPop: false,
                  onPopInvoked: (val) {
                    context.goNamed(
                      AppRoutes.elite,
                      extra: {
                        'isElite': eliteCubit.state.toString(),
                        'isFromOffers': true,
                      },
                    );
                  },
                  child: _swipeBackWidget(
                    onSwipeRight: () {
                      context.goNamed(
                        AppRoutes.elite,
                        extra: {
                          'isElite': eliteCubit.state.toString(),
                          'isFromOffers': true,
                        },
                      );
                    },
                    child: const ListOfferScreen(),
                  ),
                ),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.listGoldVoucher,
          path: '/${AppRoutes.listGoldVoucher}',
          builder: (context, state) {
            var eliteCubit = (state.extra as Map?)?['eliteCubit'] as EliteCubit;
            return BlocProvider.value(
              value: eliteCubit,
              child: _swipeBackWidget(
                onSwipeRight: () {
                  context.goNamed(AppRoutes.elite, extra: {
                    'isElite': 'true',
                    'isFromReferral': true,
                  });
                },
                child: const ListGoldVoucherScreen(),
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.detailGoldVoucher,
              path: AppRoutes.detailGoldVoucher,
              builder: (context, state) {
                return BlocProvider.value(
                  value: (state.extra as Map?)?['eliteCubit'] as EliteCubit,
                  child: const DetailGoldVoucherScreen(),
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.eliteUnsubscribeSuccess,
          path: '/${AppRoutes.eliteUnsubscribeSuccess}',
          builder: (context, state) {
            return const EliteUnsubscribeSuccessScreen();
          },
        ),
        GoRoute(
          name: AppRoutes.accountVerification,
          path: '/${AppRoutes.accountVerification}',
          pageBuilder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            var isBack = (state.extra as Map?)?['isBack'] as bool?;
            // Future.delayed(const Duration(milliseconds: 200)).then((value) {
            //   isBack = null;
            // });
            return CustomTransitionPage(
              key: state.pageKey,
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                var begin = (isBack == true)
                    ? const Offset(-1.0, 0.0)
                    : const Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
              child: BlocProvider(
                create: (context) => sl<EliteCubit>()..change(isElite),
                child: PopScope(
                  canPop: false,
                  onPopInvoked: (val) {
                    context.goNamed(AppRoutes.profile);
                  },
                  child: _swipeBackWidget(
                    onSwipeRight: () {
                      _backToProfile(context);
                    },
                    child: const AccountVerificationScreen(),
                  ),
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.accountVerificationKtpResultAlreadyKyc,
              path: AppRoutes.accountVerificationKtpResultAlreadyKyc,
              builder: (context, state) {
                return BlocProvider.value(
                  value: (state.extra as Map?)?['eliteCubit'] as EliteCubit,
                  child: KtpVerificationResultScreen(
                    aspectRatio: (state.extra as Map)['aspectRatio'],
                    xFile: (state.extra as Map)['xFile'],
                    nik: (state.extra as Map)['nik'],
                    name: (state.extra as Map)['name'],
                    pob: (state.extra as Map)['pob'],
                    dob: (state.extra as Map)['dob'],
                    backScreen: (state.extra as Map)['backScreen'],
                  ),
                );
              },
            ),
            GoRoute(
              name: AppRoutes.accountVerificationKtpGuide,
              path: AppRoutes.accountVerificationKtpGuide,
              builder: (context, state) {
                return const KtpVerificationGuideScreen();
              },
              routes: [
                GoRoute(
                  name: AppRoutes.accountVerificationKtpResult,
                  path: AppRoutes.accountVerificationKtpResult,
                  builder: (context, state) {
                    return KtpVerificationResultScreen(
                      aspectRatio: (state.extra as Map)['aspectRatio'],
                      xFile: (state.extra as Map)['xFile'],
                      nik: (state.extra as Map)['nik'],
                      name: (state.extra as Map)['name'],
                      pob: (state.extra as Map)['pob'],
                      dob: (state.extra as Map)['dob'],
                      backScreen: (state.extra as Map)['backScreen'],
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              name: AppRoutes.accountVerificationSelfieResultAlreadyKyc,
              path: AppRoutes.accountVerificationSelfieResultAlreadyKyc,
              builder: (context, state) {
                return BlocProvider.value(
                  value: (state.extra as Map?)?['eliteCubit'] as EliteCubit,
                  child: PhotoSelfieVerificationResultScreen(
                    aspectRatio: (state.extra as Map)['aspectRatio'],
                    xFile: (state.extra as Map)['xFile'],
                  ),
                );
              },
            ),
            GoRoute(
              name: AppRoutes.accountVerificationSelfieGuide,
              path: AppRoutes.accountVerificationSelfieGuide,
              builder: (context, state) {
                return const PhotoSelfieVerificationGuideScreen();
              },
              routes: [
                GoRoute(
                  name: AppRoutes.accountLivenessSelfie,
                  path: AppRoutes.accountLivenessSelfie,
                  builder: (context, state) {
                    return const LivenessSelfieScreen();
                  },
                ),
                GoRoute(
                  name: AppRoutes.accountVerificationSelfie,
                  path: AppRoutes.accountVerificationSelfie,
                  builder: (context, state) {
                    return PopScope(
                      canPop: false,
                      onPopInvoked: (val) {
                        final backScreen = (state.extra as Map)['backScreen'] ??
                            AppRoutes.accountVerificationKtpGuide;
                        context.goNamed(backScreen);
                      },
                      child: PhotoSelfieVerificationScreen(
                        xFile: (state.extra as Map)['xFile'],
                        backScreen: (state.extra as Map)['backScreen'],
                      ),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              name: AppRoutes.accountVerificationNpwpResultAlreadyKyc,
              path: AppRoutes.accountVerificationNpwpResultAlreadyKyc,
              builder: (context, state) {
                return BlocProvider.value(
                  value: (state.extra as Map?)?['eliteCubit'] as EliteCubit,
                  child: NpwpVerificationResultScreen(
                    aspectRatio: (state.extra as Map)['aspectRatio'],
                    xFile: (state.extra as Map)['xFile'],
                    number: (state.extra as Map)['nik'],
                  ),
                );
              },
            ),
            GoRoute(
              name: AppRoutes.accountVerificationNpwp,
              path: AppRoutes.accountVerificationNpwp,
              builder: (context, state) {
                var xFile = (state.extra as Map?)?['xFile'] as XFile?;
                return NpwpVerificationScreen(
                  aspectRatio: state.extra == null
                      ? 1
                      : (state.extra as Map)['aspectRatio'],
                  xFile: xFile,
                  aditionalData: (state.extra as Map?)?['aditionalData'],
                );
              },
            ),
            GoRoute(
              name: AppRoutes.accountVerificationBankResultAlreadyKyc,
              path:
                  '${AppRoutes.accountVerificationBankResultAlreadyKyc}/:initialBankId',
              builder: (context, state) {
                var initialBankId = state.pathParameters['initialBankId'];
                return BlocProvider.value(
                  value: (state.extra as Map?)?['eliteCubit'] as EliteCubit,
                  child: BankAccountVerificationScreen(
                    initialBankId: int.tryParse(initialBankId ?? ''),
                    isResult: (state.extra as Map?)?['isResult'],
                  ),
                );
              },
            ),
            GoRoute(
              name: AppRoutes.accountVerificationBank,
              path: '${AppRoutes.accountVerificationBank}/:initialBankId',
              builder: (context, state) {
                var initialBankId = state.pathParameters['initialBankId'];
                return BankAccountVerificationScreen(
                  initialBankId: int.tryParse(initialBankId ?? ''),
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.cameraOverlay,
          path: '/${AppRoutes.cameraOverlay}/:cameraOverlayFor',
          builder: (context, state) => PopScope(
            canPop: false,
            onPopInvoked: (val) {
              EasyLoading.dismiss();
              final cameraOverlayFor =
                  state.pathParameters['cameraOverlayFor'] ?? '';
              switch (cameraOverlayFor) {
                case CameraOverlayFor.ktp:
                  context.goNamed(AppRoutes.accountVerificationKtpGuide);
                  break;
                case CameraOverlayFor.selfie:
                  context.goNamed(AppRoutes.accountVerificationSelfieGuide);
                  break;
                case CameraOverlayFor.npwp:
                  context.goNamed(AppRoutes.accountVerificationNpwp);
                  break;
                case CameraOverlayFor.bankAccount:
                  context.goNamed(AppRoutes.accountVerificationBank);
                  break;
                default:
              }
            },
            child: CameraOverlayScreen(
              cameraOverlayFor: state.pathParameters['cameraOverlayFor'] ?? '',
              aditionalData: (state.extra as Map?)?['aditionalData'] ?? '',
            ),
          ),
        ),
        GoRoute(
          name: AppRoutes.profileSelfData,
          path: '/${AppRoutes.profileSelfData}',
          builder: (context, state) {
            final initialDistrictId =
                (state.extra as Map?)?['initialDistrictId'] as int?;
            final initialMailDistrictId =
                (state.extra as Map?)?['initialMailDistrictId'] as int?;
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: (state.extra as Map?)?['bloc'] as ProfileBloc,
                ),
              ],
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  context.goNamed(AppRoutes.profile);
                },
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    _backToProfile(context);
                  },
                  child: SelfDataScreen(
                    initialDistrctId: initialDistrictId,
                    initialMailDistrictId: initialMailDistrictId,
                  ),
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.selfDataUpdate,
              path: AppRoutes.selfDataUpdate,
              builder: (context, state) {
                return BlocProvider.value(
                  value: (state.extra as Map?)?['bloc'] as ProfileBloc,
                  child: const SelfDataUpdateScreen(),
                );
              },
            ),
            GoRoute(
              name: AppRoutes.addressUpdate,
              path: AppRoutes.addressUpdate,
              builder: (context, state) {
                final initialProvinceId =
                    (state.extra as Map?)?['initialProvinceId'] as int?;
                final initialCityId =
                    (state.extra as Map?)?['initialCityId'] as int?;
                final initialDistrictId =
                    (state.extra as Map?)?['initialDistrictId'] as int?;
                final initPostalCode =
                    (state.extra as Map?)?['initPostalCode'] as String?;
                final initHomeAddress =
                    (state.extra as Map?)?['initHomeAddress'] as String?;
                //
                final initMailProvinceId =
                    (state.extra as Map?)?['initMailProvinceId'] as int?;
                final initMailCityId =
                    (state.extra as Map?)?['initMailCityId'] as int?;
                final initMailDistrictId =
                    (state.extra as Map?)?['initMailDistrictId'] as int?;
                final initMailPostalCode =
                    (state.extra as Map?)?['initMailPostalCode'] as String?;
                final initMailAddress =
                    (state.extra as Map?)?['initMailAddress'] as String?;

                return BlocProvider.value(
                  value: (state.extra as Map?)?['bloc'] as ProfileBloc,
                  child: AddressUpdateScreen(
                    initialProvinceId: initialProvinceId,
                    initialCityId: initialCityId,
                    initialDistrictId: initialDistrictId,
                    initPostalCode: initPostalCode,
                    initHomeAddress: initHomeAddress,
                    //
                    initMailProvinceId: initMailProvinceId,
                    initMailCityId: initMailCityId,
                    initMailDistrictId: initMailDistrictId,
                    initMailPostalCode: initMailPostalCode,
                    initMailAddress: initMailAddress,
                  ),
                );
              },
            ),
            GoRoute(
              name: AppRoutes.incomeDataUpdate,
              path: AppRoutes.incomeDataUpdate,
              builder: (context, state) {
                return BlocProvider.value(
                  value: (state.extra as Map?)?['bloc'] as ProfileBloc,
                  child: const IncomeDataUpdateScreen(),
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.phoneNumberUpdate,
          path: '/${AppRoutes.phoneNumberUpdate}',
          builder: (context, state) {
            return BlocProvider.value(
              value: (state.extra as Map?)?['bloc'] as ProfileBloc,
              child: _swipeBackWidget(
                onSwipeRight: () {
                  _backToProfile(context);
                },
                child: PhoneNumberUpdateScreen(
                  phoneNumber: (state.extra as Map?)?['phoneNumber'] as String?,
                ),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.emailUpdate,
          path: '/${AppRoutes.emailUpdate}',
          builder: (context, state) {
            return BlocProvider.value(
              value: (state.extra as Map?)?['bloc'] as ProfileBloc,
              child: _swipeBackWidget(
                onSwipeRight: () {
                  _backToProfile(context);
                },
                child: EmailUpdateScreen(
                  email: (state.extra as Map?)?['email'] as String?,
                ),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.changePassword,
          path: '/${AppRoutes.changePassword}',
          builder: (context, state) {
            return PopScope(
              canPop: false,
              onPopInvoked: (val) {
                context.goNamed(AppRoutes.profile);
              },
              child: _swipeBackWidget(
                onSwipeRight: () {
                  _backToProfile(context);
                },
                child: const ChangePasswordScreen(),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.aboutUs,
          path: '/${AppRoutes.aboutUs}',
          builder: (context, state) {
            return PopScope(
              canPop: false,
              onPopInvoked: (val) {
                context.goNamed(AppRoutes.profile);
              },
              child: _swipeBackWidget(
                onSwipeRight: () {
                  _backToProfile(context);
                },
                child: const AboutUsScreen(),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.closeAccount,
          path: '/${AppRoutes.closeAccount}',
          builder: (context, state) {
            return PopScope(
              canPop: false,
              onPopInvoked: (val) {
                context.goNamed(AppRoutes.profile);
              },
              child: _swipeBackWidget(
                onSwipeRight: () {
                  _backToProfile(context);
                },
                child: const CloseAccountScreen(),
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.closeAccountHowLong,
              path: AppRoutes.closeAccountHowLong,
              builder: (context, state) {
                return const HowLongScreen();
              },
            ),
            GoRoute(
              name: AppRoutes.closeAccountGoldForfeit,
              path: AppRoutes.closeAccountGoldForfeit,
              builder: (context, state) {
                return const GoldForfeitScreen();
              },
            ),
            GoRoute(
              name: AppRoutes.closeMyAccount,
              path: AppRoutes.closeMyAccount,
              builder: (context, state) {
                return const CloseMyAccountScreen();
              },
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.settings,
          path: '/${AppRoutes.settings}',
          builder: (context, state) {
            return PopScope(
              canPop: false,
              onPopInvoked: (val) {
                context.goNamed(AppRoutes.profile);
              },
              child: _swipeBackWidget(
                onSwipeRight: () {
                  _backToProfile(context);
                },
                child: const SettingsScreen(),
              ),
            );
          },
        ),
        //! Buy Gold
        GoRoute(
          name: AppRoutes.buyGold,
          path: '/${AppRoutes.buyGold}',
          pageBuilder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite =
                sIsElite is bool ? sIsElite : sIsElite?.toLowerCase() == 'true';
            var sIsBack = (state.extra as Map?)?['isBack'];
            bool isBack =
                sIsBack is bool ? sIsBack : sIsBack?.toLowerCase() == 'true';

            String? backScreen = (state.extra as Map?)?['backScreenBuyGold'];
            var extra = (state.extra as Map?)?['extra'];
            var isFromElite = (state.extra as Map?)?['isFromElite'] ?? false;
            var isFromGrafik = (state.extra as Map?)?['isFromGrafik'] ?? false;

            PriceEntity? priceEntity = (state.extra as Map?)?['priceEntity'];

            return CustomTransitionPage(
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                var begin = (isBack == true)
                    ? const Offset(-1.0, 0.0)
                    : const Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
              key: state.pageKey,
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  if (isFromElite) {
                    _backToElite(context, extra: extra);
                  } else if (isFromGrafik) {
                    context.goNamed(
                      AppRoutes.goldPriceChart,
                      extra: {'priceEntity': priceEntity, 'isElite': sIsElite},
                    );
                  } else {
                    context.goNamed(backScreen ?? AppRoutes.beranda,
                        extra: extra);
                  }
                },
                child: BlocProvider(
                  create: (context) => sl<EliteCubit>()..change(isElite),
                  child: _swipeBackWidget(
                    onSwipeRight: () {
                      if (isFromElite) {
                        _backToElite(context, extra: extra);
                      } else if (isFromGrafik) {
                        context.goNamed(
                          AppRoutes.goldPriceChart,
                          extra: {
                            'priceEntity': priceEntity,
                            'isElite': sIsElite
                          },
                        );
                      } else {
                        context.goNamed(backScreen ?? AppRoutes.beranda,
                            extra: extra);
                      }
                    },
                    child: BuyGoldScreen(
                      couponDetailEntity:
                          (state.extra as Map?)?['couponDetailEntity'],
                      backScreen: backScreen,
                      extra: extra,
                      isFromElite: isFromElite,
                      isFromGrafik: isFromGrafik,
                      priceEntity: priceEntity,
                    ),
                  ),
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.paymentMethod,
              path: AppRoutes.paymentMethod,
              pageBuilder: (context, state) {
                var sIsElite = (state.extra as Map?)?['isElite'];
                bool isElite = sIsElite is bool
                    ? sIsElite
                    : sIsElite?.toLowerCase() == 'true';
                String? backScreen = (state.extra as Map?)?['backScreen'];
                CheckoutEntity? checkoutEntity =
                    (state.extra as Map?)?['checkout'];
                PhysicalPullCheckoutReq? physicalPullCheckoutReq =
                    (state.extra as Map?)?['physicalPullCheckoutReq'];
                CouponDetailEntity? couponDetailEntity =
                    (state.extra as Map?)?['couponDetailEntity'];
                var paymentCubit =
                    (state.extra as Map?)?['paymentCubit'] as PaymentCubit?;
                var npwpKyc = context
                    .read<HelperDataCubit>()
                    .state
                    .userDataEntity
                    ?.kycEntity
                    ?.objectKyc?['npwp'];

                return MaterialPage(
                  key: state.pageKey,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => sl<EliteCubit>()..change(isElite),
                      ),
                      paymentCubit != null
                          ? BlocProvider(
                              create: (context) => sl<PaymentCubit>()
                                ..fillAllData(
                                  paymentCubit.state.copyWith(
                                    checkoutEntity: checkoutEntity,
                                    couponDetailEntity: couponDetailEntity,
                                  ),
                                ),
                            )
                          : BlocProvider(
                              create: (context) => sl<PaymentCubit>()
                                ..addCheckoutData(checkoutEntity)
                                ..changeCoupon(
                                    couponDetailEntity: couponDetailEntity)
                                ..changeIsNpwpAlreadyKyc(npwpKyc?.status == 1),
                            ),
                    ],
                    child: PaymentMethodScreen(
                      backScreen: backScreen,
                      checkoutEntity: checkoutEntity,
                      physicalPullCheckoutReq: physicalPullCheckoutReq,
                      extra: state.extra as Map<String, dynamic>?,
                      // chargeEntity: chargeEntity,
                    ),
                  ),
                );
              },
              routes: [
                GoRoute(
                  name: AppRoutes.paymentConfirmation,
                  path: AppRoutes.paymentConfirmation,
                  pageBuilder: (context, state) {
                    final payCubit =
                        (state.extra as Map?)?['paymentCubit'] as PaymentCubit;
                    var isBack = (state.extra as Map?)?['isBack'] as bool?;
                    Future.delayed(const Duration(milliseconds: 200))
                        .then((value) {
                      isBack = null;
                    });
                    return CustomTransitionPage(
                      key: state.pageKey,
                      transitionsBuilder: (
                        BuildContext context,
                        Animation<double> animation,
                        Animation<double> secondaryAnimation,
                        Widget child,
                      ) {
                        var begin = (isBack == true)
                            ? const Offset(-1.0, 0.0)
                            : const Offset(1.0, 0.0);
                        const end = Offset.zero;
                        const curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: (state.extra as Map?)?['eliteCubit']
                                as EliteCubit,
                          ),
                          BlocProvider(
                            create: (context) =>
                                sl<PaymentCubit>()..fillAllData(payCubit.state),
                          ),
                        ],
                        child: _swipeBackWidget(
                          onSwipeRight: () {
                            context.pop();
                          },
                          child: PaymentConfirmationScreen(
                            isValidated:
                                (state.extra as Map?)?['isValidated'] ?? false,
                          ),
                        ),
                      ),
                    );
                  },
                  routes: [
                    GoRoute(
                      name: AppRoutes.paymentServerError,
                      path: AppRoutes.paymentServerError,
                      builder: (context, state) {
                        var sIsElite = (state.extra as Map?)?['isElite'];
                        return BlocProvider(
                          create: (context) => sl<EliteCubit>()..init(sIsElite),
                          child: Scaffold(
                            appBar: AppBar(
                              backgroundColor: clrBlack101,
                              title: const Text("Error"),
                              centerTitle: true,
                              leading: MainBackButton(
                                onPressed: () {
                                  context.pop();
                                },
                              ),
                            ),
                            body: ServerErrorScreen(
                              onTryAgainPressed: () => context.pop(),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.sellGold,
          path: '/${AppRoutes.sellGold}',
          pageBuilder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            var dIsBack = (state.extra as Map?)?['isBack'];
            bool? isBack = dIsBack is bool ? dIsBack : (dIsBack == "true");

            var isFromGrafik = (state.extra as Map?)?['isFromGrafik'] ?? false;
            PriceEntity? priceEntity = (state.extra as Map?)?['priceEntity'];

            return CustomTransitionPage(
              key: state.pageKey,
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                var begin = (isBack == true)
                    ? const Offset(-1.0, 0.0)
                    : const Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  isFromGrafik
                      ? context.goNamed(
                          AppRoutes.goldPriceChart,
                          extra: {
                            'priceEntity': priceEntity,
                            'isElite': sIsElite
                          },
                        )
                      : context.goNamed(AppRoutes.beranda);
                },
                child: BlocProvider(
                  create: (context) => sl<EliteCubit>()..change(isElite),
                  child: _swipeBackWidget(
                    onSwipeRight: () {
                      isFromGrafik
                          ? context.goNamed(
                              AppRoutes.goldPriceChart,
                              extra: {
                                'priceEntity': priceEntity,
                                'isElite': sIsElite
                              },
                            )
                          : _backToBeranda(context);
                    },
                    child: SellGoldScreen(
                      isFromGrafik: isFromGrafik,
                      priceEntity: priceEntity,
                    ),
                  ),
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.sellGoldConfirmation,
              path: AppRoutes.sellGoldConfirmation,
              pageBuilder: (context, state) {
                final elitCubit =
                    ((state.extra as Map?)?['eliteCubit'] as EliteCubit?) ??
                        sl<EliteCubit>();
                CheckoutEntity? checkoutEntity =
                    (state.extra as Map?)?['checkout'];
                bool isValidated =
                    (state.extra as Map?)?['isValidated'] ?? false;
                var dIsBack = (state.extra as Map?)?['isBack'];
                bool? isBack = dIsBack is bool ? dIsBack : (dIsBack == "true");
                Future.delayed(const Duration(milliseconds: 200)).then((value) {
                  isBack = null;
                });
                return CustomTransitionPage(
                  transitionsBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child,
                  ) {
                    var begin = (isBack == true)
                        ? const Offset(-1.0, 0.0)
                        : const Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  key: state.pageKey,
                  child: BlocProvider.value(
                    value: elitCubit,
                    child: _swipeBackWidget(
                      onSwipeRight: () {
                        context.pop();
                      },
                      child: SellGoldConfirmationScreen(
                        checkoutEntity: checkoutEntity,
                        isValidated: isValidated,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.couponRedeem,
          path: '/${AppRoutes.couponRedeem}',
          pageBuilder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            final payCubit =
                (state.extra as Map?)?['paymentCubit'] as PaymentCubit?;

            return MaterialPage(
              child: MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => sl<EliteCubit>()..change(isElite),
                  ),
                  (payCubit != null)
                      ? BlocProvider(
                          create: (context) =>
                              sl<PaymentCubit>()..fillAllData(payCubit.state))
                      : BlocProvider(create: (context) => sl<PaymentCubit>()),
                ],
                child: CouponRedeemScreen(
                  backScreen: (state.extra as Map?)?['backScreen'] as String?,
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.couponDetail,
              path: AppRoutes.couponDetail,
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: (state.extra as Map?)?['eliteCubit'] as EliteCubit,
                  ),
                  BlocProvider.value(
                    value:
                        (state.extra as Map?)?['paymentCubit'] as PaymentCubit,
                  ),
                ],
                child: CouponDetailScreen(
                  couponDetailEntity:
                      (state.extra as Map?)?['couponDetailEntity'],
                  isFromPayment:
                      ((state.extra as Map?)?['backScreen'] as String?) ==
                          AppRoutes.paymentConfirmation,
                ),
              ),
            ),
          ],
        ),
        GoRoute(
            name: AppRoutes.paymentWaiting,
            path: '/${AppRoutes.paymentWaiting}',
            builder: (context, state) => BlocProvider.value(
                  value:
                      ((state.extra as Map?)?['eliteCubit'] as EliteCubit?) ??
                          sl<EliteCubit>(),
                  child: PaymentWaitingScreen(
                    transactionCode:
                        (state.extra as Map?)?['transactionCode'] as String?,
                    backScreen: (state.extra as Map?)?['backScreen'] as String?,
                    transactionDetailType:
                        (state.extra as Map?)?['transactionDetailType'] ??
                            TransactionDetailType.general,
                    extra: (state.extra as Map<String, dynamic>?) ??
                        <String, dynamic>{},
                  ),
                ),
            routes: [
              GoRoute(
                name: AppRoutes.paymentWaitingServerError,
                path: AppRoutes.paymentWaitingServerError,
                builder: (context, state) {
                  var sIsElite = (state.extra as Map?)?['isElite'];
                  return BlocProvider(
                    create: (context) => sl<EliteCubit>()..init(sIsElite),
                    child: Scaffold(
                      appBar: AppBar(
                        backgroundColor: clrBlack101,
                        title: const Text("Error"),
                        centerTitle: true,
                        leading: MainBackButton(
                          onPressed: () {
                            context.pop();
                          },
                        ),
                      ),
                      body: const ServerErrorScreen(),
                    ),
                  );
                },
              ),
            ]),
        GoRoute(
          name: AppRoutes.redeem,
          path: '/${AppRoutes.redeem}',
          builder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            final priceSettingBloc =
                (state.extra as Map?)?['priceSettingBloc'] as PriceSettingBloc;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => sl<EliteCubit>()..change(isElite),
                ),
                BlocProvider.value(
                  value: priceSettingBloc,
                ),
              ],
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  context.goNamed(AppRoutes.beranda);
                },
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    _backToBeranda(context);
                  },
                  child: const RedeemScreen(),
                ),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.physicalPull,
          path: '/${AppRoutes.physicalPull}',
          builder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            return BlocProvider(
              create: (context) => sl<EliteCubit>()..change(isElite),
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  context.goNamed(AppRoutes.beranda);
                },
                child: const PhysicalPullScreen(),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.physicalPullPayment,
          path: '/${AppRoutes.physicalPullPayment}',
          builder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            var paymentCubit =
                (state.extra as Map?)?['paymentCubit'] as PaymentCubit;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => sl<EliteCubit>()..change(isElite),
                ),
                BlocProvider(
                  create: (context) =>
                      sl<PaymentCubit>()..fillAllData(paymentCubit.state),
                ),
              ],
              child: PhysicalPullPaymentScreen(
                physicalPullCheckoutReq:
                    (state.extra as Map?)?['physicalPullCheckoutReq']
                        as PhysicalPullCheckoutReq,
                chargeEntity:
                    (state.extra as Map?)?['checkout'] as CheckoutEntity,
                isValidated: (state.extra as Map?)?['isValidated'] ?? false,
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.physicalWithdrawalMethod,
              path: AppRoutes.physicalWithdrawalMethod,
              builder: (context, state) {
                return BlocProvider.value(
                  value: (state.extra as Map?)?['eliteCubit'] as EliteCubit,
                  child: WithdrawalMethodScreen(
                    physicalPullCheckoutReq:
                        (state.extra as Map?)?['physicalPullCheckoutReq']
                            as PhysicalPullCheckoutReq,
                    chargeEntity:
                        (state.extra as Map?)?['checkout'] as CheckoutEntity,
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.lakuSave,
          path: '/${AppRoutes.lakuSave}',
          builder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            BerandaBalancesBloc berandaBalancesBloc = ((state.extra
                as Map?)?['berandaBalancesBloc'] as BerandaBalancesBloc);
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => sl<EliteCubit>()..change(isElite),
                ),
                BlocProvider.value(
                  value: berandaBalancesBloc,
                ),
              ],
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  _backToBeranda(context);
                },
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    _backToBeranda(context);
                  },
                  child: const LakuSaveScreen(),
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.lakuSaveDeposit,
              path: AppRoutes.lakuSaveDeposit,
              builder: (context, state) {
                var sIsElite = (state.extra as Map?)?['isElite'];
                bool isElite = sIsElite?.toLowerCase() == 'true';
                BerandaBalancesBloc berandaBalancesBloc = ((state.extra
                    as Map?)?['berandaBalancesBloc'] as BerandaBalancesBloc);
                MasterDataLakusaveBloc masterDataLakusaveBloc =
                    ((state.extra as Map?)?['masterDataLakusaveBloc']
                        as MasterDataLakusaveBloc);
                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => sl<EliteCubit>()..change(isElite),
                    ),
                    BlocProvider(
                      create: (context) => sl<BerandaBalancesBloc>()
                        ..add(BerandaBalancesCopyValueEvent(
                            berandaBalanceBloc: berandaBalancesBloc)),
                    ),
                    // BlocProvider.value(
                    //   value: berandaBalancesBloc,
                    // ),
                    BlocProvider.value(
                      value: masterDataLakusaveBloc,
                    ),
                  ],
                  child: const LakuSaveDepositScreen(),
                );
              },
              routes: [
                GoRoute(
                  name: AppRoutes.lakuSaveAutoDeposit,
                  path: AppRoutes.lakuSaveAutoDeposit,
                  builder: (context, state) {
                    var sIsElite = (state.extra as Map?)?['isElite'];
                    bool isElite = sIsElite?.toLowerCase() == 'true';
                    BerandaBalancesBloc berandaBalancesBloc =
                        ((state.extra as Map?)?['berandaBalancesBloc']
                            as BerandaBalancesBloc);
                    LakusaveCubit lakusaveCubit = ((state.extra
                        as Map?)?['lakusaveCubit'] as LakusaveCubit);
                    MasterDataLakusaveBloc masterDataLakusaveBloc =
                        ((state.extra as Map?)?['masterDataLakusaveBloc']
                            as MasterDataLakusaveBloc);
                    return MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              sl<EliteCubit>()..change(isElite),
                        ),
                        BlocProvider.value(
                          value: berandaBalancesBloc,
                        ),
                        BlocProvider(
                          create: (context) => sl<LakusaveCubit>()
                            ..refillState(lakusaveCubit.state),
                        ),
                        BlocProvider.value(
                          value: masterDataLakusaveBloc,
                        ),
                      ],
                      child: const LakuSaveAutoDepositScreen(),
                    );
                  },
                  routes: [
                    GoRoute(
                      name: AppRoutes.lakuSaveDetail,
                      path: AppRoutes.lakuSaveDetail,
                      builder: (context, state) {
                        var sIsElite = (state.extra as Map?)?['isElite'];
                        bool isElite = sIsElite?.toLowerCase() == 'true';
                        BerandaBalancesBloc berandaBalancesBloc =
                            ((state.extra as Map?)?['berandaBalancesBloc']
                                as BerandaBalancesBloc);
                        LakusaveCubit lakusaveCubit = ((state.extra
                            as Map?)?['lakusaveCubit'] as LakusaveCubit);
                        MasterDataLakusaveBloc masterDataLakusaveBloc =
                            ((state.extra as Map?)?['masterDataLakusaveBloc']
                                as MasterDataLakusaveBloc);
                        bool isValidated =
                            (state.extra as Map?)?['isValidated'] ?? false;
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) =>
                                  sl<EliteCubit>()..change(isElite),
                            ),
                            BlocProvider.value(
                              value: berandaBalancesBloc,
                            ),
                            BlocProvider(
                              create: (context) => sl<LakusaveCubit>()
                                ..refillState(lakusaveCubit.state),
                            ),
                            BlocProvider.value(
                              value: masterDataLakusaveBloc,
                            ),
                          ],
                          child: LakuSaveDetailScreen(
                            isValidated: isValidated,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              name: AppRoutes.aboutLakuSave,
              path: AppRoutes.aboutLakuSave,
              builder: (context, state) {
                var sIsElite = (state.extra as Map?)?['isElite'];
                bool isElite = sIsElite?.toLowerCase() == 'true';
                return BlocProvider(
                  create: (context) => sl<EliteCubit>()..change(isElite),
                  child: const AboutLakuSaveScreen(),
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.transfer,
          path: '/${AppRoutes.transfer}',
          builder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            BerandaBalancesBloc berandaBalancesBloc = ((state.extra
                as Map?)?['berandaBalancesBloc'] as BerandaBalancesBloc);
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => sl<EliteCubit>()..change(isElite),
                ),
                BlocProvider.value(
                  value: berandaBalancesBloc,
                ),
              ],
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  context.goNamed(AppRoutes.beranda);
                },
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    _backToBeranda(context);
                  },
                  child: TransferScreen(
                    dataQr: (state.extra as Map?)?['dataQr'],
                    decodedQr: (state.extra as Map?)?['decodedQr'],
                  ),
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.transferDetails,
              path: AppRoutes.transferDetails,
              pageBuilder: (context, state) {
                var sIsElite = (state.extra as Map?)?['isElite'];
                bool isElite = sIsElite?.toLowerCase() == 'true';
                TransferChargeEntity transferChargeEntity =
                    (state.extra as Map?)?['transferChargeEntity'];
                BerandaBalancesBloc berandaBalancesBloc = ((state.extra
                    as Map?)?['berandaBalancesBloc'] as BerandaBalancesBloc);
                bool isValidated =
                    (state.extra as Map?)?['isValidated'] ?? false;
                bool? isBack = (state.extra as Map?)?['isBack'] ?? false;
                Future.delayed(const Duration(milliseconds: 200)).then((value) {
                  isBack = null;
                });
                return CustomTransitionPage(
                  transitionsBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child,
                  ) {
                    var begin = (isBack == true)
                        ? const Offset(-1.0, 0.0)
                        : const Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => sl<EliteCubit>()..change(isElite),
                      ),
                      BlocProvider.value(
                        value: berandaBalancesBloc,
                      ),
                    ],
                    child: TransferDetailsScreen(
                      isValidated: isValidated,
                      transferChargeEntity: transferChargeEntity,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.lakuTrade,
          path: '/${AppRoutes.lakuTrade}',
          builder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            return BlocProvider(
              create: (context) => sl<EliteCubit>()..change(isElite),
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  context.goNamed(AppRoutes.beranda);
                },
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    _backToBeranda(context);
                  },
                  child: const LakuTradeScreen(),
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.lakuTradeDetail,
              path: AppRoutes.lakuTradeDetail,
              pageBuilder: (context, state) {
                var sIsElite = (state.extra as Map?)?['isElite'];
                bool isElite = sIsElite?.toLowerCase() == 'true';
                LakuTradeQrDataEntity? lakuTradeQrDataEntity =
                    (state.extra as Map?)?['lakuTradeQrDataEntity'];
                bool? isValidated = (state.extra as Map?)?['isValidated'];
                bool? isBack = (state.extra as Map?)?['isBack'];
                Future.delayed(const Duration(milliseconds: 200)).then((value) {
                  isBack = null;
                });
                return CustomTransitionPage(
                  transitionsBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child,
                  ) {
                    var begin = (isBack == true)
                        ? const Offset(-1.0, 0.0)
                        : const Offset(1.0, 0.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));
                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                  child: BlocProvider(
                    create: (context) => sl<EliteCubit>()..change(isElite),
                    child: LakuTradeDetailScreen(
                      lakuTradeQrDataEntity: lakuTradeQrDataEntity,
                      isValidated: isValidated,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.goldPriceChart,
          path: '/${AppRoutes.goldPriceChart}',
          builder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            PriceEntity? priceEntity = (state.extra as Map?)?['priceEntity'];
            return BlocProvider(
              create: (context) => sl<EliteCubit>()..change(isElite),
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  context.goNamed(AppRoutes.beranda);
                },
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    _backToBeranda(context);
                  },
                  child: GoldPriceChartScreen(
                    priceEntity: priceEntity,
                  ),
                ),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.goldDetails,
          path: '/${AppRoutes.goldDetails}',
          builder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            return BlocProvider(
              create: (context) => sl<EliteCubit>()..change(isElite),
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  context.goNamed(AppRoutes.beranda);
                },
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    _backToBeranda(context);
                  },
                  child: const GoldDetailsScreen(),
                ),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.accountBalance,
          path: '/${AppRoutes.accountBalance}',
          builder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            BalanceEntity? balanceEntity = (state.extra
                as Map?)?['accountBalanceEntity'] as BalanceEntity?;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => sl<EliteCubit>()..change(isElite),
                ),
              ],
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  context.goNamed(AppRoutes.beranda);
                },
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    _backToBeranda(context);
                  },
                  child: AccountBalanceScreen(
                    accountBalance: balanceEntity,
                  ),
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.cashWithdrawal,
              path: AppRoutes.cashWithdrawal,
              builder: (context, state) {
                var sIsElite = (state.extra as Map?)?['isElite'];
                bool isElite = sIsElite?.toLowerCase() == 'true';
                BalanceEntity? balanceEntity = (state.extra
                    as Map?)?['accountBalanceEntity'] as BalanceEntity?;
                return BlocProvider(
                  create: (context) => sl<EliteCubit>()..change(isElite),
                  child: CashWithdrawalScreen(
                    accountBalance: balanceEntity,
                  ),
                );
              },
              routes: [
                GoRoute(
                  name: AppRoutes.cashWithdrawalDetails,
                  path: AppRoutes.cashWithdrawalDetails,
                  builder: (context, state) {
                    var sIsElite = (state.extra as Map?)?['isElite'];
                    bool isElite = sIsElite?.toLowerCase() == 'true';
                    BalanceEntity? balanceEntity = (state.extra
                        as Map?)?['accountBalanceEntity'] as BalanceEntity?;
                    double? denom = (state.extra as Map?)?['denom'];
                    double? fee = (state.extra as Map?)?['fee'];
                    BankMeEntity? bankMeEntity =
                        (state.extra as Map?)?['bankMeEntity'] as BankMeEntity?;
                    bool? isValidated = (state.extra as Map?)?['isValidated'];
                    return BlocProvider(
                      create: (context) => sl<EliteCubit>()..change(isElite),
                      child: CashWithdrawalDetailsScreen(
                        accountBalance: balanceEntity,
                        denom: denom,
                        fee: fee,
                        bankMeEntity: bankMeEntity,
                        isPinValidated: isValidated,
                      ),
                    );
                  },
                ),
              ],
            ),
            GoRoute(
              name: AppRoutes.accountBalanceFaq,
              path: AppRoutes.accountBalanceFaq,
              builder: (context, state) {
                var sIsElite = (state.extra as Map?)?['isElite'];
                bool isElite = sIsElite?.toLowerCase() == 'true';
                return BlocProvider(
                  create: (context) => sl<EliteCubit>()..change(isElite),
                  child: const AccountBalanceFaqScreen(),
                );
              },
            ),
            GoRoute(
              name: AppRoutes.cashWithdrawalHistory,
              path: AppRoutes.cashWithdrawalHistory,
              builder: (context, state) {
                var sIsElite = (state.extra as Map?)?['isElite'];
                bool isElite = sIsElite?.toLowerCase() == 'true';
                return BlocProvider(
                  create: (context) => sl<EliteCubit>()..change(isElite),
                  child: const CashWithdrawalHistoryScreen(),
                );
              },
              routes: [
                GoRoute(
                  name: AppRoutes.paymentWaitingWithdraw,
                  path: AppRoutes.paymentWaitingWithdraw,
                  builder: (context, state) => BlocProvider.value(
                    value:
                        ((state.extra as Map?)?['eliteCubit'] as EliteCubit?) ??
                            sl<EliteCubit>(),
                    child: PaymentWaitingScreen(
                      transactionCode:
                          (state.extra as Map?)?['transactionCode'] as String?,
                      backScreen:
                          (state.extra as Map?)?['backScreen'] as String?,
                      transactionDetailType:
                          (state.extra as Map?)?['transactionDetailType'] ??
                              TransactionDetailType.general,
                      extra: (state.extra as Map<String, dynamic>?) ??
                          <String, dynamic>{},
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.notification,
          path: '/${AppRoutes.notification}',
          pageBuilder: (context, state) {
            var sIsBack = (state.extra as Map?)?['isBack'];
            bool? isBack = (sIsBack is bool)
                ? sIsBack
                : (sIsBack ?? "").toLowerCase() == "true";
            Future.delayed(const Duration(milliseconds: 200)).then((value) {
              isBack = null;
            });
            return CustomTransitionPage(
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
                var begin = (isBack == true)
                    ? const Offset(-1.0, 0.0)
                    : const Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.ease;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return SlideTransition(
                  position: animation.drive(tween),
                  child: child,
                );
              },
              child: BlocProvider.value(
                value: ((state.extra as Map?)?['eliteCubit'] as EliteCubit?) ??
                    sl<EliteCubit>(),
                child: PopScope(
                  canPop: false,
                  onPopInvoked: (val) {
                    context.goNamed(AppRoutes.beranda);
                  },
                  child: _swipeBackWidget(
                    onSwipeRight: () {
                      _backToBeranda(context);
                    },
                    child: const NotificationScreen(),
                  ),
                ),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.support,
          path: '/${AppRoutes.support}',
          builder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            var backScreen = (state.extra as Map?)?['backScreen'];
            return BlocProvider(
              create: (context) => sl<EliteCubit>()..change(isElite),
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  context.goNamed(backScreen ?? AppRoutes.profile);
                },
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    if (backScreen != null) {
                      context.goNamed(backScreen ?? AppRoutes.profile);
                      return;
                    }
                    _backToProfile(context);
                  },
                  child: SupportScreen(
                    extra: (state.extra as Map<String, dynamic>?),
                  ),
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.faq,
              path: AppRoutes.faq,
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: (state.extra as Map?)?['eliteCubit'] as EliteCubit,
                  ),
                ],
                child: const FaqScreen(),
              ),
              routes: [
                GoRoute(
                  name: AppRoutes.chatUsFaq,
                  path: AppRoutes.chatUsFaq,
                  builder: (context, state) => MultiBlocProvider(
                    providers: [
                      BlocProvider.value(
                        value:
                            (state.extra as Map?)?['eliteCubit'] as EliteCubit,
                      ),
                    ],
                    child: const ChatUsScreen(),
                  ),
                ),
              ],
            ),
            GoRoute(
              name: AppRoutes.chatUs,
              path: AppRoutes.chatUs,
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: (state.extra as Map?)?['eliteCubit'] as EliteCubit,
                  ),
                ],
                child: const ChatUsScreen(),
              ),
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.promoDetail,
          path: '/${AppRoutes.promoDetail}',
          builder: (context, state) {
            var berandaPromoBloc =
                (state.extra as Map?)?['berandaPromoBloc'] as BerandaPromoBloc?;
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: (state.extra as Map?)?['eliteCubit'] as EliteCubit,
                ),
                berandaPromoBloc != null
                    ? BlocProvider.value(
                        value: (state.extra as Map?)?['berandaPromoBloc']
                            as BerandaPromoBloc,
                      )
                    : BlocProvider(
                        create: (context) => sl<BerandaPromoBloc>()
                          ..add(BerandaPromoGetEvent(
                            helperDataCubit: context.read<HelperDataCubit>(),
                          )),
                      ),
              ],
              child: PromoDetailScreen(
                promoId: (state.extra as Map?)?['promoId'] as int?,
                promoEntity:
                    (state.extra as Map?)?['promoEntity'] as PromoEntity?,
                backScreen: (state.extra as Map?)?['backScreen'] as String?,
                extra: (state.extra as Map<String, dynamic>?),
              ),
            );
          },
        ),
        GoRoute(
          name: AppRoutes.article,
          path: '/${AppRoutes.article}',
          builder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            return BlocProvider(
              create: (context) => sl<EliteCubit>()..change(isElite),
              child: PopScope(
                canPop: false,
                onPopInvoked: (val) {
                  context.goNamed(AppRoutes.beranda);
                },
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    _backToBeranda(context);
                  },
                  child: const ArticleScreen(),
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.articleDetail,
              path: AppRoutes.articleDetail,
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: (state.extra as Map?)?['eliteCubit'] as EliteCubit,
                  ),
                ],
                child: ArticleDetailScreen(
                  articleId: (state.extra as Map?)?['articleId'] as int?,
                  articleEntity:
                      (state.extra as Map?)?['articleEntity'] as ArticleEntity?,
                  backScreen: (state.extra as Map?)?['backScreen'] as String?,
                  extra: (state.extra as Map<String, dynamic>?),
                ),
              ),
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.bonusElite,
          path: '/${AppRoutes.bonusElite}',
          builder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            return BlocProvider(
              create: (context) => sl<EliteCubit>()..change(isElite),
              child: const EliteBonusesScreen(),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.bonusEliteDetails,
              path: AppRoutes.bonusEliteDetails,
              builder: (context, state) {
                var backScreen = (state.extra as Map?)?['backScreen'];

                return MultiBlocProvider(
                  providers: [
                    BlocProvider.value(
                      value: (state.extra as Map?)?['eliteCubit'] as EliteCubit,
                    ),
                  ],
                  child: PopScope(
                    canPop: false,
                    onPopInvoked: (val) {
                      if (backScreen != null) {
                        context.goNamed(
                          backScreen,
                          extra: state.extra ?? ['eliteCubit'],
                        );
                      }
                      if (backScreen == null) {
                        context.pop();
                      }
                    },
                    child: EliteBonusDetailsScreen(
                      backScreen: backScreen,
                    ),
                  ),
                );
              },
            ),
            GoRoute(
              name: AppRoutes.bonusEliteHistory,
              path: AppRoutes.bonusEliteHistory,
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: (state.extra as Map?)?['eliteCubit'] as EliteCubit,
                  ),
                ],
                child: const EliteBonusHistoryScreen(),
              ),
            ),
            GoRoute(
              name: AppRoutes.bonusEliteExpDetails,
              path: AppRoutes.bonusEliteExpDetails,
              builder: (context, state) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: (state.extra as Map?)?['eliteCubit'] as EliteCubit,
                  ),
                ],
                child: const EliteBonusesExpDetailsScreen(),
              ),
            ),
          ],
        ),
        GoRoute(
          name: AppRoutes.gachaPon,
          path: '/${AppRoutes.gachaPon}',
          builder: (context, state) => _swipeBackWidget(
            onSwipeRight: () {
              swipeBackDice();
            },
            child: const DiceScreen(),
          ),
        ),
        GoRoute(
          name: AppRoutes.physicalTrade,
          path: '/${AppRoutes.physicalTrade}',
          builder: (context, state) {
            var sIsElite = (state.extra as Map?)?['isElite'];
            bool isElite = sIsElite?.toLowerCase() == 'true';
            return PopScope(
              canPop: false,
              onPopInvoked: (val) {
                context.goNamed(AppRoutes.beranda);
              },
              child: BlocProvider(
                create: (context) => sl<EliteCubit>()..change(isElite),
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    _backToBeranda(context);
                  },
                  child: const PhysicalTradeScreen(),
                ),
              ),
            );
          },
          routes: [
            GoRoute(
              name: AppRoutes.physicalTradeFaq,
              path: AppRoutes.physicalTradeFaq,
              builder: (context, state) {
                var sIsElite = (state.extra as Map?)?['isElite'];
                bool isElite = sIsElite?.toLowerCase() == 'true';

                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => sl<EliteCubit>()..change(isElite),
                    ),
                  ],
                  child: const PhysicalTradeFaqScreen(),
                );
              },
            ),
            GoRoute(
              name: AppRoutes.physicalTradeDetailPayment,
              path: AppRoutes.physicalTradeDetailPayment,
              builder: (context, state) {
                var sIsElite = (state.extra as Map?)?['isElite'];
                bool isElite = sIsElite?.toLowerCase() == 'true';

                return MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => sl<EliteCubit>()..change(isElite),
                    ),
                  ],
                  child: const PhysicalTradeDetailPayment(),
                );
              },
              routes: [
                GoRoute(
                  name: AppRoutes.ptWithdrawalMethod,
                  path: AppRoutes.ptWithdrawalMethod,
                  builder: (context, state) {
                    var sIsElite = (state.extra as Map?)?['isElite'];
                    bool isElite = sIsElite?.toLowerCase() == 'true';

                    return MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              sl<EliteCubit>()..change(isElite),
                        ),
                      ],
                      child: const PTWithdrawalMethodScreen(),
                    );
                  },
                  routes: [
                    GoRoute(
                      name: AppRoutes.pickupStore,
                      path: AppRoutes.pickupStore,
                      builder: (context, state) {
                        var sIsElite = (state.extra as Map?)?['isElite'];
                        bool isElite = sIsElite?.toLowerCase() == 'true';

                        return MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) =>
                                  sl<EliteCubit>()..change(isElite),
                            ),
                          ],
                          child: const PickupStoreScreen(),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        GoRoute(
            name: AppRoutes.avatar,
            path: '/${AppRoutes.avatar}',
            builder: (context, state) {
              var sIsElite = (state.extra as Map?)?['isElite'];
              bool isElite = sIsElite?.toLowerCase() == 'true';
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => sl<EliteCubit>()..change(isElite),
                  ),
                ],
                child: _swipeBackWidget(
                  onSwipeRight: () {
                    _backToProfile(context);
                  },
                  child: PopScope(
                    canPop: false,
                    onPopInvoked: (val) {
                      _backToProfile(context);
                    },
                    child: const AvatarScreen(),
                  ),
                ),
              );
            }),
      ],
    );
  }
}

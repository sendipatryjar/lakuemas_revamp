import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/constants/kyc_status.dart';
import '../../../../cores/errors/app_failure.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/pin_type.dart';
import '../../../cores/extensions/date_extension.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/image_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/get_bonus_banner.dart';
import '../../../cores/widgets/main_button.dart';
import '../domain/entities/detail_payment_method_entity.dart';
import '../domain/entities/detail_transaction_entity.dart';
import '_helper/payment_constants.dart';
import 'blocs/cancel_tansaction/cancel_transaction_bloc.dart';
import 'blocs/detail_transaction/detail_transaction_bloc.dart';
import 'blocs/update_status/update_status_bloc.dart';
import 'widgets/info_widget.dart';
import 'widgets/payment_countdown_widget.dart';

void _onBackPressed({
  required BuildContext context,
  String? backScreen,
  Map<String, dynamic>? extra,
}) {
  if (backScreen != null) {
    context.goNamed(
      backScreen,
      extra: {'isFromTrx': true, 'isBack': true, ...(extra ?? {})},
    );
    return;
  }
  context.read<HelperDataCubit>().resetDataAfterTrx();
  context.goNamed(AppRoutes.beranda);
}

class PaymentWaitingScreen extends StatelessWidget {
  final String? transactionCode;
  final String? backScreen;
  final int transactionDetailType;
  final Map<String, dynamic> extra;
  const PaymentWaitingScreen({
    super.key,
    this.transactionCode,
    this.backScreen,
    required this.transactionDetailType,
    this.extra = const {},
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final currentRoute = GoRouterState.of(context).uri.toString();
    final currentRouteLast = currentRoute.split('/').last;
    int retryUpdateStatusCount = 0;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<DetailTransactionBloc>()
            ..add(
              DetailTransactionGetEvent(
                transactionDetailType: transactionDetailType,
                transactionCode: transactionCode ?? '',
              ),
            ),
        ),
        BlocProvider(
          create: (context) => sl<UpdateStatusBloc>(),
        ),
        BlocProvider(
          create: (context) => sl<CancelTransactionBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<DetailTransactionBloc, DetailTransactionState>(
            listener: (context, state) {
              if (state is DetailTransactionFailureState) {
                EasyLoading.dismiss();
                if (state.appFailure is ServerFailure) {
                  context.goNamed(
                    AppRoutes.paymentWaitingServerError,
                    extra: {
                      "eliteCubit": context.read<EliteCubit>(),
                      "transactionCode": transactionCode,
                      "transactionDetailType": transactionDetailType,
                      "backScreen": backScreen,
                    },
                  );
                  return;
                }
              }
            },
            child: Container(),
          ),
          BlocListener<UpdateStatusBloc, UpdateStatusState>(
            listener: (context, state) {
              if (state is UpdateStatusLoadingState) {
                EasyLoading.show();
              }
              if (state is UpdateStatusFailureState) {
                retryUpdateStatusCount = retryUpdateStatusCount + 1;
                if (state.appFailure is ServerFailure) {
                  if (retryUpdateStatusCount <= 3) {
                    context
                        .read<UpdateStatusBloc>()
                        .add(UpdateStatusPressedEvent(transactionCode ?? ''));
                    return;
                  }
                  EasyLoading.dismiss();
                  context.goNamed(
                    AppRoutes.paymentWaitingServerError,
                    extra: {
                      "eliteCubit": context.read<EliteCubit>(),
                      "transactionCode": transactionCode,
                      "transactionDetailType": transactionDetailType,
                      "backScreen": backScreen,
                    },
                  );
                  return;
                }
                EasyLoading.showError(
                  errorMessage(state.appFailure) ?? t.lblSomethingWrong,
                  dismissOnTap: true,
                );
              }
              if (state is UpdateStatusSuccessState) {
                EasyLoading.dismiss();
                if (state.updateStatus?.status == 0 ||
                    state.updateStatus?.status == 3) {
                  DialogUtils.failure(
                    context: context,
                    barrierDismissible: true,
                    firstDesc: 'Oopss, Kamu Belum Melakukan Pembayaran!',
                    secondDesc:
                        'Silakan lakukan pembayaran dan lanjutkan transaksi.',
                    btnText: t.lblBack,
                    btnOnPressed: () {
                      context.pop();
                    },
                  );
                }
                if (state.updateStatus?.status != 0) {
                  context.read<DetailTransactionBloc>().add(
                        DetailTransactionGetEvent(
                          transactionDetailType: transactionDetailType,
                          transactionCode:
                              state.updateStatus?.code ?? transactionCode ?? '',
                        ),
                      );
                }
              }
            },
          ),
          BlocListener<CancelTransactionBloc, CancelTransactionState>(
            listener: (context, state) {
              if (state is CancelTransactionInitialState) {
                EasyLoading.dismiss();
              }
              if (state is CancelTransactionLoadingState) {
                EasyLoading.show();
              }
              if (state is CancelTransactionFailureState) {
                EasyLoading.dismiss();
                if (state.appFailure is ServerFailure) {
                  context.goNamed(
                    AppRoutes.paymentWaitingServerError,
                    extra: {
                      "eliteCubit": context.read<EliteCubit>(),
                      "transactionCode": transactionCode,
                      "transactionDetailType": transactionDetailType,
                      "backScreen": backScreen,
                    },
                  );
                  return;
                }
                EasyLoading.showError(
                  errorMessage(state.appFailure) ?? t.lblSomethingWrong,
                  dismissOnTap: true,
                );
              }
              if (state is CancelTransactionSuccessState) {
                EasyLoading.dismiss();
                if (state.isUpdateStatusSuccess) {
                  DialogUtils.universal(
                    context: context,
                    barrierDismissible: true,
                    icon: Image.asset(icWarningYellow),
                    firstDesc: 'Gagal membatalkan transaksi',
                    secondDesc: 'Transaksi anda sudah berhasil dilakukan',
                  );
                } else {
                  DialogUtils.success(
                    context: context,
                    barrierDismissible: true,
                    firstDesc: 'Transaksi anda berhasil dibatalkan',
                  );
                }
                context.read<DetailTransactionBloc>().add(
                      DetailTransactionGetEvent(
                        transactionDetailType: transactionDetailType,
                        transactionCode: transactionCode ?? '',
                      ),
                    );
              }
            },
          ),
        ],
        child: currentRouteLast == AppRoutes.paymentWaitingWithdraw
            ? _Content(
                t: t,
                transactionCode: transactionCode,
                transactionDetailType: transactionDetailType,
                backScreen: backScreen,
                extra: extra,
              )
            : GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.velocity.pixelsPerSecond.dx > 2000) {
                    _onBackPressed(
                      context: context,
                      backScreen: backScreen,
                      extra: extra,
                    );
                  }
                },
                child: PopScope(
                  canPop: false,
                  onPopInvoked: (val) {
                    _onBackPressed(
                      context: context,
                      backScreen: backScreen,
                      extra: extra,
                    );
                  },
                  child: _Content(
                    t: t,
                    transactionCode: transactionCode,
                    transactionDetailType: transactionDetailType,
                    backScreen: backScreen,
                    extra: extra,
                  ),
                ),
              ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final AppLocalizations t;
  final String? transactionCode;
  final int transactionDetailType;
  final String? backScreen;
  final Map<String, dynamic> extra;
  const _Content({
    Key? key,
    required this.t,
    required this.transactionCode,
    required this.transactionDetailType,
    this.backScreen,
    this.extra = const {},
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (context.read<DetailTransactionBloc>().state
        is DetailTransactionFailureState) {
      context.read<DetailTransactionBloc>().add(
            DetailTransactionGetEvent(
              transactionDetailType: transactionDetailType,
              transactionCode: transactionCode ?? '',
            ),
          );
    }
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: BlocBuilder<DetailTransactionBloc, DetailTransactionState>(
              builder: (context, state) {
                String? type;
                int? status;
                DetailPaymentMethodActionEntity? deeplinkData;
                if (state is DetailTransactionSuccessState) {
                  status = state.detailTransaction.status;
                  type = state.detailTransaction.type;
                  var helperDeeplinkData = state
                      .detailTransaction.payment?.actions
                      .where((element) => element.name == 'deeplink-redirect');
                  deeplinkData = (helperDeeplinkData ?? []).isNotEmpty
                      ? helperDeeplinkData?.first
                      : null;
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (deeplinkData != null && status == 0) ...[
                      const SizedBox(width: 16),
                      MainButton(
                        label: t.lblPay,
                        onPressed: () async {
                          final launchDeeplink = await launchUrl(
                            Uri.parse(deeplinkData?.url ?? ''),
                            webViewConfiguration: const WebViewConfiguration(),
                          );
                          appPrint('launchDeeplink: $launchDeeplink');
                          // if (!launchDeeplink) {
                          //   throw Exception(
                          //       'Could not launch ${deeplinkData?.url}');
                          // }
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    MainButton(
                      bgColor: (deeplinkData != null && status == 0)
                          ? Colors.transparent
                          : null,
                      border: (deeplinkData != null && status == 0)
                          ? BorderSide(
                              width: 2,
                              color: clrWhite,
                            )
                          : null,
                      labelStyle: (deeplinkData != null && status == 0)
                          ? TextStyle(
                              color: clrWhite,
                            )
                          : null,
                      label: type?.toLowerCase() == 'jual emas' &&
                                  backScreen != null ||
                              type?.toLowerCase() == 'laku simpan' &&
                                  backScreen != null
                          ? t.lblBack
                          : type?.toLowerCase() == 'jual emas' ||
                                  type?.toLowerCase() == 'laku simpan'
                              ? t.lblBackToBeranda
                              : (status == 0 || status == 3
                                  ? t.lblIHaveTransferred
                                  : backScreen != null
                                      ? t.lblBack
                                      : t.lblBackToBeranda),
                      onPressed: () {
                        if (type?.toLowerCase() == 'jual emas' ||
                            type?.toLowerCase() == 'laku simpan') {
                          _onBackPressed(
                            context: context,
                            backScreen: backScreen,
                            extra: extra,
                          );
                          return;
                        }
                        if (status == 0 || status == 3) {
                          context.read<UpdateStatusBloc>().add(
                              UpdateStatusPressedEvent(transactionCode ?? ''));
                        } else {
                          _onBackPressed(
                            context: context,
                            backScreen: backScreen,
                            extra: extra,
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBonusBanner(
                  onBackBtnPressed: () => _onBackPressed(
                    context: context,
                    backScreen: backScreen,
                    extra: extra,
                  ),
                  backScreen: AppRoutes.paymentWaiting,
                  extra: extra,
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlocBuilder<DetailTransactionBloc,
                      DetailTransactionState>(
                    builder: (context, state) {
                      String? type;
                      int? durationPayment = 0;
                      String? orderNumb;
                      String? transactionDate;
                      int? status;
                      String? statusLabel;
                      DetailTransactionEntity? detailTransactionEntity;
                      String? vaNo;
                      String? paymentCode;
                      DetailPaymentMethodActionEntity? qrisData;
                      int? paymentMethodId;
                      if (state is DetailTransactionSuccessState) {
                        durationPayment =
                            state.detailTransaction.expirationTime?.toInt() ??
                                0;
                        orderNumb = state.detailTransaction.code;
                        transactionDate = state.detailTransaction.createdAt;
                        type = state.detailTransaction.type;
                        status = state.detailTransaction.status;
                        statusLabel = state.detailTransaction.statusLabel;
                        detailTransactionEntity = state.detailTransaction;
                        vaNo = detailTransactionEntity.payment?.vaNo;
                        paymentCode =
                            detailTransactionEntity.payment?.paymentCode;
                        paymentMethodId = detailTransactionEntity.payment?.id;
                        //! qris
                        var helperQrisData = state
                            .detailTransaction.payment?.actions
                            .where((element) =>
                                element.name == 'generate-qr-code');
                        qrisData = (helperQrisData ?? []).isNotEmpty
                            ? helperQrisData?.first
                            : null;
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (type?.toLowerCase() == 'beli emas' &&
                                  (status == 0 || status == 3) ||
                              type?.toLowerCase() == 'tarik fisik' &&
                                  (status == 3)) ...[
                            PaymentCountdownWidget(
                              text: t.lblFinishPaymentInTime,
                              isRed: true,
                              durationInSec: durationPayment,
                            ),
                            const SizedBox(height: 20),
                          ],
                          Row(
                            children: [
                              Text(
                                type?.toLowerCase() == 'jual emas' &&
                                        status == 3
                                    ? t.lblYourSaleIsInProcess
                                    : type?.toLowerCase() == 'tarik fisik' &&
                                            status != 5
                                        ? 'Detail Pembayaran'
                                        : type?.toLowerCase() == 'elite' &&
                                                status != 2
                                            ? 'Pembayaran Berhasil'
                                            : (statusLabel ??
                                                t.lblWaitingForPayment),
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isElite ? clrWhite : null,
                                ),
                              ),
                              const SizedBox(width: 2),
                              if (type?.toLowerCase() != 'tarik fisik' ||
                                  type?.toLowerCase() == 'tarik fisik' &&
                                      status == 5)
                                Icon(
                                  status == 1 ||
                                          (type?.toLowerCase() ==
                                                  'tarik fisik' &&
                                              status == 5)
                                      ? Icons.check_circle
                                      : (status == 2 || status == -1)
                                          ? Icons.remove_circle
                                          : Icons.change_circle_rounded,
                                  size: 16,
                                  color: status == 1 ||
                                          (type?.toLowerCase() ==
                                                  'tarik fisik' &&
                                              status == 5)
                                      ? clrGreen00A
                                      : (status == 2 || status == -1)
                                          ? clrRed
                                          : (isElite ? clrWhite : null),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (type?.toLowerCase() != 'tarik fisik')
                            _waitingPayment(
                              context,
                              t: t,
                              isElite: isElite,
                              orderNumb: orderNumb,
                              transactionDate: transactionDate,
                              status: status,
                              type: type ?? '',
                              detailTransactionEntity: detailTransactionEntity,
                            ),
                          if ((type?.toLowerCase() == 'beli emas' &&
                                  status == 0) &&
                              ((vaNo ?? '').isNotEmpty ||
                                  (paymentCode ?? '').isNotEmpty)) ...[
                            const SizedBox(height: 20),
                            _payCode(
                              context,
                              t: t,
                              isElite: isElite,
                              detailTransactionEntity: detailTransactionEntity,
                            ),
                          ],
                          if (qrisData?.url != null &&
                              status == 0 &&
                              paymentMethodId == 34)
                            _qrisWidget(
                              status: status,
                              isElite: isElite,
                              qrisUrl: qrisData!.url!,
                              context: context,
                            ),
                          if (type?.toLowerCase() != 'lakuemas elite' &&
                              type?.toLowerCase() != 'elite' &&
                              type?.toLowerCase() != 'laku simpan' &&
                              type?.toLowerCase() != 'tarik fisik' &&
                              type?.toLowerCase() != 'convert gold' &&
                              type?.toLowerCase() != 'pembelian gatcha') ...[
                            const SizedBox(height: 40),
                            Text(
                              detailWording(type ?? '', t),
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isElite ? clrWhite : null,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                          if (type?.toLowerCase() == 'jual emas' &&
                              status != 1) ...[
                            InfoWidget(
                              text: t.lblYourBalanceStillInProcess,
                              isElite: isElite,
                            ),
                            const SizedBox(height: 20),
                          ],
                          trxDetailWidget(
                            context,
                            t: t,
                            type: type,
                            data: detailTransactionEntity,
                            isElite: isElite,
                            status: status,
                            isNpwpFieldShowed: context
                                    .read<HelperDataCubit>()
                                    .state
                                    .userDataEntity
                                    ?.kycEntity
                                    ?.objectKyc?['npwp']
                                    ?.status !=
                                KycStatus.verified,
                            onNpwpFieldCLicked: () {
                              context.goNamed(
                                AppRoutes.pin,
                                extra: {
                                  'pinType': '${PinType.validate}',
                                  'backScreenPin': AppRoutes.paymentWaiting,
                                  'nextScreenPin':
                                      AppRoutes.accountVerificationNpwp,
                                  ...extra
                                },
                              );
                            },
                          ),
                          if (type?.toLowerCase() == 'tarik fisik') ...[
                            const SizedBox(height: 20),
                            if (status == 3 && (vaNo ?? '').isNotEmpty ||
                                (paymentCode ?? '').isNotEmpty)
                              _payCode(
                                context,
                                t: t,
                                isElite: isElite,
                                detailTransactionEntity:
                                    detailTransactionEntity,
                              ),
                            const SizedBox(height: 20),
                            _goldFetchDetails(
                              context,
                              t: t,
                              isElite: isElite,
                              detailTransactionEntity: detailTransactionEntity,
                            ),
                          ],
                          const SizedBox(height: 20),
                          if (type?.toLowerCase() == 'beli emas' &&
                                  status == 0 ||
                              type?.toLowerCase() == 'tarik fisik' &&
                                  status != 5)
                            if ((detailTransactionEntity
                                        ?.payment?.instruction ??
                                    '')
                                .isNotEmpty)
                              _paymentGuide(
                                  context, isElite, detailTransactionEntity),
                          const SizedBox(height: 20),
                          if (type?.toLowerCase() == 'beli emas' &&
                              (status == 0 || status == 3))
                            SizedBox(
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: () {
                                  DialogUtils.confirm(
                                    context: context,
                                    barrierDismissible: true,
                                    firstDesc:
                                        'Kamu yakin untuk membatalkan transaksi?',
                                    btnText: 'Tidak, Lanjutkan Transaksi',
                                    btnConfirm: () {
                                      context.pop();
                                    },
                                    btnTextLater: 'Ya, Batalkan Transaksi',
                                    btnLater: () {
                                      context.pop();
                                      context
                                          .read<CancelTransactionBloc>()
                                          .add(CancelTransactionNowEvent(
                                            transactionCode: transactionCode,
                                            isUpdateStatusFirst: false,
                                          ));
                                    },
                                  );
                                },
                                child: Text(
                                  'Batalkan Pembelian',
                                  textScaler: TextScaler.linear(
                                      TextUtils.textScaleFactor(context)),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: clrRed,
                                    decoration: TextDecoration.underline,
                                    decorationColor: clrRed,
                                    decorationThickness: 3,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _paymentGuide(
    BuildContext context,
    bool isElite,
    DetailTransactionEntity? detailTransactionEntity,
  ) {
    return Visibility(
      visible: true,
      replacement: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: isElite
              ? clrGreyE5e.withOpacity(0.12)
              : clrGreyE5e.withOpacity(0.25),
          border: Border.all(
            width: 2,
            color: clrNeutralGrey999.withOpacity(0.16),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'data',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.transparent,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 20,
              color: isElite ? clrWhite : null,
            )
          ],
        ),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: isElite
              ? clrGreyE5e.withOpacity(0.12)
              : clrGreyE5e.withOpacity(0.25),
          border: Border.all(
            width: 2,
            color: clrNeutralGrey999.withOpacity(0.16),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Theme(
          data: ThemeData().copyWith(
            dividerColor: Colors.transparent,
            colorScheme: ColorScheme.light(
              primary: clrYellow,
            ),
          ),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              t.lblPaymentGuide,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isElite ? clrWhite : clrBackgroundBlack,
              ),
            ),
            tilePadding: EdgeInsets.zero,
            // trailing: const SizedBox(),
            childrenPadding: const EdgeInsets.symmetric(
              // horizontal: 20,
              vertical: 16,
            ),
            children: [
              Html(
                data: detailTransactionEntity?.payment?.instruction ?? '',
                style: {
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    // fontSize: FontSize(12),
                    // lineHeight:
                    //     const LineHeight(2.5),
                    color: (isElite ? clrWhite : clrBackgroundBlack)
                        .withOpacity(0.75),
                  )
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _qrisWidget({
    required int? status,
    required bool isElite,
    required String qrisUrl,
    required BuildContext context,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: clrWhite,
            border: Border.all(
              width: 2,
              color: status == 1
                  ? clrGreen00B.withOpacity(0.2)
                  : (status == 2 || status == -1)
                      ? clrRed.withOpacity(0.2)
                      : (isElite
                          ? clrNeutralGrey999.withOpacity(0.16)
                          : clrNeutralGrey999.withOpacity(0.16)),
            ),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onLongPress: () {
                  mainCopyData(
                    context: context,
                    text: qrisUrl,
                  );
                },
                child: Image.network(
                  qrisUrl,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text('gagal memuat gambar'),
                    );
                  },
                ),
              ),
              MainButton(
                label: 'Unduh QRIS',
                onPressed: () async {
                  MainImageUtils.downloadImageDio(
                      context: context,
                      url: qrisUrl,
                      path: 'QRIS/',
                      onSuccess: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text("QRIS telah di unduh"),
                          ),
                        );
                      },
                      onFailed: (error) {
                        appPrintError('download qris failed: $error');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: clrRed,
                            content: const Text("Gagal unduh Qris"),
                          ),
                        );
                      });
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Container _payCode(
    BuildContext context, {
    required AppLocalizations t,
    bool isElite = false,
    required DetailTransactionEntity? detailTransactionEntity,
  }) {
    String? vaNo = detailTransactionEntity?.payment?.vaNo;
    String? paymentCode = detailTransactionEntity?.payment?.paymentCode;
    String payText = (detailTransactionEntity?.payment?.vaNo != '')
        ? 'Nomor Virtual Account'
        : 'Nomor Pembayaran';
    String? payCode =
        (detailTransactionEntity?.payment?.vaNo != '') ? vaNo : paymentCode;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: clrNeutralGrey999.withOpacity(0.16),
        ),
        color: isElite
            ? clrGreyE5e.withOpacity(0.12)
            : clrGreyE5e.withOpacity(0.25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            payText,
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isElite ? clrWhite : clrBackgroundBlack,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                width: 2,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
              color: isElite
                  ? clrGreyE5e.withOpacity(0.12)
                  : clrGreyE5e.withOpacity(0.25),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    payCode ?? '-',
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    if (payCode != null) {
                      Clipboard.setData(ClipboardData(text: payCode)).then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("$payText berhasil disalin!"),
                          ),
                        );
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 9,
                      horizontal: 18,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 2,
                        color: clrWhite.withOpacity(0.13),
                      ),
                      color: clrYellow,
                    ),
                    child: Text(
                      'Salin',
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: clrBackgroundBlack,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _goldFetchDetails(
    BuildContext context, {
    required AppLocalizations t,
    bool isElite = false,
    required DetailTransactionEntity? detailTransactionEntity,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail Pengambilan Emas',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isElite ? clrWhite : clrDarkBlue,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isElite
                ? clrGreyE5e.withOpacity(0.12)
                : clrGreyE5e.withOpacity(0.25),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 2,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tempat Pengambilan',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      clrBlue006.withOpacity(0.16),
                      clrBlue006.withOpacity(0.03),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Image.asset(icInfo),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Emas akan ready di toko H+2 setelah pemesanan',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Divider(
                  thickness: 1,
                  color: clrNeutralGrey999.withOpacity(0.16),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: clrNeutralGrey999.withOpacity(0.16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detailTransactionEntity?.shipment?.storeName ?? '-',
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      detailTransactionEntity?.shipment?.address ?? '-',
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontSize: 11,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Container _waitingPayment(
    BuildContext context, {
    required AppLocalizations t,
    bool isElite = false,
    String? orderNumb,
    String? transactionDate,
    int? status,
    required String type,
    required DetailTransactionEntity? detailTransactionEntity,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: status == 1
            ? clrGreen00B.withOpacity(0.16)
            : (status == 2 || status == -1)
                ? clrRed.withOpacity(0.1)
                : (isElite
                    ? clrGreyE5e.withOpacity(0.12)
                    : clrGreyE5e.withOpacity(0.25)),
        border: Border.all(
            color: status == 1
                ? clrGreen00B.withOpacity(0.2)
                : (status == 2 || status == -1)
                    ? clrRed.withOpacity(0.2)
                    : (isElite
                        ? clrNeutralGrey999.withOpacity(0.16)
                        : clrNeutralGrey999.withOpacity(0.16))),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          if (detailTransactionEntity?.type?.toLowerCase() !=
              'tarik tunai') ...[
            _fieldWaitingPayment(
              context,
              title: trxScsOneTitle(
                  type, t, detailTransactionEntity?.isTransfered),
              amount: trxScsOneValue(type, detailTransactionEntity),
              isElite: isElite,
            ),
            if (detailTransactionEntity?.type?.toLowerCase() !=
                'convert gold') ...[
              const SizedBox(height: 16),
              _fieldWaitingPayment(
                context,
                title: trxScsTwoTitle(type, t),
                amount:
                    '${trxScsTwoValue(type, detailTransactionEntity)}${type.toLowerCase() == 'redeem voucher' || type.toLowerCase() == 'laku simpan' ? '' : ''}',
                isElite: isElite,
              ),
            ],
            if (detailTransactionEntity?.type?.toLowerCase() ==
                    'lakuemas elite' ||
                detailTransactionEntity?.type?.toLowerCase() == 'elite') ...[
              const SizedBox(height: 16),
              _fieldWaitingPayment(
                context,
                title: 'Aktif Sampai Dengan',
                amount: detailTransactionEntity?.elite?.subscriptionDateEnd
                        .toDateLongMonthStr() ??
                    detailTransactionEntity?.validUntil.toDateLongMonthStr(),
                isElite: isElite,
              ),
            ],
            if (detailTransactionEntity?.type?.toLowerCase() ==
                'laku simpan') ...[
              const SizedBox(height: 16),
              _fieldWaitingPayment(
                context,
                title: 'Waktu Titipan',
                amount:
                    '${detailTransactionEntity?.deposit?.duration ?? '-'} Bulan',
                isElite: isElite,
              ),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 33,
                thickness: 1,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
            ),
          ],
          _fieldWaitingPayment(
            context,
            title: t.lblOrderNumber,
            amount: orderNumb ?? '-',
            isElite: isElite,
          ),
          const SizedBox(height: 16),
          if (detailTransactionEntity?.type?.toLowerCase() == 'laku tukar') ...[
            _fieldWaitingPayment(
              context,
              title: 'Lokasi Penukaran',
              amount: detailTransactionEntity?.item?.storeAddress ?? '-',
              isElite: isElite,
            ),
            const SizedBox(height: 16),
          ],
          if (detailTransactionEntity?.type?.toLowerCase() ==
              'laku simpan') ...[
            _fieldWaitingPayment(
              context,
              title: 'Sewa Modal',
              amount:
                  '${detailTransactionEntity?.deposit?.interest ?? '-'}% per tahun',
              isElite: isElite,
            ),
          ],
          if (detailTransactionEntity?.type?.toLowerCase() ==
              'laku simpan') ...[
            const SizedBox(height: 16),
            _fieldWaitingPayment(
              context,
              title: 'Nomor Rekening Perpanjangan',
              amount:
                  '${detailTransactionEntity?.accountName ?? '-'} (${detailTransactionEntity?.accountNumber ?? '-'})',
              isElite: isElite,
            ),
            const SizedBox(height: 16),
          ],
          _fieldWaitingPayment(
            context,
            title: t.lblTransactionDate,
            amount: transactionDate.toDateStr(),
            isElite: isElite,
          ),
          if (detailTransactionEntity?.type?.toLowerCase() ==
                  'lakuemas elite' ||
              detailTransactionEntity?.type?.toLowerCase() == 'elite') ...[
            const SizedBox(height: 16),
            _fieldWaitingPayment(
              context,
              title: 'Metode Pembayaran',
              amount: detailTransactionEntity?.elite?.paymentMethod
                      ?.toUpperCase() ??
                  detailTransactionEntity?.paymentMethod?.toUpperCase(),
              isElite: isElite,
            ),
            const SizedBox(height: 16),
          ],
          if (detailTransactionEntity?.type?.toLowerCase() ==
                  'lakuemas elite' ||
              detailTransactionEntity?.type?.toLowerCase() == 'elite') ...[
            _fieldWaitingPayment(
              context,
              title: 'Auto Debet Bulanan',
              amount: detailTransactionEntity?.elite?.autoRenewalPaymentMethod
                      ?.replaceAll('_', ' ')
                      .toUpperCase() ??
                  detailTransactionEntity?.autoRenewalPaymentMethod
                      ?.toUpperCase(),
              isElite: isElite,
            ),
          ],
        ],
      ),
    );
  }

  Widget _fieldWaitingPayment(
    BuildContext context, {
    String? title,
    String? amount,
    bool isElite = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            title ?? '-',
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isElite ? clrWhite : clrBackgroundBlack,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              amount ?? '-',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isElite ? clrWhite : clrBackgroundBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

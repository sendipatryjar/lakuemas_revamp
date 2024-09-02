import 'package:action_slider/action_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../cores/extensions/date_extension.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data_elite/helper_data_elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import 'blocs/get_offer/get_offer_bloc.dart';
import 'blocs/redeem_offer/redeem_offer_bloc.dart';

class OfferDetailScreen extends StatelessWidget {
  final String? backScreen;
  final int? offerID;
  const OfferDetailScreen({super.key, this.backScreen, this.offerID});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    // final controller = ActionSliderController();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            if (backScreen == AppRoutes.listOffer) {
              return sl<GetOfferBloc>()
                ..add(
                  GetMyOfferDetailEvent(id: offerID ?? 0),
                );
            } else {
              return sl<GetOfferBloc>()
                ..add(
                  GetOfferDetailEvent(id: offerID ?? 0),
                );
            }
          },
        ),
        BlocProvider(create: (context) => sl<RedeemOfferBloc>()),
      ],
      child: BlocListener<RedeemOfferBloc, RedeemOfferState>(
        listener: (context, state) {
          if (state is RedeemOfferLoadingState) {
            EasyLoading.show();
          }

          if (state is RedeemOfferSuccessState) {
            EasyLoading.dismiss();
            context.read<HelperDataEliteCubit>().resetMyListOffer();
            context
                .read<GetOfferBloc>()
                .add(GetOfferDetailEvent(id: offerID ?? 0));
          }

          if (state is RedeemOfferFailureState) {
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: BlocBuilder<EliteCubit, bool>(
          builder: (context, isElite) {
            return Scaffold(
              backgroundColor: clrBlack080,
              appBar: AppBar(
                backgroundColor: clrBackgroundBlack,
                centerTitle: true,
                title: Text(
                  t.lblDetailOffer,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: MainBackButton(
                  onPressed: () {
                    Map<String, dynamic> addExtra = {};
                    if (backScreen == AppRoutes.listOffer) {
                      addExtra = {'isBack': true};
                    }
                    context.goNamed(
                      backScreen ?? AppRoutes.elite,
                      extra: {
                        'isElite': isElite.toString(),
                        'eliteCubit': context.read<EliteCubit>(),
                        'isFromOffers': true,
                        ...addExtra,
                      },
                    );
                  },
                ),
              ),
              bottomNavigationBar: BlocBuilder<GetOfferBloc, GetOfferState>(
                builder: (context, state) {
                  if (state is GetOfferSuccessState) {
                    return state.detailOfferEntity.isAllowedRedeem == false ||
                            state.detailOfferEntity.isAllowedRedeem == null
                        // || state.detailOfferEntity.voucherCode == null
                        ? Padding(
                            padding: const EdgeInsets.all(20),
                            child: MainButton(
                              label: t.lblBack,
                              onPressed: () {
                                context.goNamed(
                                  backScreen ?? AppRoutes.elite,
                                  extra: {
                                    'isElite': isElite.toString(),
                                    'eliteCubit': context.read<EliteCubit>(),
                                    'isFromOffers': true,
                                  },
                                );
                              },
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(20),
                            child: ActionSlider.standard(
                              sliderBehavior: SliderBehavior.move,
                              width: double.infinity,
                              backgroundColor: clrGreyE5e.withOpacity(0.12),
                              borderWidth: 5,
                              toggleColor: clrYellow,
                              iconAlignment: Alignment.centerRight,
                              loadingIcon: Center(
                                child: SizedBox(
                                  width: 24.0,
                                  height: 24.0,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.0,
                                    color: clrBackgroundBlack,
                                  ),
                                ),
                              ),
                              successIcon: const Center(
                                  child: Icon(Icons.check_rounded)),
                              icon: const Center(
                                  child: Icon(
                                Icons.keyboard_arrow_right_rounded,
                                size: 36,
                              )),
                              action: (controller) async {
                                context.read<RedeemOfferBloc>().add(
                                      RedeemOfferPostEvent(
                                          id: state.detailOfferEntity.id ?? 0),
                                    );
                                controller.loading(); //starts loading animation
                                await Future.delayed(
                                    const Duration(seconds: 3));
                                controller.success(); //starts success animation
                                await Future.delayed(
                                    const Duration(seconds: 1));
                                controller.reset(); //resets the slider
                              },
                              child: Text(
                                'Geser Untuk Klaim Voucher >',
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: clrNeutralGrey999,
                                ),
                              ),
                            ),
                          );
                  }
                  return const SizedBox();
                },
              ),
              body: BlocBuilder<GetOfferBloc, GetOfferState>(
                builder: (context, state) {
                  if (state is GetOfferLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is GetOfferSuccessState) {
                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 160,
                          decoration: BoxDecoration(
                            image: state.detailOfferEntity.image!.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(
                                        state.detailOfferEntity.image ?? ''),
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: AssetImage(imgCardOffer),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  state.detailOfferEntity.voucherCode == null
                                      ? const SizedBox()
                                      : Text(
                                          'Kode Kupon',
                                          textScaler: TextScaler.linear(
                                              TextUtils.textScaleFactor(
                                                  context)),
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: clrWhite,
                                          ),
                                        ),
                                  state.detailOfferEntity.voucherCode == null
                                      ? const SizedBox()
                                      : const SizedBox(height: 6),
                                  state.detailOfferEntity.voucherCode == null
                                      ? const SizedBox()
                                      : Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            border: Border.all(
                                              width: 2,
                                              color: clrNeutralGrey999
                                                  .withOpacity(0.16),
                                            ),
                                            color: clrGreyE5e.withOpacity(0.12),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(width: 14),
                                              Expanded(
                                                child: Text(
                                                  state.detailOfferEntity
                                                          .voucherCode ??
                                                      '-',
                                                  textScaler: TextScaler.linear(
                                                      TextUtils.textScaleFactor(
                                                          context)),
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: clrWhite,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              GestureDetector(
                                                onTap: () {
                                                  Clipboard.setData(ClipboardData(
                                                          text: state
                                                                  .detailOfferEntity
                                                                  .voucherCode ??
                                                              '-'))
                                                      .then((_) {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            "Kode Kupon berhasil disalin!"),
                                                      ),
                                                    );
                                                  });
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 9,
                                                    horizontal: 18,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                      width: 2,
                                                      color: clrWhite
                                                          .withOpacity(0.13),
                                                    ),
                                                    color: clrYellow,
                                                  ),
                                                  child: Text(
                                                    t.lblCopy,
                                                    textScaler: TextScaler
                                                        .linear(TextUtils
                                                            .textScaleFactor(
                                                                context)),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: clrBackgroundBlack,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  state.detailOfferEntity.voucherCode == null
                                      ? const SizedBox()
                                      : const SizedBox(height: 32),
                                  Text(
                                    state.detailOfferEntity.title ?? '-',
                                    textScaler: TextScaler.linear(
                                        TextUtils.textScaleFactor(context)),
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: clrWhite,
                                    ),
                                  ),
                                  state.detailOfferEntity.redeemDate == null
                                      ? const SizedBox()
                                      : const SizedBox(height: 4),
                                  state.detailOfferEntity.redeemDate == null
                                      ? const SizedBox()
                                      : Text(
                                          'Diklaim - ${state.detailOfferEntity.redeemDate.toDateLongMonthStr()}',
                                          textScaler: TextScaler.linear(
                                              TextUtils.textScaleFactor(
                                                  context)),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: clrWhite.withOpacity(0.75),
                                          ),
                                        ),
                                  state.detailOfferEntity.validUntil == null
                                      ? const SizedBox()
                                      : const SizedBox(height: 4),
                                  state.detailOfferEntity.validUntil == null
                                      ? const SizedBox()
                                      : Text(
                                          'Berlaku sampai dengan ${state.detailOfferEntity.validUntil.toDateLongMonthStr()}',
                                          textScaler: TextScaler.linear(
                                              TextUtils.textScaleFactor(
                                                  context)),
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: clrWhite.withOpacity(0.75),
                                          ),
                                        ),
                                  Divider(
                                    height: 32,
                                    thickness: 1,
                                    color: clrNeutralGrey999.withOpacity(0.16),
                                  ),
                                  Html(
                                    data: state.detailOfferEntity.description,
                                    style: {
                                      'body': Style(
                                        color: clrWhite,
                                        margin: Margins.all(0),
                                      )
                                    },
                                  ),
                                  Divider(
                                    height: 32,
                                    thickness: 1,
                                    color: clrNeutralGrey999.withOpacity(0.16),
                                  ),
                                  state.detailOfferEntity.voucherAvailable ==
                                          null
                                      ? const SizedBox()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              t.lblVoucherAvailable,
                                              textScaler: TextScaler.linear(
                                                  TextUtils.textScaleFactor(
                                                      context)),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: clrWhite,
                                              ),
                                            ),
                                            Text(
                                              state.detailOfferEntity
                                                  .voucherAvailable
                                                  .toString(),
                                              textScaler: TextScaler.linear(
                                                  TextUtils.textScaleFactor(
                                                      context)),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: clrWhite,
                                              ),
                                            ),
                                          ],
                                        ),
                                  state.detailOfferEntity.dailyRefresh == null
                                      ? const SizedBox()
                                      : const SizedBox(height: 8),
                                  state.detailOfferEntity.dailyRefresh == null
                                      ? const SizedBox()
                                      : Text(
                                          state.detailOfferEntity
                                                  .dailyRefresh ??
                                              '-',
                                          textScaler: TextScaler.linear(
                                              TextUtils.textScaleFactor(
                                                  context)),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: clrWhite.withOpacity(0.75),
                                          ),
                                        ),
                                  state.detailOfferEntity.dailyRefresh == null
                                      ? const SizedBox()
                                      : const SizedBox(height: 20),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        width: 1.5,
                                        color:
                                            clrNeutralGrey999.withOpacity(0.16),
                                      ),
                                      color: clrYellow.withOpacity(0.16),
                                    ),
                                    child: Row(
                                      children: [
                                        Image.asset(icWarningOrange),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            t.lblInfoUseVoucher,
                                            textScaler: TextScaler.linear(
                                                TextUtils.textScaleFactor(
                                                    context)),
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: clrWhite,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

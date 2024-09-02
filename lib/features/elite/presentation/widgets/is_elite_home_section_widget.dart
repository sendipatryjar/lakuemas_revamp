import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shimmer/shimmer.dart';
// ignore: depend_on_referenced_packages
import 'package:html/parser.dart' as parser;

import '../../../../cores/extensions/currency_extension.dart';
import '../../../../features/elite/presentation/blocs/get_social_media_config/get_social_media_config_bloc.dart';
import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../../cores/services/cubits/helper_data_elite/helper_data_elite_cubit.dart';
import '../../../../cores/utils/chat_utils.dart';
import '../../../../cores/utils/dialog_utils.dart';
import '../../../../cores/utils/share_utils.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_button.dart';
import '../../../../cores/widgets/main_carousel.dart';
import '../blocs/elite_me/elite_me_bloc.dart';
import '../blocs/get_marketing_option/get_marketing_option_bloc.dart';

class IsEliteHomeSectionWidget extends StatelessWidget {
  final bool isElite;
  const IsEliteHomeSectionWidget({super.key, required this.isElite});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final controller = PageController(viewportFraction: 1, keepPage: true);

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HelperDataEliteCubit>().resetDataHome();
        context.read<EliteMeBloc>().add(EliteMeGetEvent(
            helperDataEliteCubit: context.read<HelperDataEliteCubit>()));
        context.read<GetMarketingOptionBloc>().add(GetMarketingOptionEvents(
            helperDataEliteCubit: context.read<HelperDataEliteCubit>()));
        context.read<GetSocialMediaConfigBloc>().add(
            GetSocialMediaConfigLoadEvent(
                helperDataEliteCubit: context.read<HelperDataEliteCubit>()));
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            BlocBuilder<GetMarketingOptionBloc, GetMarketingOptionState>(
              builder: (context, state) {
                if (state is GetMarketingOptionLoadingState) {
                  return Shimmer.fromColors(
                    baseColor: clrGreyShimmerBase,
                    highlightColor: clrGreyShimmerHighlight,
                    child: Container(
                      height: 144,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: clrWhite,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  );
                }
                if (state is GetMarketingSuccessState) {
                  return (state.getMarketingOptionEntity
                              .marketingOptionImageEntity ==
                          null)
                      ? SizedBox(
                          width: double.infinity,
                          height: 144,
                          child: MainCarousel(
                            controller: controller,
                            isArrow: false,
                            isDots: true,
                            contents: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    image: const DecorationImage(
                                      image: AssetImage(imgIsElite),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    image: const DecorationImage(
                                      image: AssetImage(imgIsElite),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    image: const DecorationImage(
                                      image: AssetImage(imgIsElite),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(
                          width: double.infinity,
                          height: 144,
                          child: MainCarousel(
                            controller: controller,
                            isArrow: false,
                            isDots: true,
                            isElite: true,
                            isAutoScroll: true,
                            autoScrollDelayInSec: 10,
                            contents: List.generate(
                                state
                                    .getMarketingOptionEntity
                                    .marketingOptionImageEntity!
                                    .length, (index) {
                              var image = state.getMarketingOptionEntity
                                  .marketingOptionImageEntity?[index].image;
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: clrBlack040,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        image ?? '',
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                }
                if (state is GetMarketingFailureState) {
                  return SizedBox(
                    width: double.infinity,
                    height: 144,
                    child: MainCarousel(
                      controller: controller,
                      isArrow: false,
                      isDots: true,
                      contents: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: const DecorationImage(
                                image: AssetImage(imgIsElite),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: const DecorationImage(
                                image: AssetImage(imgIsElite),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: const DecorationImage(
                                image: AssetImage(imgIsElite),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: 20),
            _referralCode(context, t: t, isElite: isElite),
            const SizedBox(height: 20),
            _discount(context, isElite: isElite, t: t),
            const SizedBox(height: 20),
            _chatViaWA(context, t: t),
            const SizedBox(height: 20),
            _youGot(context, t: t),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                context.goNamed(
                  AppRoutes.eliteTermsCondition,
                  extra: {'isElite': isElite.toString()},
                );
              },
              child: Text(
                '${t.lblCheck} ${t.lblTermsConditions}',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: clrYellow,
                ),
              ),
            ),
            const SizedBox(height: 60),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: MainButton(
                label: t.lblUnsubscribe,
                bgColor: clrRed.withOpacity(0.5),
                border: BorderSide(
                  width: 2,
                  color: clrRed.withOpacity(0.5),
                ),
                onPressed: () {
                  final isAutoRenewal = context
                      .read<HelperDataEliteCubit>()
                      .state
                      .eliteMeEntity
                      ?.isAutoRenewal;
                  if (isAutoRenewal == true) {
                    DialogUtils.confirm(
                      context: context,
                      barrierDismissible: true,
                      firstDesc: t.lblWarningUbsub,
                      btnText: t.lblYesUnsub,
                      btnConfirm: () {
                        context.goNamed(
                          AppRoutes.eliteUnsubscribe,
                          extra: {'eliteCubit': context.read<EliteCubit>()},
                        );
                      },
                      btnTextLater: t.lblBack,
                      btnLater: () {
                        context.pop();
                      },
                    );
                  } else {
                    DialogUtils.universal(
                      context: context,
                      icon: Image.asset(icWarningYellow),
                      firstDesc: 'Layanan Lakuemas Elite Kamu sudah dibatalkan',
                      secondDesc:
                          'Kamu sudah berhenti berlanggan, namun kamu tetap dapat menikmati layanan hingga durasi berlanggananmu habis.',
                      btnText: t.lblBack,
                      btnConfirm: () => context.pop(),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _referralCode(
    BuildContext context, {
    bool isElite = true,
    required AppLocalizations t,
  }) {
    // String? vaNo = detailTransactionEntity?.payment?.vaNo;
    // String? paymentCode = detailTransactionEntity?.payment?.paymentCode;
    // String payText = (detailTransactionEntity?.payment?.vaNo != '')
    //     ? 'Nomor Virtual Account'
    //     : 'Nomor Pembayaran';
    // String? payCode =
    //     (detailTransactionEntity?.payment?.vaNo != '') ? vaNo : paymentCode;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
          Row(
            children: [
              Text(
                t.lblMyReferralCode,
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () {
                  DialogUtils.universal(
                    context: context,
                    barrierDismissible: true,
                    icon: Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(icGiftBox),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    firstDesc: t.lblReferralBonusTitle,
                    secondDesc: t.lblReferralBonusDesc,
                    btnText: t.lblSip,
                    btnConfirm: () {
                      context.pop();
                    },
                  );
                },
                child: Image.asset(icInfoWhite),
              ),
            ],
          ),
          const SizedBox(height: 8),
          BlocBuilder<EliteMeBloc, EliteMeState>(
            builder: (context, state) {
              String referralCode = '-';
              if (state is EliteMeLoadingState) {
                referralCode;
              }
              if (state is EliteMeSuccessState) {
                referralCode = state.eliteMeEntity.referralCode ?? '-';
              }
              return Column(
                children: [
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
                            referralCode,
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
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
                            Clipboard.setData(ClipboardData(text: referralCode))
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content:
                                      Text("Kode Referral berhasil disalin!"),
                                ),
                              );
                            });
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
                              t.lblCopy,
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
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
                  const SizedBox(height: 20),
                  BlocBuilder<GetSocialMediaConfigBloc,
                      GetSocialMediaConfigState>(
                    builder: (context, state) {
                      if (state is GetSocialMediaConfigSuccessState) {
                        final document =
                            parser.parse(state.socialMediaConfigEntity.text);
                        final String parsedString = parser
                            .parse(document.body?.text)
                            .documentElement!
                            .text;

                        return SizedBox(
                          width: double.infinity,
                          child: MainButton(
                            label: t.lblShare,
                            onPressed: () {
                              ShareUtils.share(
                                context: context,
                                imgUrl:
                                    state.socialMediaConfigEntity.image ?? "",

                                text: '$parsedString $referralCode',
                                // text:'${state.socialMediaConfigEntity.text} $referralCode'
                                //     .replaceAll('<p>', '')
                                //     .replaceAll('</p>', ''),
                              );
                            },
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Container _discount(
    BuildContext context, {
    bool isElite = false,
    required AppLocalizations t,
  }) =>
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isElite
              ? clrGreyE5e.withOpacity(0.12)
              : clrGreyE5e.withOpacity(0.25),
          border: Border.all(
            color: clrNeutralGrey999.withOpacity(0.16),
            width: 2,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: clrBackgroundBlack.withOpacity(0.75),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.lblMonthSave,
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: clrWhite,
                      ),
                    ),
                    const SizedBox(height: 10),
                    BlocBuilder<EliteMeBloc, EliteMeState>(
                      builder: (context, state) {
                        int total = 0;
                        if (state is EliteMeLoadingState) {
                          total;
                        }
                        if (state is EliteMeSuccessState) {
                          total = state.eliteMeEntity.discount?.total ?? 0;
                        }
                        return Text(
                          'Rp ${total.toString().toIdr()}',
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: clrWhite,
                          ),
                        );
                      },
                    ),
                  ],
                )),
            const SizedBox(height: 20),
            BlocBuilder<EliteMeBloc, EliteMeState>(
              builder: (context, state) {
                int gPurchaseQty = 0;
                int gPurchaseTotal = 0;
                if (state is EliteMeLoadingState) {
                  gPurchaseQty;
                  gPurchaseTotal;
                }
                if (state is EliteMeSuccessState) {
                  gPurchaseQty =
                      state.eliteMeEntity.discount?.goldPurchase?.qty ?? 0;
                  gPurchaseTotal =
                      state.eliteMeEntity.discount?.goldPurchase?.total ?? 0;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${t.lblDiscBuyGold} X ${gPurchaseQty.toString()}',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                      RichText(
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        text: TextSpan(
                          text: 'Rp ',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                          children: [
                            TextSpan(
                              text: gPurchaseTotal.toString().toIdr(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isElite ? clrWhite : clrBackgroundBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 1,
                height: 33,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
            ),
            BlocBuilder<EliteMeBloc, EliteMeState>(
              builder: (context, state) {
                int rVoucherQty = 0;

                int rVoucherTotal = 0;
                if (state is EliteMeLoadingState) {
                  rVoucherQty;
                  rVoucherTotal;
                }
                if (state is EliteMeSuccessState) {
                  rVoucherQty =
                      state.eliteMeEntity.discount?.referralVoucher?.qty ?? 0;
                  rVoucherTotal =
                      state.eliteMeEntity.discount?.referralVoucher?.total ?? 0;
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${t.lblDicsVoucherGold} X ${rVoucherQty.toString()}',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                      RichText(
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        text: TextSpan(
                          text: 'Rp ',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                          children: [
                            TextSpan(
                              text: rVoucherTotal.toString().toIdr(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isElite ? clrWhite : clrBackgroundBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: clrYellow.withOpacity(0.5),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.lblTotal,
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                  BlocBuilder<EliteMeBloc, EliteMeState>(
                    builder: (context, state) {
                      int total = 0;
                      if (state is EliteMeLoadingState) {
                        total;
                      }
                      if (state is EliteMeSuccessState) {
                        total = state.eliteMeEntity.discount?.total ?? 0;
                      }
                      return RichText(
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        text: TextSpan(
                          text: 'Rp ',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                          children: [
                            TextSpan(
                              text: total.toString().toIdr(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: isElite ? clrWhite : clrBackgroundBlack,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Container _chatViaWA(
    BuildContext context, {
    required AppLocalizations t,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: clrGreyE5e.withOpacity(0.12),
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
            t.lblContactNumber,
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: clrWhite,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: MainButton(
              label: t.lblChatViaWA,
              onPressed: () {
                ChatUtils.chatWhatsapp(
                  phoneNumber: '+6281211855436',
                  context: context,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Container _youGot(
    BuildContext context, {
    required AppLocalizations t,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.lblYouGot,
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: clrWhite,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: 806,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(imgYouGot),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

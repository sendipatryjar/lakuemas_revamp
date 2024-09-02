import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../cores/extensions/currency_extension.dart';
import '../../../cores/extensions/date_extension.dart';
import 'package:shimmer/shimmer.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data_elite/helper_data_elite_cubit.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import 'blocs/get_voucher_referral/get_voucher_referral_bloc.dart';
import 'widgets/empty_widget.dart';

class ListGoldVoucherScreen extends StatelessWidget {
  const ListGoldVoucherScreen({super.key});

  void mainCopyData({
    required BuildContext context,
    required String text,
    String? snackbarText,
  }) {
    Clipboard.setData(ClipboardData(text: text)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(snackbarText ?? "berhasil disalin"),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => sl<GetVoucherReferralBloc>()
        ..add(GetVoucherReferralLoadEvent(
          helperDataEliteCubit: context.read<HelperDataEliteCubit>(),
        )),
      child: BlocBuilder<EliteCubit, bool>(
        builder: (context, isElite) {
          return PopScope(
            canPop: false,
            onPopInvoked: (val) {
              context.goNamed(
                AppRoutes.elite,
                extra: {
                  'isElite': isElite.toString(),
                  'isFromReferral': true,
                },
              );
            },
            child: Scaffold(
              backgroundColor: clrBlack080,
              appBar: AppBar(
                backgroundColor: clrBackgroundBlack,
                centerTitle: true,
                title: Text(
                  'Voucher Emas',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: MainBackButton(
                  onPressed: () {
                    context.goNamed(
                      AppRoutes.elite,
                      extra: {
                        'isElite': 'true',
                        'isFromReferral': true,
                      },
                    );
                  },
                ),
              ),
              body:
                  BlocBuilder<GetVoucherReferralBloc, GetVoucherReferralState>(
                builder: (context, state) {
                  if (state is GetVoucherReferralLoadingState) {
                    return SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: List.generate(
                            5,
                            (index) => Shimmer.fromColors(
                              baseColor: clrGreyShimmerBase,
                              highlightColor: clrGreyShimmerHighlight,
                              child: Container(
                                width: double.infinity,
                                height: 200,
                                margin: const EdgeInsets.only(bottom: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: clrWhite,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  if (state is GetVoucherReferralSuccessState) {
                    return state.voucherReferral.isNotEmpty
                        ? RefreshIndicator(
                            onRefresh: () async {
                              context
                                  .read<HelperDataEliteCubit>()
                                  .resetListVoucherReferral();
                              context
                                  .read<GetVoucherReferralBloc>()
                                  .add(GetVoucherReferralLoadEvent(
                                    helperDataEliteCubit:
                                        context.read<HelperDataEliteCubit>(),
                                  ));
                            },
                            child: SingleChildScrollView(
                              child: Container(
                                margin: const EdgeInsets.all(20),
                                child: Column(
                                  children: List.generate(
                                    state.voucherReferral.length,
                                    (index) => _voucherCard(
                                      context: context,
                                      vCode: state
                                          .voucherReferral[index].voucherCode,
                                      nomVoucher: state
                                          .voucherReferral[index].bonusReferral,
                                      validUntil: state
                                          .voucherReferral[index].validUntil,
                                      isUsedText:
                                          state.voucherReferral[index].status,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : EmptyWidget(
                            imgAsset: imgPeopleEmpty,
                            desc: t.lblEmptyVoucherDesc,
                          );
                  }
                  return const SizedBox();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _voucherCard({
    required BuildContext context,
    String? vCode,
    String? nomVoucher,
    String? validUntil,
    String? isUsedText,
    // bool? isUsed = true,
  }) {
    return GestureDetector(
      onTap: () {
        // context.goNamed(
        //   AppRoutes.detailGoldVoucher,
        //   extra: {
        //     'eliteCubit': context.read<EliteCubit>(),
        //   },
        // );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: isUsedText?.toLowerCase() == 'terpakai'
              ? clrNeutralGrey999.withOpacity(0.32)
              : clrNeutralGrey999.withOpacity(0.12),
          border: Border.all(
            color: clrWhite.withOpacity(0.2),
            width: 1,
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
                // color: clrBackgroundBlack.withOpacity(0.75),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                border: Border.all(
                  color: isUsedText?.toLowerCase() == 'terpakai'
                      ? clrNeutralGrey999.withOpacity(0.32)
                      : clrYellow.withOpacity(0.20),
                  width: 1,
                ),
                gradient: isUsedText?.toLowerCase() == 'terpakai'
                    ? LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          clrNeutralGrey999.withOpacity(0.32),
                          clrNeutralGrey999.withOpacity(0.32),
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          clrYellow.withOpacity(0.32),
                          clrYellow.withOpacity(0.06),
                        ],
                      ),
              ),
              child: GestureDetector(
                onTap: () {
                  mainCopyData(
                    context: context,
                    text: vCode ?? '-',
                    snackbarText: 'Voucher Code Berhasil disalin',
                  );
                },
                child: Row(
                  children: [
                    Text(
                      vCode ?? '-',
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: isUsedText?.toLowerCase() == 'terpakai'
                            ? clrNeutralGrey999
                            : clrWhite,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.copy,
                      color: isUsedText?.toLowerCase() == 'terpakai'
                          ? clrNeutralGrey999
                          : clrWhite,
                      size: 20,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '- Nominal Voucher Rp ${nomVoucher.toIdr()}',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 12,
                  color: isUsedText?.toLowerCase() == 'terpakai'
                      ? clrNeutralGrey999
                      : clrWhite.withOpacity(0.75),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                '- Berlaku sampai ${validUntil.toDateLongMonthStr()}',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 12,
                  color: isUsedText?.toLowerCase() == 'terpakai'
                      ? clrNeutralGrey999
                      : clrWhite.withOpacity(0.75),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 1,
                height: 32,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  isUsedText?.toLowerCase() == 'terpakai'
                      ? Image.asset(
                          icDisable,
                          width: 18,
                        )
                      : Image.asset(
                          icCheckOutline,
                          width: 18,
                        ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    isUsedText ?? '-',
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: isUsedText?.toLowerCase() == 'terpakai'
                          ? clrNeutralGrey999
                          : clrGreen00A,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

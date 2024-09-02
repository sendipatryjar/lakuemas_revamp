import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../cores/extensions/currency_extension.dart';
import '../../../../cores/extensions/date_extension.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_button.dart';
import '../blocs/elite_me/elite_me_bloc.dart';
import 'empty_widget.dart';
import 'referral_card_widget.dart';

class IsEliteReferralSectionWidget extends StatelessWidget {
  const IsEliteReferralSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t.lblTotalVoucherGold,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: clrWhiteFef,
              ),
            ),
            BlocBuilder<EliteMeBloc, EliteMeState>(
              builder: (context, state) {
                String refStartDate = '-';
                String refEndDate = '-';
                if (state is EliteMeLoadingState) {
                  refStartDate;
                  refEndDate;
                }
                if (state is EliteMeSuccessState) {
                  refStartDate = (state.eliteMeEntity.referral?.startDate ?? '')
                      .toDateLongMonthStr();
                  refEndDate = (state.eliteMeEntity.referral?.endDate ?? '')
                      .toDateLongMonthStr();
                }
                return Text(
                  '$refStartDate - $refEndDate',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: clrWhite.withOpacity(0.75)),
                );
              },
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: clrGreyE5e.withOpacity(0.12),
                border: Border.all(
                  color: clrNeutralGrey999.withOpacity(0.16),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: BlocBuilder<EliteMeBloc, EliteMeState>(
                builder: (context, state) {
                  int refTotal = 0;
                  String refDesc = '-';
                  if (state is EliteMeLoadingState) {
                    refTotal;
                    refDesc;
                  }
                  if (state is EliteMeSuccessState) {
                    refTotal = state.eliteMeEntity.referral?.total ?? 0;
                    refDesc = state.eliteMeEntity.referral?.text ?? '-';
                  }
                  return Column(
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
                        child: Text(
                          'Rp ${refTotal.toIdr()}',
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: clrWhite,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: Text(
                          refDesc,
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: clrWhite,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: MainButton(
                            label: t.lblViewGoldVoucher,
                            onPressed: () {
                              context.goNamed(
                                AppRoutes.listGoldVoucher,
                                extra: {
                                  'eliteCubit': context.read<EliteCubit>()
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            ),
            Divider(
              height: 40,
              thickness: 1,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.lblActiveReferralList,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: clrWhiteFef,
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.goNamed(
                      AppRoutes.eliteHistory,
                      extra: {
                        'backScreen': null,
                        'eliteCubit': context.read<EliteCubit>(),
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: clrNeutralGrey999.withOpacity(0.32),
                    ),
                    child: Text(
                      t.lblViewAll,
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: clrWhite,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            BlocBuilder<EliteMeBloc, EliteMeState>(
              builder: (context, state) {
                if (state is EliteMeLoadingState) {
                  return Shimmer.fromColors(
                    baseColor: clrGreyShimmerBase,
                    highlightColor: clrGreyShimmerHighlight,
                    child: Column(
                      children: List.generate(
                        3,
                        (index) => Container(
                          width: double.infinity,
                          height: 120,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: clrWhite,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                if (state is EliteMeSuccessState) {
                  return (state.eliteMeEntity.referral!.list!.isNotEmpty)
                      ? Column(
                          children: List.generate(
                            state.eliteMeEntity.referral?.list?.length ?? 0,
                            (index) => ReferralCardWidget(
                              name: state.eliteMeEntity.referral?.list?[index]
                                      .name ??
                                  '-',
                              eliteRegDate: state.eliteMeEntity.referral
                                      ?.list?[index].joinDate
                                      .toDateShortMonthStr() ??
                                  '-',
                              eliteExpDate: state.eliteMeEntity.referral
                                      ?.list?[index].validUntil
                                      .toDateShortMonthStr() ??
                                  '-',
                            ),
                          ),
                        )
                      : const Column(
                          children: [
                            SizedBox(height: 20),
                            EmptyWidget(
                              desc: 'Oops Kamu Belum Memiliki Referral',
                            ),
                            SizedBox(height: 40),
                          ],
                        );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/constants/transaction_status.dart';
import '../../../../cores/utils/dialog_utils.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_button.dart';
import '../../../../cores/widgets/main_progress_bar.dart';
import '../../domain/entities/lakusave_extend_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../blocs/lakusave_cancel/lakusave_cancel_bloc.dart';
import '../blocs/lakusave_update_extend/lakusave_update_extend_bloc.dart';
import '../blocs/master_data/master_data_lakusave_bloc.dart';
import '../cubits/lakusave_update_extend/lakusave_update_extend_cubit.dart';

class LakuSaveItemWidget extends StatelessWidget {
  final bool isElite;
  final List<TransactionEntity> items;
  const LakuSaveItemWidget({
    super.key,
    this.isElite = false,
    this.items = const [],
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      children: items
          .map(
            (item) => Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: isElite
                    ? clrGreyE5e.withOpacity(0.12)
                    : clrGreyE5e.withOpacity(0.25),
                border: Border.all(
                  width: 2,
                  color: clrNeutralGrey999.withOpacity(0.16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: RichText(
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          text: TextSpan(children: [
                            TextSpan(
                              text: item.statusLabel ?? '-',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isElite ? clrWhite : clrDarkBlue,
                              ),
                            ),
                            // const WidgetSpan(child: SizedBox(width: 4)),
                            // WidgetSpan(child: Image.asset(icProcess)),
                          ]),
                        ),
                        // flex: 2,
                        // child: Row(
                        //   children: [
                        //     Text(
                        //       item.statusLabel ?? '-',
                        //       style: TextStyle(
                        //         fontSize: 16,
                        //         fontWeight: FontWeight.w600,
                        //         color: isElite ? clrWhite : clrDarkBlue,
                        //       ),
                        //     ),
                        //     const SizedBox(width: 4),
                        //     Expanded(
                        //       child: Container(
                        //         alignment: Alignment.centerLeft,
                        //         child: Image.asset(icProcess),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ),
                      if (item.status != TransactionStatus.success) ...[
                        // const Expanded(flex: 1, child: SizedBox()),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            DialogUtils.confirm(
                              context: context,
                              barrierDismissible: true,
                              firstDesc: t.lblLakuSaveCancelTitle,
                              secondDesc: t.lblLakuSaveCancelDesc,
                              btnText: '${t.lblYes}, ${t.lblCancel}',
                              btnTextLater: t.lblBack,
                              btnConfirm: () {
                                context
                                    .read<LakusaveCancelBloc>()
                                    .add(LakusaveCancelDoItEvent(item.code));
                                context.pop();
                              },
                              btnLater: () {
                                context.pop();
                              },
                            );
                          },
                          child: Text(
                            t.lblCancel,
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            style: TextStyle(
                              color: clrRed,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                      if (item.status == TransactionStatus.success) ...[
                        GestureDetector(
                          onTap: () {
                            var state = (context
                                .read<MasterDataLakusaveBloc>()
                                .state as MasterDataLakusaveSuccessState);
                            var currExtend = state.goldDepositEntity?.extendss
                                .where((element) =>
                                    element.name?.toLowerCase() ==
                                    item.depositEntity?.extendLabel
                                        ?.toLowerCase())
                                .first;
                            context
                                .read<LakusaveUpdateExtendCubit>()
                                .change(currExtend);
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) {
                                return BlocProvider.value(
                                  value:
                                      context.read<LakusaveUpdateExtendCubit>(),
                                  child: AlertDialog(
                                    backgroundColor: clrBackgroundBlack,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${t.lblSelect} ${t.lblExtendStatus}',
                                            textScaler: TextScaler.linear(
                                                TextUtils.textScaleFactor(
                                                    context)),
                                            style: TextStyle(
                                              color: clrWhite,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          ...(state.goldDepositEntity
                                                      ?.extendss ??
                                                  [])
                                              .map(
                                            (e) => Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Divider(
                                                    color: clrNeutralGrey999
                                                        .withOpacity(0.16)),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      e.name ?? '-',
                                                      textScaler: TextScaler
                                                          .linear(TextUtils
                                                              .textScaleFactor(
                                                                  context)),
                                                      style: TextStyle(
                                                        color: clrWhite
                                                            .withOpacity(0.75),
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                    BlocBuilder<
                                                        LakusaveUpdateExtendCubit,
                                                        LakusaveExtendEntity?>(
                                                      builder: (context,
                                                          selectedExtend) {
                                                        return Radio(
                                                          value: e,
                                                          groupValue:
                                                              selectedExtend,
                                                          onChanged: (value) {
                                                            context
                                                                .read<
                                                                    LakusaveUpdateExtendCubit>()
                                                                .change(value);
                                                          },
                                                          fillColor:
                                                              MaterialStateProperty
                                                                  .resolveWith<
                                                                      Color>(
                                                            (Set<MaterialState>
                                                                states) {
                                                              return clrWhite
                                                                  .withOpacity(
                                                                      0.75);
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 30),
                                          Text(
                                            'Batas waktu maksimal perubahan adalah 1 bulan sebelum durasi simpanan berkahir',
                                            textScaler: TextScaler.linear(
                                                TextUtils.textScaleFactor(
                                                    context)),
                                            style: TextStyle(
                                              color: clrWhite.withOpacity(0.75),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          const SizedBox(height: 32),
                                          SizedBox(
                                            width: double.infinity,
                                            child: MainButton(
                                              label: t.lblConfirm,
                                              onPressed: () {
                                                context
                                                    .read<
                                                        LakusaveUpdateExtendBloc>()
                                                    .add(
                                                        LakusaveUpdateExtendNowEvent(
                                                      extendId: context
                                                          .read<
                                                              LakusaveUpdateExtendCubit>()
                                                          .state
                                                          ?.id,
                                                      accountNumber: item
                                                          .depositEntity
                                                          ?.accountNumber,
                                                    ));
                                                context.pop();
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          SizedBox(
                                            width: double.infinity,
                                            child: MainButton(
                                              label: t.lblCancel,
                                              labelStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                                color: clrYellow,
                                              ),
                                              bgColor: Colors.transparent,
                                              border: BorderSide(
                                                width: 2,
                                                color: clrYellow,
                                              ),
                                              onPressed: () {
                                                context
                                                    .read<
                                                        LakusaveUpdateExtendCubit>()
                                                    .change(null);
                                                context.pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text(
                            'Ubah Perpanjangan',
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            style: TextStyle(
                              color: clrOrange,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          // child: Icon(Icons.edit),
                        ),
                      ]
                    ],
                  ),
                  Divider(
                    color: clrNeutralGrey999.withOpacity(0.5),
                    height: 33,
                  ),
                  if (item.status == TransactionStatus.pending ||
                      item.status == TransactionStatus.debetPending)
                    _approvalInfo(context),
                  if (item.status == TransactionStatus.success)
                    _detailOverviewText(
                      context,
                      title: t.lblSavedSince,
                      subTitle: item.depositEntity?.startDate ?? '-',
                      isElite: isElite,
                      margin: const EdgeInsets.only(bottom: 16),
                    ),
                  _detailOverviewText(
                    context,
                    title: t.lblGoldDeposit,
                    subTitle: '${item.goldWeight ?? '-'} gram',
                    isElite: isElite,
                    margin: const EdgeInsets.only(bottom: 16),
                  ),
                  _detailOverviewText(
                    context,
                    title: t.lblCapitalLeaseYear,
                    subTitle: '${item.depositEntity?.interest ?? '-'}%',
                    isElite: isElite,
                    margin: const EdgeInsets.only(bottom: 16),
                  ),
                  _detailOverviewText(
                    context,
                    title: t.lblSaveDuration,
                    subTitle:
                        '${item.depositEntity?.duration ?? '-'} ${t.lblMonths}',
                    isElite: isElite,
                    margin: const EdgeInsets.only(bottom: 16),
                  ),
                  _detailOverviewText(
                    context,
                    title: t.lblExtendStatus,
                    subTitle: item.depositEntity?.extendLabel ?? '-',
                    isElite: isElite,
                  ),
                  if (item.status == TransactionStatus.success)
                    _additionalSavedWidget(context, t, item),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _additionalSavedWidget(
      BuildContext context, AppLocalizations t, TransactionEntity item) {
    var startDate =
        DateFormat('dd MMMM yyy').parse(item.depositEntity?.startDate ?? '');
    DateTime now = DateTime.now();
    int totalDays = now.difference(startDate).inDays;
    int years = totalDays ~/ 365;
    int months = (totalDays - years * 365) ~/ 30;
    return Column(
      children: [
        const SizedBox(height: 16),
        MainProgressBar(
          currentProgress: months,
          maxProgress: int.parse(item.depositEntity?.duration ?? '4'),
          bgColor: (isElite ? clrWhite : clrBackgroundBlack).withOpacity(0.5),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                item.depositEntity?.startDate ?? '-',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  color: (isElite ? clrWhite : clrBackgroundBlack)
                      .withOpacity(0.75),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                item.depositEntity?.endDate ?? '-',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: (isElite ? clrWhite : clrBackgroundBlack)
                      .withOpacity(0.75),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        // if (item.depositEntity?.isEnableUpdateExtend == true)
        //   const SizedBox(height: 20),
        // if (item.depositEntity?.isEnableUpdateExtend == true)
        //   BlocBuilder<MasterDataLakusaveBloc, MasterDataLakusaveState>(
        //     builder: (context, state) {
        //       if (state is MasterDataLakusaveLoadingState) {
        //         return const Center(
        //           child: CircularProgressIndicator(),
        //         );
        //       }
        //       if (state is MasterDataLakusaveSuccessState) {
        //         return SizedBox(
        //           width: double.infinity,
        //           child: MainButton(
        //             label: '${t.lblEdit} ${t.lblExtendStatus}',
        //             labelStyle: TextStyle(
        //               fontSize: 14,
        //               fontWeight: FontWeight.w600,
        //               color: isElite ? clrWhite : clrBackgroundBlack,
        //             ),
        //             bgColor: (isElite ? clrWhite : clrNeutralGrey999)
        //                 .withOpacity(0.5),
        //             onPressed: () {
        //               var currExtend = state.goldDepositEntity?.extendss
        //                   .where((element) =>
        //                       element.name?.toLowerCase() ==
        //                       item.depositEntity?.extendLabel?.toLowerCase())
        //                   .first;
        //               context
        //                   .read<LakusaveUpdateExtendCubit>()
        //                   .change(currExtend);
        //               showDialog(
        //                 context: context,
        //                 barrierDismissible: false,
        //                 builder: (_) {
        //                   return BlocProvider.value(
        //                     value: context.read<LakusaveUpdateExtendCubit>(),
        //                     child: AlertDialog(
        //                       backgroundColor: clrBackgroundBlack,
        //                       shape: RoundedRectangleBorder(
        //                         borderRadius: BorderRadius.circular(30),
        //                       ),
        //                       content: SizedBox(
        //                         width: MediaQuery.of(context).size.width * 0.9,
        //                         child: Column(
        //                           mainAxisSize: MainAxisSize.min,
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             Text(
        //                               '${t.lblSelect} ${t.lblExtendStatus}',
        //                               style: TextStyle(
        //                                 color: clrWhite,
        //                                 fontSize: 16,
        //                                 fontWeight: FontWeight.w600,
        //                               ),
        //                             ),
        //                             ...(state.goldDepositEntity?.extendss ?? [])
        //                                 .map(
        //                               (e) => Column(
        //                                 mainAxisSize: MainAxisSize.min,
        //                                 crossAxisAlignment:
        //                                     CrossAxisAlignment.start,
        //                                 children: [
        //                                   Divider(
        //                                       color: clrNeutralGrey999
        //                                           .withOpacity(0.16)),
        //                                   Row(
        //                                     mainAxisAlignment:
        //                                         MainAxisAlignment.spaceBetween,
        //                                     children: [
        //                                       Text(
        //                                         e.name ?? '-',
        //                                         style: TextStyle(
        //                                           color: clrWhite
        //                                               .withOpacity(0.75),
        //                                           fontSize: 14,
        //                                           fontWeight: FontWeight.w500,
        //                                         ),
        //                                       ),
        //                                       BlocBuilder<
        //                                           LakusaveUpdateExtendCubit,
        //                                           LakusaveExtendEntity?>(
        //                                         builder:
        //                                             (context, selectedExtend) {
        //                                           return Radio(
        //                                             value: e,
        //                                             groupValue: selectedExtend,
        //                                             onChanged: (value) {
        //                                               context
        //                                                   .read<
        //                                                       LakusaveUpdateExtendCubit>()
        //                                                   .change(value);
        //                                             },
        //                                             fillColor:
        //                                                 MaterialStateProperty
        //                                                     .resolveWith<Color>(
        //                                               (Set<MaterialState>
        //                                                   states) {
        //                                                 return clrWhite
        //                                                     .withOpacity(0.75);
        //                                               },
        //                                             ),
        //                                           );
        //                                         },
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ],
        //                               ),
        //                             ),
        //                             const SizedBox(height: 30),
        //                             Text(
        //                               'Batas waktu maksimal perubahan adalah 1 bulan sebelum durasi simpanan berkahir',
        //                               style: TextStyle(
        //                                 color: clrWhite.withOpacity(0.75),
        //                                 fontSize: 12,
        //                                 fontWeight: FontWeight.w400,
        //                               ),
        //                             ),
        //                             const SizedBox(height: 32),
        //                             SizedBox(
        //                               width: double.infinity,
        //                               child: MainButton(
        //                                 label: t.lblConfirm,
        //                                 onPressed: () {
        //                                   context
        //                                       .read<LakusaveUpdateExtendBloc>()
        //                                       .add(LakusaveUpdateExtendNowEvent(
        //                                         extendId: context
        //                                             .read<
        //                                                 LakusaveUpdateExtendCubit>()
        //                                             .state
        //                                             ?.id,
        //                                         accountNumber: item
        //                                             .depositEntity
        //                                             ?.accountNumber,
        //                                       ));
        //                                   context.pop();
        //                                 },
        //                               ),
        //                             ),
        //                             const SizedBox(height: 16),
        //                             SizedBox(
        //                               width: double.infinity,
        //                               child: MainButton(
        //                                 label: t.lblCancel,
        //                                 labelStyle: TextStyle(
        //                                   fontSize: 14,
        //                                   fontWeight: FontWeight.w600,
        //                                   color: clrYellow,
        //                                 ),
        //                                 bgColor: Colors.transparent,
        //                                 border: BorderSide(
        //                                   width: 2,
        //                                   color: clrYellow,
        //                                 ),
        //                                 onPressed: () {
        //                                   context
        //                                       .read<LakusaveUpdateExtendCubit>()
        //                                       .change(null);
        //                                   context.pop();
        //                                 },
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                   );
        //                 },
        //               );
        //             },
        //           ),
        //         );
        //       }
        //       return const SizedBox();
        //     },
        //   ),
      ],
    );
  }

  Container _approvalInfo(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: clrYellow.withOpacity(0.16),
        border: Border.all(
          width: 1.5,
          color: clrNeutralGrey999.withOpacity(0.16),
        ),
      ),
      child: Row(
        children: [
          Image.asset(icWarningOrange),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              t.lblMaxApprove,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isElite ? clrWhite : clrBackgroundBlack,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container _detailOverviewText(
    BuildContext context, {
    required String title,
    String? subTitle,
    bool isElite = false,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isElite
                  ? clrWhite.withOpacity(0.75)
                  : clrBackgroundBlack.withOpacity(0.75),
            ),
          ),
          Text(
            subTitle ?? '-',
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isElite ? clrWhite : clrBackgroundBlack,
            ),
          ),
        ],
      ),
    );
  }
}

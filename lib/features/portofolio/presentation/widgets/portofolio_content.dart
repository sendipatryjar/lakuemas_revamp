import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/constants/app_color.dart';
import '../../../../cores/extensions/currency_extension.dart';
import '../../../../features/portofolio/presentation/blocs/get_portofolio/get_portofolio_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/errors/app_failure.dart';
import '../../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../../cores/utils/bottom_sheet_utils.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/errors/server_error_screen.dart';
import '../../../../cores/widgets/main_button.dart';
import 'doughnut_chart_widget.dart';
import 'portofolio_card_widget.dart';

class PortofolioContent extends StatelessWidget {
  final bool isElite;
  const PortofolioContent({
    super.key,
    required this.isElite,
  });

  @override
  Widget build(BuildContext context) {
    double? doughnutPadding;
    double? doughnutRadius;
    double topWidgetPadding = 20;
    double topWidgetInnerPadding = 20;
    double portofolioCardPadding = 20;
    double spaceBetweenPortofolioCard = 0;
    return LayoutBuilder(builder: (_, ctr) {
      if (ctr.maxWidth > 627) {
        doughnutPadding = 64;
        doughnutRadius = 100;
        topWidgetPadding = 36;
        topWidgetInnerPadding = 36;
        portofolioCardPadding = 22;
        spaceBetweenPortofolioCard = 8;
      }
      if (ctr.maxWidth > 1240) {
        doughnutPadding = 144;
        doughnutRadius = 150;
        topWidgetPadding = 52;
        topWidgetInnerPadding = 34;
        spaceBetweenPortofolioCard = 16;
      }
      return BlocBuilder<GetPortofolioBloc, GetPortofolioState>(
        builder: (context, state) {
          if (state is GetPortofolioFailureState) {
            if (state.appFailure is ServerFailure) {
              return ServerErrorScreen(
                onTryAgainPressed: () {
                  context.read<GetPortofolioBloc>().add(GetPortofolioLoadEvent(
                        helperDataCubit: context.read<HelperDataCubit>(),
                      ));
                },
              );
            }
          }
          if (state is GetPortofolioLoadingState) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: List.generate(
                    3,
                    (index) => Shimmer.fromColors(
                      baseColor: clrGreyShimmerBase,
                      highlightColor: clrGreyShimmerHighlight,
                      child: Container(
                        width: double.infinity,
                        height: 180,
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
          if (state is GetPortofolioSuccessState) {
            var savings = state.portofolioEntity.savings;
            var deposit = state.portofolioEntity.deposit;

            return RefreshIndicator(
              onRefresh: () async {
                context.read<HelperDataCubit>().resetPortofolio();
                context.read<GetPortofolioBloc>().add(GetPortofolioLoadEvent(
                      helperDataCubit: context.read<HelperDataCubit>(),
                    ));
              },
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(topWidgetPadding),
                      decoration: BoxDecoration(
                        color: isElite ? clrYellow : clrBlack101,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(30),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(topWidgetInnerPadding),
                        decoration: BoxDecoration(
                          color: clrNeutralGrey999.withOpacity(0.128),
                          border: Border.all(color: clrWhite.withOpacity(0.2)),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Total Asset Emas",
                                  textScaler: TextScaler.linear(
                                      TextUtils.textScaleFactor(context)),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: isElite ? clrDarkBrown : clrWhite,
                                  ),
                                ),
                                InkWell(
                                    onTap: () {
                                      BottomSheetUtils.general(
                                        context: context,
                                        bgColor: clrBackgroundBlack,
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text.rich(
                                                textScaler: TextScaler.linear(
                                                    TextUtils.textScaleFactor(
                                                        context)),
                                                TextSpan(
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: clrWhite,
                                                    ),
                                                    children: const [
                                                      TextSpan(
                                                          text:
                                                              "Potential Gain ",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          )),
                                                      TextSpan(
                                                          text:
                                                              "diperoleh melalui perhitungan persentase harga jual dikurangi rata-rata harga beli pada setiap transaksi pembelian, termasuk transaksi dengan menggunakan voucher dan sewa modal dari Laku Simpan. Jika ada transfer emas dari pengguna lain, dihitung berdasarkan harga perolehan emas tersebut"),
                                                      TextSpan(
                                                          text:
                                                              " (Harga Beli x Gramasi Transfer).",
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          )),
                                                    ])),
                                            const SizedBox(height: 32),
                                            MainButton(
                                              label: 'Kembali',
                                              onPressed: () {
                                                context.pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Icon(
                                      Icons.info,
                                      size: 16,
                                      color: isElite
                                          ? clrBackgroundBlack
                                          : clrNeutralGrey999,
                                    )),
                              ],
                            ),
                            Text.rich(
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Rp',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isElite ? clrDarkBrown : clrWhite,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        ' ${state.portofolioEntity.totalNominal?.toIdr() ?? '-'}',
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w600,
                                      color: isElite ? clrDarkBrown : clrWhite,
                                    ),
                                  ),
                                ],
                              ),
                              softWrap: true,
                            ),
                            Divider(color: clrNeutralGrey999.withOpacity(0.32)),
                            Text(
                              "Potential Gain ${state.portofolioEntity.potentialGainPercentage}%",
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: (state.portofolioEntity
                                                .potentialGainPercentage ??
                                            0)
                                        .isNegative
                                    ? clrRed
                                    : clrGreen00A,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: doughnutPadding != null
                          ? EdgeInsets.symmetric(vertical: doughnutPadding!)
                          : null,
                      child: DoughnutChartWidget(
                        isElite: isElite,
                        goldAsset: "${state.portofolioEntity.totalWeight}",
                        radiusInPercent: doughnutRadius,
                        listData: (state.portofolioEntity.totalWeight ?? 0) > 0
                            ? [
                                PortofolioChartData(
                                  x: "Saldo Emas",
                                  y: double.tryParse(
                                      state.portofolioEntity.savings?.weight ??
                                          ""),
                                  pointColor: clrYellow,
                                ),
                                PortofolioChartData(
                                  x: "Laku Simpan",
                                  y: double.tryParse(
                                      state.portofolioEntity.deposit?.weight ??
                                          ""),
                                  pointColor: clrPurple,
                                )
                              ]
                            : [
                                PortofolioChartData(
                                  x: "",
                                  y: 1,
                                  pointColor: clrNeutralGrey999,
                                ),
                              ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 20,
                      ),
                      child: Column(
                        children: [
                          PortofolioCardWidget(
                            padding: portofolioCardPadding,
                            isElite: isElite,
                            imgUrl: icGoldPort,
                            title: 'Saldo Emas',
                            titleValue: '${savings?.weight ?? '-'} gr',
                            subTitle: "Digital Gold",
                            subTitleValue:
                                "Rp ${savings?.nominal.toIdr() ?? "-"}",
                            progress:
                                int.tryParse(savings?.percentage ?? '') ?? 0,
                            valueColor: clrYellow,
                          ),
                          SizedBox(height: spaceBetweenPortofolioCard),
                          PortofolioCardWidget(
                            padding: portofolioCardPadding,
                            isElite: isElite,
                            imgUrl: icGoldPort,
                            title:
                                'Laku Simpan (${deposit?.totalCount ?? '-'})',
                            titleValue: '${deposit?.weight ?? '-'} gr',
                            subTitle: "${deposit?.totalCount ?? '-'} Simpanan",
                            subTitleValue:
                                "Rp ${deposit?.nominal.toIdr() ?? "-"}",
                            progress:
                                int.tryParse(deposit?.percentage ?? '') ?? 0,
                            valueColor: clrPurple,
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
          return const SizedBox();
        },
      );
    });
  }
}

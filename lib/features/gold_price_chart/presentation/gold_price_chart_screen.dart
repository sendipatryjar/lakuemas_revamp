import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cores/extensions/currency_extension.dart';
import '../../../cores/extensions/date_extension.dart';
import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/errors/server_error_screen.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../_core/transaction/domain/entities/price_entity.dart';
import '../domain/entities/chart_duration_entity.dart';
import '../domain/entities/chart_entity.dart';
import 'blocs/bloc/get_chart_bloc.dart';
import 'cubits/filter_tab/filter_tab_cubit.dart';
import 'widgets/chart_widget.dart';
import 'widgets/price_box_widget.dart';

class GoldPriceChartScreen extends StatelessWidget {
  final PriceEntity? priceEntity;
  const GoldPriceChartScreen({super.key, this.priceEntity});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => sl<GetChartBloc>()..add(GetChartNowEvent())),
        BlocProvider(create: (context) => sl<FilterTabCubit>()),
      ],
      child: BlocListener<GetChartBloc, GetChartState>(
        listener: (context, state) {
          if (state is GetChartLoadingState) {
            EasyLoading.show();
          }
          if (state is GetChartSuccessState) {
            EasyLoading.dismiss();
          }
          if (state is GetChartFailureState) {
            EasyLoading.dismiss();
            if (state.appFailure is ServerFailure) {
              return;
            }
            EasyLoading.showError(
              errorMessage(state.appFailure) ?? t.lblSomethingWrong,
              dismissOnTap: true,
            );
          }
        },
        child: _Content(
          priceEntity: priceEntity,
        ),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  final PriceEntity? priceEntity;
  const _Content({
    Key? key,
    this.priceEntity,
  }) : super(key: key);

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return BlocBuilder<GetChartBloc, GetChartState>(
          builder: (context, state) {
            if (state is GetChartFailureState) {
              if (state.appFailure is ServerFailure) {
                return Scaffold(
                  backgroundColor: isElite ? clrBlack080 : null,
                  appBar: AppBar(
                    backgroundColor: clrBlack101,
                    title: Text(
                      "Error",
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                    ),
                    centerTitle: true,
                    leading: MainBackButton(
                      onPressed: () {
                        context.goNamed(AppRoutes.beranda);
                      },
                    ),
                  ),
                  body: ServerErrorScreen(
                    onTryAgainPressed: () {
                      context.read<GetChartBloc>().add(GetChartNowEvent());
                    },
                  ),
                );
              }
            }
            return Scaffold(
              backgroundColor: isElite ? clrBlack080 : null,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: clrBlack101,
                centerTitle: true,
                title: Text(
                  'Grafik',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                leading: MainBackButton(
                  onPressed: () {
                    context.goNamed(AppRoutes.beranda);
                  },
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(20),
                child: _tabController.index == 0
                    ? MainButton(
                        label: '${t.lblBuy}' ' ${t.lblGold}',
                        onPressed: () {
                          context.goNamed(
                            AppRoutes.buyGold,
                            extra: {
                              'isFromElite': false,
                              'isFromGrafik': true,
                              'priceEntity': widget.priceEntity,
                              'isElite': isElite.toString(),
                              'backScreenBuyGold': AppRoutes.goldPriceChart,
                            },
                          );
                        },
                      )
                    : MainButton(
                        label: '${t.lblSell}' ' ${t.lblGold}',
                        onPressed: () {
                          context.goNamed(
                            AppRoutes.sellGold,
                            extra: {
                              'isFromGrafik': true,
                              'priceEntity': widget.priceEntity,
                              'isElite': isElite.toString()
                            },
                          );
                        },
                      ),
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _tabBar(context),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _contentChart(
                          context: context,
                          isElite: isElite,
                          isPurchase: true,
                          priceEntity: widget.priceEntity,
                        ),
                        _contentChart(
                          context: context,
                          isElite: isElite,
                          isPurchase: false,
                          priceEntity: widget.priceEntity,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  SingleChildScrollView _contentChart({
    required BuildContext context,
    required bool isElite,
    required bool isPurchase,
    PriceEntity? priceEntity,
  }) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<FilterTabCubit, FilterTabState>(
              builder: (context, state) {
                return GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  crossAxisCount: 4,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.5,
                  children: context
                      .read<FilterTabCubit>()
                      .durations
                      .map(
                        (e) => _filterTab(
                          isElite: isElite,
                          title: (e['title'] ?? '-').toString(),
                          isSelected: state.enFilteredTab == e['enFilteredTab'],
                          onTap: () {
                            context.read<FilterTabCubit>().changeFilterTab(
                                e['enFilteredTab'] as EnFilteredTab);
                          },
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<GetChartBloc, GetChartState>(
            builder: (context, getChartState) {
              ChartDurationEntity? chartDurationEntity;
              if (getChartState is GetChartSuccessState) {
                chartDurationEntity = getChartState.chartDurationEntity;
              }
              return BlocBuilder<FilterTabCubit, FilterTabState>(
                builder: (context, filterTabState) {
                  List<ChartEntity> charts = _chartsData(
                    filterTabState.enFilteredTab,
                    chartDurationEntity,
                  );
                  return ChartWidget(
                    isElite: isElite,
                    isPurchase: isPurchase,
                    chartData: charts,
                    enFilteredTab: filterTabState.enFilteredTab,
                    onRendererCreated: (p0) {
                      Future.delayed(const Duration(milliseconds: 0))
                          .then((value) {
                        p0.animate();
                      });
                    },
                  );
                },
              );
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PriceBoxWidget(
              isElite: isElite,
              titleReguler:
                  isPurchase ? 'Harga Beli Reguler' : 'Harga Jual Reguler',
              titleElite: isPurchase ? 'Harga Beli Elite' : 'Harga Jual Elite',
              date: DateTime.now().toDateStr('EEEE, dd MMMM yyyy'),
              priceReguler: isPurchase
                  ? 'Rp ${priceEntity?.sellingPrice?.toIdr()}'
                  : 'Rp ${priceEntity?.purchasePrice?.toIdr()}',
              priceElite: isPurchase
                  ? 'Rp ${priceEntity?.eliteSellingPrice?.toIdr()}'
                  : 'Rp ${priceEntity?.elitePurchasePrice?.toIdr()}',
            ),
          ),
          const SizedBox(height: 16),
          if (isElite != true)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _subscribeElite(
                context,
                isElite: isElite,
                priceEntity: priceEntity,
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  List<ChartEntity> _chartsData(
      EnFilteredTab? enFilteredTab, ChartDurationEntity? chartDurationEntity) {
    switch (enFilteredTab) {
      case EnFilteredTab.sevenDays:
        return chartDurationEntity?.sevenDaysAgo ?? [];
      case EnFilteredTab.oneMonth:
        return chartDurationEntity?.oneMonthAgo ?? [];
      case EnFilteredTab.thirdMonth:
        return chartDurationEntity?.threeMonthsAgo ?? [];
      case EnFilteredTab.sixMonth:
        return chartDurationEntity?.sixMonthsAgo ?? [];
      default:
        return [];
    }
  }

  Widget _tabBar(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      color: clrBlack101,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            controller: _tabController,
            indicatorWeight: 3,
            indicatorColor: clrYellow,
            labelColor: clrYellow,
            unselectedLabelColor: clrWhite.withOpacity(0.50),
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Tab(
                text: t.lblPurchasePrice,
              ),
              Tab(
                text: t.lblSellingPrice,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _subscribeElite(
    BuildContext context, {
    required bool isElite,
    PriceEntity? priceEntity,
  }) {
    return GestureDetector(
      onTap: () => context.goNamed(
        AppRoutes.elite,
        extra: {
          'isElite': isElite.toString(),
          'isFromGrafik': true,
          'priceEntity': priceEntity
        },
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: clrYellow.withOpacity(0.16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Langganan Lakuemas Elite Sekarang!',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: isElite ? clrWhite : clrBackgroundBlack,
                letterSpacing: 0.03,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: isElite ? clrWhite : clrBackgroundBlack,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterTab({
    required bool isElite,
    required String title,
    bool isSelected = false,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // padding: const EdgeInsets.symmetric(
        //   horizontal: 16,
        //   vertical: 8,
        // ),
        decoration: BoxDecoration(
          color: isSelected ? clrYellow : null,
          borderRadius: BorderRadius.circular(15),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            color: isSelected
                ? (isElite ? clrBackgroundBlack : clrBackgroundBlack)
                : (isElite ? clrWhite : clrBackgroundBlack),
          ),
        ),
      ),
    );
  }
}

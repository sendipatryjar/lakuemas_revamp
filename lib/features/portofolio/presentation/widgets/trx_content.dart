import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/extensions/currency_extension.dart';
import '../../../../cores/utils/app_utils.dart';
import '../../../../cores/utils/dialog_utils.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';

import '../../../../cores/constants/transaction_detail_type.dart';
import '../../../../cores/extensions/date_extension.dart';
import '../../../../cores/constants/app_color.dart';
import '../../../../cores/models/data_with_meta.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_button.dart';
import '../../../../cores/widgets/modal_bottom_sheet/modal_bottom_sheet.dart';
import '../../domain/entities/trx_history_entity.dart';
import '../blocs/trx_history/trx_history_bloc.dart';
import '../cubits/trx_history/trx_history_cubit.dart';
import 'empty_trx_widget.dart';
import 'filter_method.dart';
import 'trx_card_widget.dart';

class TrxContent extends StatelessWidget {
  final bool isElite;
  const TrxContent({
    super.key,
    required this.isElite,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TrxHistoryCubit, TrxHistoryCubitState>(
          listenWhen: (previous, current) =>
              previous.trxTypeSelected != current.trxTypeSelected ||
              previous.trxStatusSelected != current.trxStatusSelected,
          listener: (context, state) {
            context.read<TrxHistoryBloc>().add(
                  TrxHistoryGetEvent(
                    type: state.filterTrxType,
                    status: state.trxStatus,
                    period: state.filterTrxDate,
                    startDate: state.date?[0].toDateStr('yyyy-MM-dd'),
                    endDate: state.date?.length == 1
                        ? state.date![0].toDateStr('yyyy-MM-dd')
                        : state.date?[1].toDateStr('yyyy-MM-dd'),
                    limit: 10,
                    isInitData: true,
                  ),
                );
            context.read<TrxHistoryCubit>().removeTrxHistory();
          },
        ),
        BlocListener<TrxHistoryCubit, TrxHistoryCubitState>(
          listenWhen: (previous, current) =>
              previous.trxDateSelected != current.trxDateSelected,
          listener: (context, state) {
            // final String? startDate = state.date?[0].toDateStr('yyyy-MM-dd');
            // final String? endDate = state.date?.length == 1
            //     ? state.date![0].toDateStr('yyyy-MM-dd')
            //     : state.date?[1].toDateStr('yyyy-MM-dd');

            // appPrint(startDate.toString());
            // appPrint(endDate.toString());

            // DateTime startDatePeriod = DateTime.parse(startDate ?? '');
            // DateTime endDatePeriod = DateTime.parse(endDate ?? '');

            // // // Calculate the duration between the two dates
            // Duration difference = endDatePeriod.difference(startDatePeriod);

            // // Access the duration components
            // int days = difference.inDays;

            // appPrint(days.toString());

            // if (days > 90) {
            //   DialogUtils.universal(
            //     context: context,
            //     firstDesc: 'Periode Filter Yang Dapat Dipilih 90 Hari',
            //     secondDesc: '',
            //     btnText: 'Kembali',
            //     btnConfirm: () {
            //       context.pop();
            //     },
            //   );
            // }

            switch (state.trxDateSelected) {
              case 0:
                context.read<TrxHistoryBloc>().add(
                      TrxHistoryGetEvent(
                        type: state.filterTrxType,
                        status: state.trxStatus,
                        period: null,
                        startDate: null,
                        endDate: null,
                        limit: 10,
                        isInitData: true,
                      ),
                    );
              case 1:
                context.read<TrxHistoryBloc>().add(
                      TrxHistoryGetEvent(
                        type: state.filterTrxType,
                        status: state.trxStatus,
                        period: '7days',
                        limit: 10,
                        isInitData: true,
                      ),
                    );
              case 2:
                context.read<TrxHistoryBloc>().add(
                      TrxHistoryGetEvent(
                        type: state.filterTrxType,
                        status: state.trxStatus,
                        period: '30days',
                        limit: 10,
                        isInitData: true,
                      ),
                    );
              case 3:
                context.read<TrxHistoryBloc>().add(
                      TrxHistoryGetEvent(
                        type: state.filterTrxType,
                        status: state.trxStatus,
                        period: '90days',
                        limit: 10,
                        isInitData: true,
                      ),
                    );
              case 4:
                return;
              default:
                return;
            }
            context.read<TrxHistoryCubit>().removeTrxHistory();
          },
        ),
      ],
      child: Column(
        children: [
          Container(
            // padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 76,
            decoration: BoxDecoration(
              color: isElite ? clrBlack080 : clrWhite,
              border: Border(
                bottom: BorderSide(
                  width: 2.5,
                  color: clrNeutralGrey999.withOpacity(0.16),
                ),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      _showTrxTypeFilter(context, isElite);
                    },
                    child: BlocBuilder<TrxHistoryCubit, TrxHistoryCubitState>(
                        builder: (context, state) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: (state.trxType ?? '').isNotEmpty
                              ? clrYellow
                              : isElite
                                  ? clrBlack080
                                  : clrWhite,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 2.5,
                            color: clrNeutralGrey999.withOpacity(0.16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              state.trxType ?? 'Semua Transaksi',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: (state.trxType ?? '').isNotEmpty
                                    ? clrBackgroundBlack
                                    : isElite
                                        ? clrWhite
                                        : clrBackgroundBlack,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: (state.trxType ?? '').isNotEmpty
                                  ? clrBackgroundBlack
                                  : isElite
                                      ? clrWhite
                                      : clrBackgroundBlack,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      _showTrxStatusFilter(context, isElite);
                    },
                    child: BlocBuilder<TrxHistoryCubit, TrxHistoryCubitState>(
                        builder: (context, state) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: (state.filterTrxStatus ?? '').isNotEmpty
                              ? clrYellow
                              : isElite
                                  ? clrBlack080
                                  : clrWhite,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            width: 2.5,
                            color: clrNeutralGrey999.withOpacity(0.16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              (state.filterTrxStatus ?? '').isEmpty
                                  ? 'Semua Status'
                                  : state.filterTrxStatus ?? 'Semua Status',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: (state.filterTrxStatus ?? '').isNotEmpty
                                    ? clrBackgroundBlack
                                    : isElite
                                        ? clrWhite
                                        : clrBackgroundBlack,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: (state.filterTrxStatus ?? '').isNotEmpty
                                  ? clrBackgroundBlack
                                  : isElite
                                      ? clrWhite
                                      : clrBackgroundBlack,
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      _showDateTrxFilter(context, isElite);
                    },
                    child: BlocBuilder<TrxHistoryCubit, TrxHistoryCubitState>(
                      builder: (context, state) {
                        final startDate = state.date?[0].toDateStr('dd/M/yyyy');
                        final endDate = (state.date ?? []).length > 1
                            ? (state.date?[1].toDateStr('dd/M/yyyy') ?? [])
                            : state.date?[0].toDateStr('dd/M/yyyy');

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: (state.trxDate ?? '').isNotEmpty
                                ? clrYellow
                                : isElite
                                    ? clrBlack080
                                    : clrWhite,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              width: 2.5,
                              color: clrNeutralGrey999.withOpacity(0.16),
                            ),
                          ),
                          child: Row(
                            children: [
                              Text(
                                (state.trxDateSelected == 4) &&
                                        (startDate ?? '').isNotEmpty
                                    ? '$startDate - $endDate'
                                    : (startDate ?? '').isEmpty &&
                                            endDate == false
                                        ? 'Pilih Tanggal Sendiri'
                                        : state.trxDate ?? 'Semua Tanggal',
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: (state.trxDate ?? '').isNotEmpty
                                      ? clrBackgroundBlack
                                      : isElite
                                          ? clrWhite
                                          : clrBackgroundBlack,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                size: 18,
                                color: (state.trxDate ?? '').isNotEmpty
                                    ? clrBackgroundBlack
                                    : isElite
                                        ? clrWhite
                                        : clrBackgroundBlack,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ),
          ),
          BlocBuilder<TrxHistoryCubit, TrxHistoryCubitState>(
            builder: (context, state) {
              return NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  final currOffset = notification.metrics.pixels;
                  final maxOffset = notification.metrics.maxScrollExtent;
                  final trxHistoryState = context.read<TrxHistoryCubit>().state;
                  final bool isLastPage = trxHistoryState.meta?.page ==
                      trxHistoryState.meta?.totalPage;
                  if ((isLastPage == false) &&
                      (notification.metrics.axis == Axis.vertical) &&
                      (currOffset >= (maxOffset - 0)) &&
                      (trxHistoryState.isLoading == false)) {
                    context.read<TrxHistoryCubit>().updateLoadingTrue();
                    context.read<TrxHistoryBloc>().add(
                          TrxHistoryGetEvent(
                            limit: 10,
                            page: (trxHistoryState.meta?.page ?? 0) + 1,
                            type: state.filterTrxType,
                            status: state.trxStatus,
                            period: state.filterTrxDate,
                            startDate: state.date?[0].toDateStr('yyyy-MM-dd'),
                            endDate: state.date?.length == 1
                                ? state.date![0].toDateStr('yyyy-MM-dd')
                                : state.date?[1].toDateStr('yyyy-MM-dd'),
                          ),
                        );
                  }
                  return false;
                },
                child: Expanded(
                  child: BlocBuilder<TrxHistoryCubit, TrxHistoryCubitState>(
                    buildWhen: (previous, current) =>
                        previous.trxHistory != current.trxHistory ||
                        previous.isError != current.isError ||
                        previous.isLoading != current.isLoading ||
                        previous.meta != current.meta,
                    builder: (context, state) {
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<TrxHistoryCubit>().removeTrxHistory();
                          var state = context.read<TrxHistoryCubit>().state;
                          context.read<TrxHistoryBloc>().add(TrxHistoryGetEvent(
                                type: state.filterTrxType,
                                status: state.trxStatus,
                                period: state.filterTrxDate,
                                startDate:
                                    state.date?[0].toDateStr('yyyy-MM-dd'),
                                endDate: state.date?.length == 1
                                    ? state.date![0].toDateStr('yyyy-MM-dd')
                                    : state.date?[1].toDateStr('yyyy-MM-dd'),
                                limit: 10,
                                page: 1,
                                isInitData: true,
                              ));
                        },
                        child: _trxHistory(
                          trxHistory: state.trxHistory,
                          metaData: state.meta,
                          isLoading: state.isLoading,
                          isError: state.isError,
                          isElite: isElite,
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _trxHistory({
    required List<TrxHistoryEntity> trxHistory,
    required MetaDataApi? metaData,
    required bool isLoading,
    required bool isError,
    required bool isElite,
  }) {
    if (isLoading && trxHistory.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (trxHistory.isEmpty) {
      return Center(
        child: EmptyTrxWidget(isElite: isElite),
      );
    }
    // final bool isLastPage = metaData?.page == metaData?.totalPage;
    final bool isLastPage =
        trxHistory.length < 10 || metaData?.page == metaData?.totalPage;
    return ListView.builder(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 40),
      itemCount: trxHistory.length + (isLastPage ? 0 : 1),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == trxHistory.length) {
          if (isError) {
            return Center(
              child: _errorDialog(context),
            );
          }
          return _loadingWidget(context, isElite);
        }
        return GestureDetector(
          onTap: () {
            if ((trxHistory[index].typeLabel ?? '')
                .toLowerCase()
                .startsWith('deposit')) {
              return;
            }
            context.goNamed(
              AppRoutes.paymentWaitingTrx,
              extra: {
                'eliteCubit': context.read<EliteCubit>(),
                'transactionCode': trxHistory[index].code,
                'transactionDetailType': TransactionDetailType.general,
                'backScreen': AppRoutes.portofolio,
              },
            );
          },
          child: TrxCardWidget(
            isElite: isElite,
            typeLabel: trxHistory[index].typeLabel,
            trxVal: '${trxHistory[index].goldWeight}',
            trxDate:
                'Tanggal ${_dynamicDateTrx(trxHistory[index].typeLabel ?? '')} ${trxHistory[index].createdAt.toDateStr()}',
            noTrxVal: trxHistory[index].code,
            totTrxVal: trxHistory[index].grossAmount == ''
                ? ''
                : trxHistory[index].grossAmount.toIdr(),
            currGoldVal: '${trxHistory[index].goldBalance} gram',
            statusLabel: trxHistory[index].statusLabel,
            status: trxHistory[index].status,
          ),
        );
      },
    );
  }

  Widget _loadingWidget(BuildContext context, bool isElite) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 16,
            width: 16,
            child: CircularProgressIndicator(
              color: clrYellow,
              backgroundColor: clrYellow.withOpacity(0.15),
              // strokeWidth: 6,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Memuat History',
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: (isElite ? clrWhite : clrBackgroundBlack)
                    .withOpacity(0.75)),
          ),
        ],
      ),
    );
  }

  Widget _errorDialog(BuildContext context, {String? message}) {
    return SizedBox(
      height: 180,
      width: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            message ?? 'An error occurred when fetching the data.',
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          const SizedBox(
            height: 10,
          ),
          const Icon(Icons.refresh)
        ],
      ),
    );
  }

  Future<void> _showTrxTypeFilter(BuildContext context, bool isElite) {
    return showMaterialModalBottomSheet<List<DateTime?>?>(
      expand: false,
      context: context,
      enableDrag: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<TrxHistoryCubit>()),
          BlocProvider.value(value: context.read<TrxHistoryBloc>()),
        ],
        child: _buildTrxTypeFilter(context, isElite),
      ),
    );
  }

  Future<void> _showTrxStatusFilter(BuildContext context, bool isElite) {
    return showMaterialModalBottomSheet<List<DateTime?>?>(
      expand: false,
      context: context,
      enableDrag: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<TrxHistoryCubit>()),
          BlocProvider.value(value: context.read<TrxHistoryBloc>()),
        ],
        child: _buildStatusTrxFilter(context, isElite),
      ),
    );
  }

  Future<void> _showDateTrxFilter(BuildContext context, bool isElite) {
    return showMaterialModalBottomSheet<List<DateTime?>?>(
      expand: false,
      context: context,
      enableDrag: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<TrxHistoryCubit>()),
          BlocProvider.value(value: context.read<TrxHistoryBloc>()),
        ],
        child: _buildDateTrxFilter(context, isElite),
      ),
    );
  }

  Widget _buildTrxTypeFilter(BuildContext context, bool isElite) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: isElite ? clrBackgroundBlack : clrWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<TrxHistoryCubit, TrxHistoryCubitState>(
              builder: (context, state) {
                return Flexible(
                  fit: FlexFit.loose,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 26,
                          ),
                          child: Text(
                            'Jenis Transaksi',
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 26,
                          ),
                          color: clrNeutralGrey999.withOpacity(0.08),
                          child: Column(
                            children: List.generate(
                              8,
                              (index) => FilterMethod(
                                  isElite: isElite,
                                  title: _filterTitle(index),
                                  methodId: index,
                                  selectedMethodId: state.trxTypeSelected,
                                  onChanged: (value) {
                                    context
                                        .read<TrxHistoryCubit>()
                                        .changeTrxType(index);

                                    context.pop();
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusTrxFilter(BuildContext context, bool isElite) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: isElite ? clrBackgroundBlack : clrWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<TrxHistoryCubit, TrxHistoryCubitState>(
              builder: (context, state) {
                return Flexible(
                  fit: FlexFit.loose,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 26,
                          ),
                          child: Text(
                            'Status Transaksi',
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 26,
                          ),
                          color: clrNeutralGrey999.withOpacity(0.08),
                          child: Column(
                            children: List.generate(
                              4,
                              (index) => FilterMethod(
                                  isElite: isElite,
                                  title: _filterStatusTitle(index),
                                  methodId: index,
                                  selectedMethodId: state.trxStatusSelected,
                                  onChanged: (value) {
                                    context
                                        .read<TrxHistoryCubit>()
                                        .changeTrxStatus(index);

                                    context.pop();
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTrxFilter(BuildContext context, bool isElite) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: isElite ? clrBackgroundBlack : clrWhite,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<TrxHistoryCubit, TrxHistoryCubitState>(
              builder: (context, state) {
                return Flexible(
                  fit: FlexFit.loose,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 26,
                          ),
                          child: Text(
                            'Tanggal Transaksi',
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 26,
                          ),
                          color: clrNeutralGrey999.withOpacity(0.08),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Column(
                                children: List.generate(
                                  5,
                                  (index) => FilterMethod(
                                      isElite: isElite,
                                      title: _filterDateTitle(index),
                                      methodId: index,
                                      selectedMethodId: state.trxDateSelected,
                                      onChanged: (value) {
                                        context
                                            .read<TrxHistoryCubit>()
                                            .changeTrxDate(index);
                                        if (index != 4) {
                                          context.pop();
                                        }
                                      }),
                                ),
                              ),
                              if (state.trxDateSelected == 4)
                                _buildCalender(context, isElite),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            BlocBuilder<TrxHistoryCubit, TrxHistoryCubitState>(
              builder: (context, state) {
                return state.trxDateSelected == 4
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              child: BlocBuilder<TrxHistoryCubit,
                                  TrxHistoryCubitState>(
                                builder: (context, state) {
                                  return MainButton(
                                    label: 'Terapkan Filter',
                                    onPressed: () async {
                                      final String? startDate = state.date?[0]
                                          .toDateStr('yyyy-MM-dd');
                                      final String? endDate =
                                          state.date?.length == 1
                                              ? startDate
                                              : state.date?[1]
                                                  .toDateStr('yyyy-MM-dd');

                                      DateTime startDatePeriod =
                                          DateTime.parse(startDate ?? '');
                                      DateTime endDatePeriod =
                                          DateTime.parse(endDate ?? '');

                                      // // Calculate the duration between the two dates
                                      Duration difference = endDatePeriod
                                          .difference(startDatePeriod);

                                      // Access the duration components
                                      int days = difference.inDays;

                                      appPrint(days.toString());

                                      if (days > 90) {
                                        DialogUtils.failure(
                                          context: context,
                                          barrierDismissible: true,
                                          firstDesc:
                                              'Periode Filter Yang Dapat Dipilih Maksimal 90 Hari',
                                          // secondDesc: '',
                                          btnText: 'Kembali',
                                          btnOnPressed: () {
                                            context.pop();
                                          },
                                        );
                                        return;
                                      }

                                      switch (state.trxDateSelected) {
                                        case 0:
                                          context.read<TrxHistoryBloc>().add(
                                                TrxHistoryGetEvent(
                                                  type: state.filterTrxType,
                                                  status: state.trxStatus,
                                                  period: null,
                                                  startDate: null,
                                                  endDate: null,
                                                  limit: 10,
                                                  isInitData: true,
                                                ),
                                              );
                                        case 1:
                                          context.read<TrxHistoryBloc>().add(
                                                TrxHistoryGetEvent(
                                                  type: state.filterTrxType,
                                                  status: state.trxStatus,
                                                  period: '7days',
                                                  limit: 10,
                                                  isInitData: true,
                                                ),
                                              );
                                        case 2:
                                          context.read<TrxHistoryBloc>().add(
                                                TrxHistoryGetEvent(
                                                  type: state.filterTrxType,
                                                  status: state.trxStatus,
                                                  period: '30days',
                                                  limit: 10,
                                                  isInitData: true,
                                                ),
                                              );
                                        case 3:
                                          context.read<TrxHistoryBloc>().add(
                                                TrxHistoryGetEvent(
                                                  type: state.filterTrxType,
                                                  status: state.trxStatus,
                                                  period: '90days',
                                                  limit: 10,
                                                  isInitData: true,
                                                ),
                                              );
                                        case 4:
                                          context.read<TrxHistoryBloc>().add(
                                                TrxHistoryGetEvent(
                                                  type: state.filterTrxType,
                                                  status: state.trxStatus,
                                                  startDate: state.date?[0]
                                                      .toDateStr('yyyy-MM-dd'),
                                                  endDate:
                                                      state.date?.length == 1
                                                          ? state.date![0]
                                                              .toDateStr(
                                                                  'yyyy-MM-dd')
                                                          : state.date?[1]
                                                              .toDateStr(
                                                                  'yyyy-MM-dd'),
                                                  limit: 10,
                                                  isInitData: true,
                                                ),
                                              );
                                        default:
                                          context.read<TrxHistoryBloc>().add(
                                                TrxHistoryGetEvent(
                                                  type: state.filterTrxType,
                                                  status: state.trxStatus,
                                                  period: null,
                                                  startDate: null,
                                                  endDate: null,
                                                  limit: 10,
                                                  isInitData: true,
                                                ),
                                              );
                                      }
                                      context
                                          .read<TrxHistoryCubit>()
                                          .removeTrxHistory();
                                      context.pop();
                                    },
                                  );
                                },
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: MainButton(
                                label: 'Reset',
                                bgColor:
                                    isElite ? clrBackgroundBlack : clrWhite,
                                border: BorderSide(
                                  width: 2,
                                  color: clrYellow,
                                ),
                                labelStyle: TextStyle(
                                  color: clrYellow,
                                ),
                                onPressed: () {
                                  context.read<TrxHistoryCubit>().resetFilter();
                                  context.read<TrxHistoryBloc>().add(
                                        const TrxHistoryGetEvent(
                                          type: null,
                                          status: null,
                                          period: null,
                                          startDate: null,
                                          endDate: null,
                                          limit: 10,
                                          isInitData: true,
                                        ),
                                      );
                                  context.pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  String _getDateValue(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText =
        (values.isNotEmpty ? values[0] : null).toString().toDateShortMonthStr();

    switch (datePickerType) {
      case CalendarDatePicker2Type.multi:
        valueText =
            values.map((e) => e.toString().toDateShortMonthStr()).join(' ');
        break;

      case CalendarDatePicker2Type.range:
        if (values.isNotEmpty) {
          final startDate = values[0].toString().toDateShortMonthStr();
          final endDate = values.length > 1
              ? values[1].toString().toDateShortMonthStr()
              : '';
          valueText = values.length > 1 ? '$startDate - $endDate' : startDate;
        } else {
          return '';
        }
        break;

      default:
        break;
    }

    return valueText;
  }

  Widget _buildCalender(BuildContext context, bool isElite) {
    List<String> weekdayLabels = [
      'MIN',
      'SEN',
      'SEL',
      'RAB',
      'KAM',
      'JUM',
      'SAB'
    ];

    CalendarDatePicker2Type? calenderDatePicker = CalendarDatePicker2Type.range;

    final config = CalendarDatePicker2Config(
      calendarType: calenderDatePicker,
      dayTextStyle: TextStyle(
        color: isElite ? clrWhite : clrBackgroundBlack,
      ),
      selectedDayTextStyle: TextStyle(
        color: isElite ? clrBackgroundBlack : clrBackgroundBlack,
      ),
      selectedDayHighlightColor: clrYellow,
      weekdayLabels: weekdayLabels,
      firstDayOfWeek: 1,
      yearTextStyle: TextStyle(
        color: clrWhite,
      ),
      selectedYearTextStyle: TextStyle(
        color: clrBackgroundBlack,
      ),
      controlsTextStyle: TextStyle(
        color: isElite ? clrWhite : clrBackgroundBlack,
        fontWeight: FontWeight.w600,
      ),
      lastMonthIcon: Icon(
        Icons.arrow_back_ios_rounded,
        size: 14,
        color: isElite ? clrWhite : clrBackgroundBlack,
      ),
      nextMonthIcon: Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: isElite ? clrWhite : clrBackgroundBlack,
      ),
    );
    var date = context.watch<TrxHistoryCubit>().state.date;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isElite ? clrBlack080 : clrWhite,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                width: 2,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(13),
                        bottomLeft: Radius.circular(13),
                      ),
                      color: isElite
                          ? clrGreyE5e.withOpacity(0.05)
                          : clrGreyE5e.withOpacity(0.25),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Mulai Dari',
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isElite
                                ? clrWhite.withOpacity(0.5)
                                : clrBackgroundBlack.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 2),
                        BlocBuilder<TrxHistoryCubit, TrxHistoryCubitState>(
                          bloc: context.read<TrxHistoryCubit>(),
                          builder: (context, state) {
                            return Text(
                              (state.date ?? []).length > 1
                                  ? _getDateValue(
                                      config.calendarType,
                                      (state.date ?? []).isEmpty
                                          ? [DateTime.now()]
                                          : state.date!,
                                    ).split('-')[0]
                                  : _getDateValue(
                                      config.calendarType,
                                      (state.date ?? []).isEmpty
                                          ? [DateTime.now()]
                                          : state.date!,
                                    ),
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: clrNeutralGrey999,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(13),
                        bottomRight: Radius.circular(13),
                      ),
                      color: clrNeutralGrey999.withOpacity(0.16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Sampai Dari',
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: isElite
                                ? clrWhite.withOpacity(0.5)
                                : clrBackgroundBlack.withOpacity(0.5),
                          ),
                        ),
                        const SizedBox(height: 2),
                        BlocBuilder<TrxHistoryCubit, TrxHistoryCubitState>(
                          bloc: context.read<TrxHistoryCubit>(),
                          builder: (context, state) {
                            return Text(
                              (state.date ?? []).length > 1
                                  ? _getDateValue(
                                      config.calendarType,
                                      (state.date ?? []).isEmpty
                                          ? [DateTime.now()]
                                          : state.date!,
                                    ).split('-')[1]
                                  : _getDateValue(
                                      config.calendarType,
                                      (state.date ?? []).isEmpty
                                          ? [DateTime.now()]
                                          : state.date!,
                                    ),
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: clrNeutralGrey999,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          CalendarDatePicker2(
            config: config,
            value: (date ?? []).isEmpty ? [DateTime.now()] : date!,
            onValueChanged: (dates) {
              switch (dates.length) {
                case 1:
                  calenderDatePicker = CalendarDatePicker2Type.single;
                // break;
                case 2:
                  calenderDatePicker = CalendarDatePicker2Type.range;
                // break;
                default:
                  calenderDatePicker = CalendarDatePicker2Type.range;
              }
              context.read<TrxHistoryCubit>().pickDate(dates);
            },
          ),

          // Container(
          //   padding: const EdgeInsets.symmetric(vertical: 18),
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     color: clrGreyE5e.withOpacity(0.25),
          //     borderRadius: BorderRadius.circular(30),
          //     border: Border.all(
          //       width: 2,
          //       color: clrNeutralGrey999.withOpacity(0.16),
          //     ),
          //   ),
          //   child: Center(
          //     child: BlocBuilder<TrxHistoryCubit, TrxHistoryCubitState>(
          //       bloc: context.read<TrxHistoryCubit>(),
          //       builder: (context, state) {
          //         return Text(
          //           _getDateValue(
          //             config.calendarType,
          //             (state.date ?? []).isEmpty
          //                 ? [DateTime.now()]
          //                 : state.date!,
          //           ),
          //           style: TextStyle(
          //             fontWeight: FontWeight.w500,
          //             color: clrNeutralGrey999,
          //           ),
          //         );
          //       },
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 16),
          // BlocBuilder<TrxHistoryCubit, TrxHistoryCubitState>(
          //   bloc: context.read<TrxHistoryCubit>(),
          //   builder: (_, state) {
          //     return SizedBox(
          //       width: double.infinity,
          //       child: MainButton(
          //         label: t.lblApply,
          //         onPressed: () {},
          //         // onPressed: (state.dateSubsElite ?? '').isNotEmpty ||
          //         //         backScreen != null
          //         //     ? () {
          //         //         context.pop(
          //         //             context.read<EliteHistoryCubit>().state.date);
          //         //       }
          //         //     : null,
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  String _filterTitle(int index) {
    switch (index) {
      case 0:
        return 'Semua Transaksi';
      case 1:
        return 'Jual Emas';
      case 2:
        return 'Beli Emas';
      case 3:
        return 'Redeem';
      case 4:
        return 'Laku Simpan';
      case 5:
        return 'Laku Tukar';
      case 6:
        return 'Transfer';
      case 7:
        return 'Elite';
      default:
        return 'Semua Transaksi';
    }
  }

  String _filterStatusTitle(int index) {
    switch (index) {
      case 0:
        return 'Semua Status';
      case 1:
        return 'Dalam Proses';
      case 2:
        return 'Berhasil';
      case 3:
        return 'Gagal';
      default:
        return 'Semua Transaksi';
    }
  }

  String _filterDateTitle(int index) {
    switch (index) {
      case 0:
        return 'Semua Tanggal';
      case 1:
        return '7 Hari Terakhir';
      case 2:
        return '30 Hari Terakhir';
      case 3:
        return '90 Hari Terakhir';
      case 4:
        return 'Pilih Tanggal Sendiri';
      default:
        return 'Semua Tanggal';
    }
  }

  String _dynamicDateTrx(String typeLabel) {
    switch (typeLabel.toLowerCase()) {
      case 'beli emas':
        return 'Pembelian';
      case 'jual emas':
        return 'Penjualan';
      case 'redeem voucher':
        return 'Redeem';
      case 'tarik fisik':
        return 'Pengajuan';
      case 'laku simpan':
        return 'Deposit';
      case 'laku tukar':
        return 'Penukaran';
      case 'transfer emas':
        return 'Transfer';
      case 'lakuemas elite':
        return 'Berlangganan';
      default:
        return '';
    }
  }
}

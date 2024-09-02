import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cores/extensions/currency_extension.dart';
import '../../../cores/extensions/date_extension.dart';
import '../../../features/elite/presentation/widgets/empty_widget.dart';
import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/constants/transaction_detail_type.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/modal_bottom_sheet/modal_bottom_sheet.dart';
import '../domain/entities/mutation_entity.dart';
import 'blocs/mutation/mutation_bloc.dart';
import 'cubits/filter_date/filter_date_cubit.dart';
import 'cubits/filter_history_tab/filter_history_tab_cubit.dart';

class CashWithdrawalHistoryScreen extends StatelessWidget {
  const CashWithdrawalHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<FilterHistoryTabCubit>()),
        BlocProvider(create: (context) => sl<FilterDateCubit>()),
        BlocProvider(
          create: (context) => sl<MutationBloc>()
            ..add(const MutationGetEvent(
              status: null,
              period: '7days',
            )),
        ),
      ],
      child: _Content(),
    );
  }
}

// ignore: must_be_immutable
class _Content extends StatelessWidget {
  _Content({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: Text(
              t.lblHistory,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                context.pop();
              },
            ),
          ),
          body: Column(
            children: [
              _filterTab(context, isElite: isElite),
              Expanded(
                child: BlocBuilder<MutationBloc, MutationState>(
                  builder: (context, state) {
                    if (state is MutationLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (state is MutationSuccessState) {
                      return (state.mutation.isEmpty)
                          ? const EmptyWidget(
                              desc: 'Riwayat tidak ditemukan',
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 32,
                              ),
                              itemCount: state.mutation.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return _historyItem(
                                  context,
                                  itemLength: state.mutation.length,
                                  index: index,
                                  mutationEntity: state.mutation[index],
                                  isElite: isElite,
                                );
                              },
                            );
                    }
                    return const SizedBox();
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _filterTab(BuildContext context, {required bool isElite}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Row(
            children: [
              Expanded(
                child:
                    BlocBuilder<FilterHistoryTabCubit, FilterHistoryTabState>(
                  builder: (context, state) {
                    return _tab(
                      context,
                      isElite: isElite,
                      title: '7 Hari',
                      isSelected:
                          state.enFilterPeriod == EnFilterPeriod.sevenDays,
                      onTap: () {
                        context
                            .read<FilterHistoryTabCubit>()
                            .changeFilter(EnFilterPeriod.sevenDays);
                        context.read<FilterDateCubit>().pickDate([]);
                        context.read<MutationBloc>().add(const MutationGetEvent(
                              status: null,
                              period: '7days',
                            ));
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child:
                    BlocBuilder<FilterHistoryTabCubit, FilterHistoryTabState>(
                  builder: (context, state) {
                    return _tab(
                      context,
                      isElite: isElite,
                      title: '30 Hari',
                      isSelected:
                          state.enFilterPeriod == EnFilterPeriod.thirtyDays,
                      onTap: () {
                        context
                            .read<FilterHistoryTabCubit>()
                            .changeFilter(EnFilterPeriod.thirtyDays);
                        context.read<FilterDateCubit>().pickDate([]);
                        context.read<MutationBloc>().add(const MutationGetEvent(
                              status: null,
                              period: '30days',
                            ));
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child:
                    BlocBuilder<FilterHistoryTabCubit, FilterHistoryTabState>(
                  builder: (context, state) {
                    return _tab(
                      context,
                      isElite: isElite,
                      title: '90 Hari',
                      isSelected:
                          state.enFilterPeriod == EnFilterPeriod.ninetyDays,
                      onTap: () {
                        context
                            .read<FilterHistoryTabCubit>()
                            .changeFilter(EnFilterPeriod.ninetyDays);
                        context.read<FilterDateCubit>().pickDate([]);
                        context.read<MutationBloc>().add(const MutationGetEvent(
                              status: null,
                              period: '90days',
                            ));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () async {
            context
                .read<FilterHistoryTabCubit>()
                .changeFilter(EnFilterPeriod.byDate);
            _showCalender(context, isElite).then((dates) {
              if ((dates ?? []).isNotEmpty) {
                var startDate = dates?[0].toDateStr('yyyy-MM-dd');
                var endDate = dates?.length == 2
                    ? dates![1].toDateStr('yyyy-MM-dd')
                    : startDate;
                context.read<FilterDateCubit>().pickDate(dates);
                context.read<MutationBloc>().add(MutationGetEvent(
                      status: null,
                      period: null,
                      startDate: startDate,
                      endDate: endDate,
                    ));
              }
            });
          },
          child: BlocBuilder<FilterHistoryTabCubit, FilterHistoryTabState>(
            builder: (context, state) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: state.enFilterPeriod == EnFilterPeriod.byDate
                      ? clrYellow
                      : clrNeutralGrey999.withOpacity(0.16),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    width: 2,
                    color: clrNeutralGrey999.withOpacity(0.16),
                  ),
                ),
                child: BlocBuilder<FilterDateCubit, FilterDateState>(
                  builder: (context, state) {
                    return ((state.date ?? []).isNotEmpty)
                        ? Center(
                            child: Text(
                              _getDateValue(
                                CalendarDatePicker2Type.range,
                                state.date ?? [DateTime.now()],
                              ),
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: clrBackgroundBlack,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(icCalender),
                              const SizedBox(width: 8),
                              Text(
                                'Filter Tanggal',
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: clrNeutralGrey999,
                                ),
                              ),
                            ],
                          );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _historyItem(
    BuildContext context, {
    required int itemLength,
    required int index,
    required MutationEntity? mutationEntity,
    required bool isElite,
  }) {
    return GestureDetector(
      onTap: () {
        if (mutationEntity?.type?.toLowerCase() == 'tarik tunai') {
          return context.goNamed(
            AppRoutes.paymentWaitingWithdraw,
            extra: {
              'eliteCubit': context.read<EliteCubit>(),
              'transactionDetailType': TransactionDetailType.withdrawal,
              'transactionCode': mutationEntity?.code,
            },
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            mutationEntity?.transactionDate.toDateLongMonthStr() ?? '-',
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isElite ? clrWhite : clrBackgroundBlack,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                mutationEntity?.type ?? '-',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 12,
                  color: isElite
                      ? clrWhite.withOpacity(0.75)
                      : clrBackgroundBlack.withOpacity(0.75),
                ),
              ),
              Text(
                '${mutationEntity?.mutationType?.toLowerCase() == 'debit' ? '+' : '-'} ${mutationEntity?.amount.toIdr()}',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 12,
                  color: mutationEntity?.mutationType?.toLowerCase() == 'debit'
                      ? clrGreen00A
                      : clrRed,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'No Transaksi ${mutationEntity?.code}',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color:
                      isElite ? clrWhite : clrBackgroundBlack.withOpacity(0.75),
                ),
              ),
              Text(
                'saldo Rp ${mutationEntity?.balance.toIdr() ?? '-'}',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color:
                      isElite ? clrWhite : clrBackgroundBlack.withOpacity(0.75),
                ),
              ),
            ],
          ),
          if (index != (itemLength - 1))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Divider(
                thickness: 1.5,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _tab(
    BuildContext context, {
    required bool isElite,
    required String title,
    bool isSelected = false,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? clrYellow : clrNeutralGrey999.withOpacity(0.16),
          borderRadius: BorderRadius.circular(50),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? clrBackgroundBlack
                : (isElite ? clrWhite : clrBackgroundBlack).withOpacity(0.75),
          ),
        ),
      ),
    );
  }

  Future<List<DateTime?>?> _showCalender(BuildContext context, bool isElite) {
    return showMaterialModalBottomSheet<List<DateTime?>?>(
      expand: false,
      context: context,
      enableDrag: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BlocProvider(
        create: (context) => sl<FilterDateCubit>(),
        child: Builder(builder: (context) {
          return _buildCalender(context, isElite);
        }),
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
        (values.isNotEmpty ? values[0] : null).toString().toDateLongMonthStr();

    switch (datePickerType) {
      case CalendarDatePicker2Type.multi:
        valueText =
            values.map((e) => e.toString().toDateLongMonthStr()).join(' ');
        break;

      case CalendarDatePicker2Type.range:
        if (values.isNotEmpty) {
          final startDate = values[0].toString().toDateLongMonthStr();
          final endDate = values.length > 1
              ? values[1].toString().toDateLongMonthStr()
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

  List<String> weekdayLabels = [
    'MIN',
    'SEN',
    'SEL',
    'RAB',
    'KAM',
    'JUM',
    'SAB'
  ];

  Widget _buildCalender(BuildContext context, bool isElite) {
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
      yearTextStyle: TextStyle(
        color: isElite ? clrWhite : clrBackgroundBlack,
        fontWeight: FontWeight.w600,
      ),
    );
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        color: isElite ? clrBlack080 : clrWhite,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<FilterDateCubit, FilterDateState>(
            builder: (context, state) {
              return CalendarDatePicker2(
                config: config,
                value: state.date ?? [DateTime.now()],
                onValueChanged: (dates) {
                  switch (dates.length) {
                    case 1:
                      calenderDatePicker = CalendarDatePicker2Type.single;
                      break;
                    case 2:
                      calenderDatePicker = CalendarDatePicker2Type.range;
                      break;
                    default:
                      calenderDatePicker = CalendarDatePicker2Type.range;
                  }

                  context.read<FilterDateCubit>().pickDate(dates);
                },
              );
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            width: double.infinity,
            decoration: BoxDecoration(
              color: clrGreyE5e.withOpacity(0.25),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                width: 2,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
            ),
            child: Center(
              child: BlocBuilder<FilterDateCubit, FilterDateState>(
                builder: (context, state) {
                  return Text(
                    // state.date.toString(),
                    _getDateValue(
                      config.calendarType,
                      state.date ?? [DateTime.now()],
                    ),
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: clrNeutralGrey999,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          BlocBuilder<FilterDateCubit, FilterDateState>(
            builder: (context, state) {
              return SizedBox(
                width: double.infinity,
                child: MainButton(
                  label: 'Terapkan',
                  onPressed: () {
                    final String? startDate =
                        state.date?[0].toDateStr('yyyy-MM-dd');
                    final String? endDate = state.date?.length == 1
                        ? startDate
                        : state.date?[1].toDateStr('yyyy-MM-dd');

                    DateTime startDatePeriod = DateTime.parse(startDate ?? '');
                    DateTime endDatePeriod = DateTime.parse(endDate ?? '');

                    // // Calculate the duration between the two dates
                    Duration difference =
                        endDatePeriod.difference(startDatePeriod);

                    // Access the duration components
                    int days = difference.inDays;

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

                    context.pop(context.read<FilterDateCubit>().state.date);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

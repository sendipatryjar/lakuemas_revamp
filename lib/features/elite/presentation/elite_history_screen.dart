import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../cores/extensions/date_extension.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/constants/transaction_detail_type.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/models/data_with_meta.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/widgets/main_dropdown.dart';
import '../../../cores/widgets/modal_bottom_sheet/src/bottom_sheets/material_bottom_sheet.dart';
import '../domain/entities/elite_history_entity.dart';
import '../domain/entities/elite_me_entity.dart';
import 'blocs/elite_history/elite_history_bloc.dart';
import 'cubits/elite_history/elite_history_cubit.dart';
import 'widgets/empty_widget.dart';
import 'widgets/referral_card_widget.dart';

class EliteHistoryScreen extends StatelessWidget {
  final String? backScreen;
  const EliteHistoryScreen({super.key, this.backScreen});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<EliteHistoryCubit>()),
        BlocProvider(
          create: (context) {
            if (backScreen == null) {
              return sl<EliteHistoryBloc>()
                ..add(
                  const GetEliteReferralsLoadEvent(
                    page: 1,
                  ),
                );
            } else {
              return sl<EliteHistoryBloc>()
                ..add(
                  const EliteHistoryGetEvent(
                    page: 1,
                    statuses: null,
                    period: '7days',
                  ),
                );
            }
          },
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<EliteHistoryBloc, EliteHistoryState>(
            listener: (context, state) {
              if (backScreen == null) {
                if (state is EliteHistoryLoadingState) {
                  context.read<EliteHistoryCubit>().updateLoadingTrue();
                }
                if (state is EliteHistorySuccessState) {
                  context.read<EliteHistoryCubit>().updateEliteHistory(
                        page: state.metaData?.page ?? 0,
                        listReferralEntity: state.listReferralEntity ?? [],
                        metaData: state.metaData,
                        isInitData: state.isInitData,
                      );
                }
                if (state is EliteHistoryFailureState) {
                  context.read<EliteHistoryCubit>().updateErrorTrue();
                }
              } else {
                if (state is EliteHistoryLoadingState) {
                  context.read<EliteHistoryCubit>().updateLoadingTrue();
                }
                if (state is EliteHistorySuccessState) {
                  context.read<EliteHistoryCubit>().updateEliteHistory(
                        page: state.metaData?.page ?? 0,
                        eliteHistoryEntity: state.eliteHistory ?? [],
                        metaData: state.metaData,
                        isInitData: state.isInitData,
                      );
                }
                if (state is EliteHistoryFailureState) {
                  context.read<EliteHistoryCubit>().updateErrorTrue();
                }
              }
            },
          )
        ],
        child: _Content(
          backScreen: backScreen,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class _Content extends StatelessWidget {
  final String? backScreen;

  _Content({
    Key? key,
    required this.backScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: clrBlack080,
          appBar: AppBar(
            backgroundColor: clrBackgroundBlack,
            centerTitle: true,
            title: Text(
              backScreen == null ? 'Daftar Referral Kamu' : t.lblHistory,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
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
                    'eliteCubit': context.read<EliteCubit>(),
                    'isFromReferral': backScreen == null ? true : false,
                  },
                );
              },
            ),
          ),
          body: Column(
            children: [
              _filterTab(context, isElite: true),
              backScreen == null
                  ? Expanded(
                      child: BlocBuilder<EliteHistoryCubit,
                          EliteHistoryCubitState>(
                        builder: (context, state) {
                          return NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              final currOffset = notification.metrics.pixels;
                              final maxOffset =
                                  notification.metrics.maxScrollExtent;
                              final eliteHistoryState =
                                  context.read<EliteHistoryCubit>().state;
                              final bool isLastPage =
                                  eliteHistoryState.meta?.page ==
                                      eliteHistoryState.meta?.totalPage;
                              if ((isLastPage == false) &&
                                  (notification.metrics.axis ==
                                      Axis.vertical) &&
                                  (currOffset >= (maxOffset - 200)) &&
                                  (eliteHistoryState.isLoading == false)) {
                                context
                                    .read<EliteHistoryCubit>()
                                    .updateLoadingTrue();
                                switch (state.enFilterPeriod) {
                                  case EnFilterPeriod.sevenDays:
                                    context.read<EliteHistoryBloc>().add(
                                          EliteHistoryGetEvent(
                                            limit: 10,
                                            page:
                                                (eliteHistoryState.meta?.page ??
                                                        0) +
                                                    1,
                                            period: '7days',
                                          ),
                                        );
                                  case EnFilterPeriod.thirtyDays:
                                    context.read<EliteHistoryBloc>().add(
                                          EliteHistoryGetEvent(
                                            limit: 10,
                                            page:
                                                (eliteHistoryState.meta?.page ??
                                                        0) +
                                                    1,
                                            period: '30days',
                                          ),
                                        );
                                  case EnFilterPeriod.ninetyDays:
                                    context.read<EliteHistoryBloc>().add(
                                          EliteHistoryGetEvent(
                                            limit: 10,
                                            page:
                                                (eliteHistoryState.meta?.page ??
                                                        0) +
                                                    1,
                                            period: '90days',
                                          ),
                                        );
                                  case EnFilterPeriod.byDate:
                                    context.read<EliteHistoryBloc>().add(
                                          EliteHistoryGetEvent(
                                            limit: 10,
                                            page:
                                                (eliteHistoryState.meta?.page ??
                                                        0) +
                                                    1,
                                            period: null,
                                            startDate: state.date?[0]
                                                .toDateStr('yyyy-MM-dd'),
                                            endDate: state.date?.length == 1
                                                ? state.date![0]
                                                    .toDateStr('yyyy-MM-dd')
                                                : state.date?[1]
                                                    .toDateStr('yyyy-MM-dd'),
                                          ),
                                        );
                                  default:
                                }
                              }
                              return false;
                            },
                            child: BlocBuilder<EliteHistoryCubit,
                                EliteHistoryCubitState>(
                              buildWhen: (previous, current) =>
                                  previous.listReferralEntity !=
                                      current.listReferralEntity ||
                                  previous.isError != current.isError ||
                                  previous.isLoading != current.isLoading ||
                                  previous.meta != current.meta,
                              builder: (context, state) {
                                return _referralList(
                                  context,
                                  listReferral: state.listReferralEntity,
                                  metaData: state.meta,
                                  isLoading: state.isLoading,
                                  isError: state.isError,
                                  isElite: true,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    )
                  : Expanded(
                      child: BlocBuilder<EliteHistoryCubit,
                          EliteHistoryCubitState>(
                        builder: (context, state) {
                          return NotificationListener<ScrollNotification>(
                            onNotification: (notification) {
                              final currOffset = notification.metrics.pixels;
                              final maxOffset =
                                  notification.metrics.maxScrollExtent;
                              final eliteHistoryState =
                                  context.read<EliteHistoryCubit>().state;
                              final bool isLastPage =
                                  eliteHistoryState.meta?.page ==
                                      eliteHistoryState.meta?.totalPage;
                              if ((isLastPage == false) &&
                                  (notification.metrics.axis ==
                                      Axis.vertical) &&
                                  (currOffset >= (maxOffset - 200)) &&
                                  (eliteHistoryState.isLoading == false)) {
                                context
                                    .read<EliteHistoryCubit>()
                                    .updateLoadingTrue();
                                switch (state.enFilterPeriod) {
                                  case EnFilterPeriod.sevenDays:
                                    context.read<EliteHistoryBloc>().add(
                                          EliteHistoryGetEvent(
                                            limit: 10,
                                            page:
                                                (eliteHistoryState.meta?.page ??
                                                        0) +
                                                    1,
                                            period: '7days',
                                          ),
                                        );
                                  case EnFilterPeriod.thirtyDays:
                                    context.read<EliteHistoryBloc>().add(
                                          EliteHistoryGetEvent(
                                            limit: 10,
                                            page:
                                                (eliteHistoryState.meta?.page ??
                                                        0) +
                                                    1,
                                            period: '30days',
                                          ),
                                        );
                                  case EnFilterPeriod.ninetyDays:
                                    context.read<EliteHistoryBloc>().add(
                                          EliteHistoryGetEvent(
                                            limit: 10,
                                            page:
                                                (eliteHistoryState.meta?.page ??
                                                        0) +
                                                    1,
                                            period: '90days',
                                          ),
                                        );
                                  case EnFilterPeriod.byDate:
                                    context.read<EliteHistoryBloc>().add(
                                          EliteHistoryGetEvent(
                                            limit: 10,
                                            page:
                                                (eliteHistoryState.meta?.page ??
                                                        0) +
                                                    1,
                                            period: null,
                                            startDate: state.date?[0]
                                                .toDateStr('yyyy-MM-dd'),
                                            endDate: state.date?.length == 1
                                                ? state.date![0]
                                                    .toDateStr('yyyy-MM-dd')
                                                : state.date?[1]
                                                    .toDateStr('yyyy-MM-dd'),
                                          ),
                                        );
                                  default:
                                }
                              }
                              return false;
                            },
                            child: BlocBuilder<EliteHistoryCubit,
                                EliteHistoryCubitState>(
                              buildWhen: (previous, current) =>
                                  previous.eliteHistoryEntity !=
                                      current.eliteHistoryEntity ||
                                  previous.isError != current.isError ||
                                  previous.isLoading != current.isLoading ||
                                  previous.meta != current.meta,
                              builder: (context, state) {
                                return _eliteHistory(
                                  context,
                                  eliteHistoryEntity: state.eliteHistoryEntity,
                                  metaData: state.meta,
                                  isLoading: state.isLoading,
                                  isError: state.isError,
                                  isElite: true,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    )
            ],
          ),
        );
      },
    );
  }

  Widget _historyItem(
    BuildContext context, {
    required int itemLength,
    required int index,
    required EliteHistoryEntity? eliteHistoryEntity,
    required bool isElite,
  }) {
    return GestureDetector(
      onTap: () {
        context.goNamed(
          AppRoutes.paymentWaiting,
          extra: {
            'eliteCubit': context.read<EliteCubit>(),
            'transactionDetailType': TransactionDetailType.elite,
            'transactionCode': eliteHistoryEntity?.code,
            'backScreen': AppRoutes.eliteHistory,
          },
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Paket ${eliteHistoryEntity?.packageMonth.toString() ?? '-'} Bulan',
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
                eliteHistoryEntity?.createdAt.toDateLongMonthStr() ?? '-',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: isElite
                      ? clrWhite.withOpacity(0.75)
                      : clrBackgroundBlack.withOpacity(0.75),
                ),
              ),
              Text(
                '${eliteHistoryEntity?.nominal}',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 12,
                  color: clrWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'No Transaksi ${eliteHistoryEntity?.code}',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: isElite
                      ? clrWhite.withOpacity(0.75)
                      : clrBackgroundBlack.withOpacity(0.75),
                ),
              ),
              Text(
                eliteHistoryEntity?.paymentMethod ?? '-',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
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

  Widget _eliteHistory(
    BuildContext context, {
    required List<EliteHistoryEntity> eliteHistoryEntity,
    required MetaDataApi? metaData,
    required bool isLoading,
    required bool isError,
    required bool isElite,
  }) {
    if (isError) {
      return Center(
        child: _errorDialog(context),
      );
    }

    if (isLoading && eliteHistoryEntity.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (eliteHistoryEntity.isEmpty) {
      return const Center(
        child: EmptyWidget(
          desc: 'Oopss, data kosong',
        ),
      );
    }
    final bool isLastPage = metaData?.page == metaData?.totalPage;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 32,
      ),
      itemCount: eliteHistoryEntity.length + (isLastPage ? 0 : 1),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == eliteHistoryEntity.length) {
          if (isError) {
            return Center(
              child: _errorDialog(context),
            );
          }
          return _loadingWidget(context, isElite);
        }
        return _historyItem(
          context,
          itemLength: eliteHistoryEntity.length,
          index: index,
          eliteHistoryEntity: eliteHistoryEntity[index],
          isElite: true,
        );
      },
    );
  }

  Widget _referralList(
    BuildContext context, {
    required List<ListReferralEntity> listReferral,
    required MetaDataApi? metaData,
    required bool isLoading,
    required bool isError,
    required bool isElite,
  }) {
    if (isError) {
      return Center(
        child: Text(
          'Terjadi kesalahan, silakan coba lagi.',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(color: isElite ? clrWhite : clrBackgroundBlack),
        ),
      );
    }

    if (isLoading && listReferral.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    if (listReferral.isEmpty) {
      return const Center(
        child: EmptyWidget(
          desc: 'Oopss, kamu belum memiliki referral',
        ),
      );
    }
    final bool isLastPage = metaData?.page == metaData?.totalPage;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 32,
      ),
      itemCount: listReferral.length + (isLastPage ? 0 : 1),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == listReferral.length) {
          if (isError) {
            return Center(
              child: _errorDialog(context),
            );
          }
          return _loadingWidget(context, isElite);
        }

        DateTime eliteReg = DateTime.parse(listReferral[index].joinDate ?? '-');
        DateTime eliteExp =
            DateTime.parse(listReferral[index].validUntil ?? '-');

        bool isExpired = eliteReg.isAfter(eliteExp);

        return ReferralCardWidget(
          name: listReferral[index].name ?? '-',
          eliteRegDate: listReferral[index].joinDate.toDateShortMonthStr(),
          eliteExpDate: listReferral[index].validUntil.toDateShortMonthStr(),
          isExpired: isExpired,
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
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Memuat History',
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color:
                  (isElite ? clrWhite : clrBackgroundBlack).withOpacity(0.75),
            ),
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
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Icon(Icons.refresh)
        ],
      ),
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
                child: BlocBuilder<EliteHistoryCubit, EliteHistoryCubitState>(
                  builder: (context, state) {
                    return _tab(
                      context,
                      isElite: isElite,
                      title: '7 Hari',
                      isSelected:
                          state.enFilterPeriod == EnFilterPeriod.sevenDays,
                      onTap: () {
                        if (backScreen == null) {
                          context
                              .read<EliteHistoryCubit>()
                              .changeFilter(EnFilterPeriod.sevenDays);

                          context.read<EliteHistoryCubit>().pickDate([]);
                          context.read<EliteHistoryBloc>().add(
                                const GetEliteReferralsLoadEvent(
                                  page: 1,
                                  isInitData: true,
                                ),
                              );
                        } else {
                          context
                              .read<EliteHistoryCubit>()
                              .changeFilter(EnFilterPeriod.sevenDays);
                          context.read<EliteHistoryCubit>().pickDate([]);
                          context.read<EliteHistoryBloc>().add(
                                const EliteHistoryGetEvent(
                                  statuses: null,
                                  period: '7days',
                                  page: 1,
                                  isInitData: true,
                                ),
                              );
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: BlocBuilder<EliteHistoryCubit, EliteHistoryCubitState>(
                  builder: (context, state) {
                    return _tab(
                      context,
                      isElite: isElite,
                      title: '30 Hari',
                      isSelected:
                          state.enFilterPeriod == EnFilterPeriod.thirtyDays,
                      onTap: () {
                        if (backScreen == null) {
                          context
                              .read<EliteHistoryCubit>()
                              .changeFilter(EnFilterPeriod.thirtyDays);
                          context.read<EliteHistoryCubit>().pickDate([]);
                          context.read<EliteHistoryBloc>().add(
                                const GetEliteReferralsLoadEvent(
                                  page: 1,
                                  isInitData: true,
                                ),
                              );
                        } else {
                          context
                              .read<EliteHistoryCubit>()
                              .changeFilter(EnFilterPeriod.thirtyDays);
                          context.read<EliteHistoryCubit>().pickDate([]);
                          context.read<EliteHistoryBloc>().add(
                                const EliteHistoryGetEvent(
                                  statuses: null,
                                  period: '30days',
                                  page: 1,
                                  isInitData: true,
                                ),
                              );
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: BlocBuilder<EliteHistoryCubit, EliteHistoryCubitState>(
                  builder: (context, state) {
                    return _tab(
                      context,
                      isElite: isElite,
                      title: '90 Hari',
                      isSelected:
                          state.enFilterPeriod == EnFilterPeriod.ninetyDays,
                      onTap: () {
                        if (backScreen == null) {
                          context
                              .read<EliteHistoryCubit>()
                              .changeFilter(EnFilterPeriod.ninetyDays);
                          context.read<EliteHistoryCubit>().pickDate([]);
                          context.read<EliteHistoryBloc>().add(
                                const GetEliteReferralsLoadEvent(
                                  page: 1,
                                  isInitData: true,
                                ),
                              );
                        } else {
                          context
                              .read<EliteHistoryCubit>()
                              .changeFilter(EnFilterPeriod.ninetyDays);
                          context.read<EliteHistoryCubit>().pickDate([]);
                          context.read<EliteHistoryBloc>().add(
                                const EliteHistoryGetEvent(
                                  statuses: null,
                                  period: '90days',
                                  page: 1,
                                  isInitData: true,
                                ),
                              );
                        }
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
                .read<EliteHistoryCubit>()
                .changeFilter(EnFilterPeriod.byDate);
            _showCalender(context, isElite).then((dates) {
              if ((dates ?? []).isNotEmpty) {
                if (backScreen == null) {
                  if ((context.read<EliteHistoryCubit>().state.dateSubsElite ??
                          '')
                      .isNotEmpty) {
                    if (context
                            .read<EliteHistoryCubit>()
                            .state
                            .dateSubsElite
                            ?.toLowerCase() ==
                        'tanggal register elite') {
                      context.read<EliteHistoryCubit>().pickDate(dates);
                      context
                          .read<EliteHistoryBloc>()
                          .add(GetEliteReferralsLoadEvent(
                            startDate: dates?[0].toDateStr('yyyy-MM-dd'),
                            endDate: dates?.length == 1
                                ? dates![0].toDateStr('yyyy-MM-dd')
                                : dates?[1].toDateStr('yyyy-MM-dd'),
                            isInitData: true,
                          ));
                      return;
                    }
                    if (context
                            .read<EliteHistoryCubit>()
                            .state
                            .dateSubsElite
                            ?.toLowerCase() ==
                        'tanggal berakhir elite') {
                      context
                          .read<EliteHistoryBloc>()
                          .add(GetEliteReferralsLoadEvent(
                            startValidDate: dates?[0].toDateStr('yyyy-MM-dd'),
                            endValidDate: dates?.length == 1
                                ? dates![0].toDateStr('yyyy-MM-dd')
                                : dates?[1].toDateStr('yyyy-MM-dd'),
                            isInitData: true,
                          ));
                      return;
                    }
                  }
                } else {
                  context.read<EliteHistoryCubit>().pickDate(dates);
                  context.read<EliteHistoryBloc>().add(EliteHistoryGetEvent(
                        statuses: null,
                        period: null,
                        startDate: dates?[0].toDateStr('yyyy-MM-dd'),
                        endDate: dates?.length == 1
                            ? dates![0].toDateStr('yyyy-MM-dd')
                            : dates?[1].toDateStr('yyyy-MM-dd'),
                        isInitData: true,
                      ));
                }
              }
            });
          },
          child: BlocBuilder<EliteHistoryCubit, EliteHistoryCubitState>(
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
                child: BlocBuilder<EliteHistoryCubit, EliteHistoryCubitState>(
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
        builder: (_) => _buildCalender(context, isElite));
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

  List<String> refListDate = [
    'Tanggal Register Elite',
    'Tanggal Berakhir Elite',
  ];

  Widget _buildCalender(BuildContext context, bool isElite) {
    final t = AppLocalizations.of(context)!;

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
    var date = context.watch<EliteHistoryCubit>().state.date;

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
          if (backScreen == null)
            MainDropDown<String>(
              hintText: '${t.lblSelect} ${t.lblExtendStatus}',
              items: refListDate.toList(),
              itemName: (val) => val,
              value: context.read<EliteHistoryCubit>().state.dateSubsElite,
              onChange: (value) {
                context.read<EliteHistoryCubit>().changeDateSubsElite(value);
              },
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
              context.read<EliteHistoryCubit>().pickDate(dates);
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
              child: BlocBuilder<EliteHistoryCubit, EliteHistoryCubitState>(
                bloc: context.read<EliteHistoryCubit>(),
                builder: (context, state) {
                  return Text(
                    _getDateValue(
                      config.calendarType,
                      (state.date ?? []).isEmpty
                          ? [DateTime.now()]
                          : state.date!,
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
          BlocBuilder<EliteHistoryCubit, EliteHistoryCubitState>(
            bloc: context.read<EliteHistoryCubit>(),
            builder: (_, state) {
              return SizedBox(
                width: double.infinity,
                child: MainButton(
                  label: t.lblApply,
                  onPressed: (state.dateSubsElite ?? '').isNotEmpty ||
                          backScreen != null
                      ? () {
                          final String? startDate =
                              state.date?[0].toDateStr('yyyy-MM-dd');
                          final String? endDate = state.date?.length == 1
                              ? startDate
                              : state.date?[1].toDateStr('yyyy-MM-dd');

                          DateTime startDatePeriod =
                              DateTime.parse(startDate ?? '');
                          DateTime endDatePeriod =
                              DateTime.parse(endDate ?? '');

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

                          context.pop(
                              context.read<EliteHistoryCubit>().state.date);
                        }
                      : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

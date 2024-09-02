import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/errors/app_failure.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/routes/go_router_observer.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/app_utils.dart';
import '../../../cores/utils/dialog_utils.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/errors/server_error_screen.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';
import '../../beranda/presentation/blocs/balance/balance_bloc.dart';
import '../domain/entities/transaction_entity.dart';
import 'blocs/lakusave/lakusave_bloc.dart';
import 'blocs/lakusave_cancel/lakusave_cancel_bloc.dart';
import 'blocs/lakusave_update_extend/lakusave_update_extend_bloc.dart';
import 'blocs/master_data/master_data_lakusave_bloc.dart';
import 'cubits/lakusave_update_extend/lakusave_update_extend_cubit.dart';
import 'widgets/laku_save_empty_widget.dart';
import 'widgets/laku_save_item_widget.dart';

class LakuSaveScreen extends StatelessWidget {
  const LakuSaveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<LakusaveBloc>()..add(const LakusaveGetTransactionsEvent()),
        ),
        BlocProvider(
          create: (context) => sl<LakusaveCancelBloc>(),
        ),
        BlocProvider(
          create: (context) =>
              sl<MasterDataLakusaveBloc>()..add(MasterDataLakusaveGetEvent()),
        ),
        BlocProvider(
          create: (context) => sl<LakusaveUpdateExtendCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<LakusaveUpdateExtendBloc>(),
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<LakusaveCancelBloc, LakusaveCancelState>(
            listener: (context, state) {
              if (state is LakusaveCancelLoadingState) {
                EasyLoading.show();
              }
              if (state is LakusaveCancelSuccessState) {
                context.read<HelperDataCubit>().resetDataAfterTrx();
                EasyLoading.dismiss();
                context
                    .read<LakusaveBloc>()
                    .add(const LakusaveGetTransactionsEvent());
                DialogUtils.success(
                  context: context,
                  firstDesc: 'Pengajuan Laku Simpan berhasil dibatalkan!',
                  btnText: t.lblClose,
                  btnOnPressed: () {
                    context.pop();
                  },
                );
              }
              if (state is LakusaveCancelFailureState) {
                EasyLoading.showError(
                  errorMessage(state.appFailure) ?? t.lblSomethingWrong,
                  dismissOnTap: true,
                );
              }
            },
          ),
          BlocListener<LakusaveUpdateExtendBloc, LakusaveUpdateExtendState>(
            listener: (context, state) {
              if (state is LakusaveUpdateExtendLoadingState) {
                EasyLoading.show();
              }
              if (state is LakusaveUpdateExtendSuccessState) {
                EasyLoading.dismiss();
                context
                    .read<LakusaveBloc>()
                    .add(const LakusaveGetTransactionsEvent());
                DialogUtils.success(
                  context: context,
                  firstDesc:
                      'Status perpanjangan simpanan emas kamu berhasil diubah!',
                  btnText: t.lblClose,
                  btnOnPressed: () {
                    context.pop();
                  },
                );
              }
              if (state is LakusaveUpdateExtendFailureState) {
                EasyLoading.showError(
                  errorMessage(state.appFailure) ?? t.lblSomethingWrong,
                  dismissOnTap: true,
                );
              }
            },
          ),
          BlocListener<MasterDataLakusaveBloc, MasterDataLakusaveState>(
            listener: (context, state) {},
          ),
        ],
        child: const _Content(),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content({
    Key? key,
  }) : super(key: key);

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  @override
  void initState() {
    super.initState();

    onLakuSaveSuccess = () {
      context.read<LakusaveBloc>().add(const LakusaveGetTransactionsEvent());
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return BlocBuilder<LakusaveBloc, LakusaveState>(
          builder: (context, state) {
            if (state is LakusaveFailureState) {
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
                      context
                          .read<LakusaveBloc>()
                          .add(const LakusaveGetTransactionsEvent());
                    },
                  ),
                );
              }
            }
            return BlocBuilder<LakusaveCancelBloc, LakusaveCancelState>(
              builder: (context, state) {
                if (state is LakusaveCancelFailureState) {
                  if (state.appFailure is ServerFailure) {
                    return Scaffold(
                      backgroundColor: isElite ? clrBlack080 : null,
                      appBar: AppBar(
                        backgroundColor: clrBlack101,
                        title: Text(
                          "Error",
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                        ),
                        centerTitle: true,
                        leading: MainBackButton(
                          onPressed: () {
                            context
                                .read<LakusaveCancelBloc>()
                                .add(LakusaveCancelInitEvent());
                          },
                        ),
                      ),
                      body: ServerErrorScreen(
                        onTryAgainPressed: () {
                          context
                              .read<LakusaveCancelBloc>()
                              .add(LakusaveCancelInitEvent());
                        },
                      ),
                    );
                  }
                }
                return DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    backgroundColor: isElite ? clrBlack080 : null,
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: clrBlack101,
                      centerTitle: true,
                      title: Text(
                        t.lblLakuSave,
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
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
                      actions: [
                        GestureDetector(
                          onTap: () {
                            context.goNamed(AppRoutes.aboutLakuSave, extra: {
                              'berandaBalancesBloc':
                                  context.read<BerandaBalancesBloc>(),
                            });
                          },
                          child: Container(
                            width: 24,
                            height: 24,
                            margin: const EdgeInsets.only(right: 20),
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(icInfoWhite),
                                // fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    bottomNavigationBar: Padding(
                      padding: const EdgeInsets.all(20),
                      child: MainButton(
                        label: t.lblAddGoldSaving,
                        onPressed: () {
                          context.goNamed(
                            AppRoutes.lakuSaveDeposit,
                            extra: {
                              'isElite': isElite.toString(),
                              'berandaBalancesBloc':
                                  context.read<BerandaBalancesBloc>(),
                              'masterDataLakusaveBloc':
                                  context.read<MasterDataLakusaveBloc>(),
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
                          child: BlocBuilder<LakusaveBloc, LakusaveState>(
                            builder: (context, state) {
                              if (state is LakusaveLoadingState) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (state is LakusaveSuccessState) {
                                var savedDeposit = state.data
                                    .where((element) =>
                                        element.status == 1 ||
                                        element.status == 5)
                                    .toList();
                                var waitingApprovedDeposit = state.data
                                    .where((element) =>
                                        element.status == 0 ||
                                        element.status == 3)
                                    .toList();
                                return TabBarView(
                                  // controller: _tabController,
                                  children: [
                                    _allTab(isElite, state.data),
                                    _savedTab(isElite, savedDeposit),
                                    _waitingApprovedTab(
                                        isElite, waitingApprovedDeposit),
                                  ],
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _waitingApprovedTab(bool isElite, List<TransactionEntity> items) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<LakusaveBloc>().add(const LakusaveGetTransactionsEvent());
        context
            .read<MasterDataLakusaveBloc>()
            .add(MasterDataLakusaveGetEvent());
      },
      child: items.isNotEmpty
          ? SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      LakuSaveItemWidget(
                        isElite: isElite,
                        items: items,
                      ),
                    ]),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LakuSaveEmptyWidget(
                  isElite: isElite,
                ),
              ],
            ),
    );
  }

  Widget _savedTab(bool isElite, List<TransactionEntity> items) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<LakusaveBloc>().add(const LakusaveGetTransactionsEvent());
        context
            .read<MasterDataLakusaveBloc>()
            .add(MasterDataLakusaveGetEvent());
      },
      child: items.isNotEmpty
          ? SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  const SizedBox(height: 20),
                  LakuSaveItemWidget(
                    isElite: isElite,
                    items: items,
                  ),
                ]),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LakuSaveEmptyWidget(
                  isElite: isElite,
                ),
              ],
            ),
    );
  }

  Widget _allTab(bool isElite, List<TransactionEntity> items) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<LakusaveBloc>().add(const LakusaveGetTransactionsEvent());
        context
            .read<MasterDataLakusaveBloc>()
            .add(MasterDataLakusaveGetEvent());
      },
      child: items.isNotEmpty
          ? SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  const SizedBox(height: 20),
                  LakuSaveItemWidget(
                    isElite: isElite,
                    items: items,
                  ),
                ]),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LakuSaveEmptyWidget(
                  isElite: isElite,
                ),
              ],
            ),
    );
  }

  Widget _tabBar(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      color: clrBlack101,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 32),
            child: Text(
              t.lblMeGoldDeposit,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: clrWhite,
              ),
            ),
          ),
          TabBar(
            indicatorWeight: 3,
            isScrollable: true,
            indicatorColor: clrYellow,
            labelColor: clrWhite,
            unselectedLabelColor: clrWhite.withOpacity(0.50),
            indicatorSize: TabBarIndicatorSize.tab,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: t.lblAll),
              Tab(text: t.lblStored),
              Tab(text: t.lblWaitingApprove),
            ],
          ),
        ],
      ),
    );
  }
}

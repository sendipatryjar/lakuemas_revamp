import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import 'blocs/get_portofolio/get_portofolio_bloc.dart';
import 'blocs/trx_history/trx_history_bloc.dart';
import 'cubits/trx_history/trx_history_cubit.dart';
import 'widgets/portofolio_content.dart';
import 'widgets/trx_content.dart';

class PortofolioScreen extends StatelessWidget {
  final bool? isFromTrx;
  const PortofolioScreen({
    super.key,
    this.isFromTrx = false,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<GetPortofolioBloc>()
            ..add(GetPortofolioLoadEvent(
              helperDataCubit: context.read<HelperDataCubit>(),
            )),
        ),
        BlocProvider(
          create: (context) => sl<TrxHistoryBloc>()
            ..add(const TrxHistoryGetEvent(
              page: 1,
            )),
        ),
        BlocProvider(create: (context) => sl<TrxHistoryCubit>()),
      ],
      child: BlocListener<TrxHistoryBloc, TrxHistoryState>(
        listener: (context, state) {
          if (state is TrxHistoryLoadingState) {
            context.read<TrxHistoryCubit>().updateLoadingTrue();
          }
          if (state is TrxHistorySuccessState) {
            context.read<TrxHistoryCubit>().updateTrxHistory(
                  page: state.metaData?.page ?? 0,
                  trxHistory: state.trxHistory,
                  metaData: state.metaData,
                  isInitData: state.isInitData,
                );
          }
          if (state is TrxHistoryFailureState) {
            context.read<TrxHistoryCubit>().updateErrorTrue();
          }
        },
        child: _Content(
          isFromTrx: isFromTrx,
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final bool? isFromTrx;

  const _Content({
    Key? key,
    this.isFromTrx = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return DefaultTabController(
          initialIndex: isFromTrx == true ? 1 : 0,
          length: 2,
          child: Scaffold(
            backgroundColor: isElite ? clrBackgroundBlack : null,
            appBar: AppBar(
              backgroundColor: clrBackgroundBlack,
              centerTitle: true,
              elevation: 0,
              title: Text(
                'Portofolio',
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
            body: Column(
              children: [
                _tabBar(context, isElite: isElite),
                Expanded(
                  child: TabBarView(
                    children: [
                      PortofolioContent(isElite: isElite),
                      TrxContent(isElite: isElite),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _tabBar(BuildContext context, {bool isElite = false}) {
    // final t = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      color: isElite ? clrBackgroundBlack : clrBackgroundBlack,
      child: TabBar(
        indicatorWeight: 3,
        indicatorColor: clrYellow,
        labelColor: isElite ? clrWhite : clrWhite,
        unselectedLabelColor:
            isElite ? clrWhite.withOpacity(0.50) : clrWhite.withOpacity(0.50),
        indicatorSize: TabBarIndicatorSize.tab,
        tabs: const [
          Tab(text: 'Portofolio'),
          Tab(text: 'Transaksi'),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import 'blocs/gold_details_balances/gold_details_balances_bloc.dart';
import 'blocs/gold_income/gold_income_bloc.dart';
import 'cubits/gold_details_tab/gold_details_tab_cubit.dart';
import 'widgets/gold_details_balance_widget.dart';
import 'widgets/gold_details_tab.dart';

class GoldDetailsScreen extends StatelessWidget {
  const GoldDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<GoldDetailsTabCubit>()),
        BlocProvider(
          create: (context) =>
              sl<GoldDetailsBalancesBloc>()..add(GoldDetailsBalancesGetEvent()),
        ),
        BlocProvider(
          create: (context) => sl<GoldIncomeBloc>()..add(GoldIncomeGetEvent()),
        ),
      ],
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          body: Column(
            children: [
              GoldDetailsBalanceWidget(isElite: isElite),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        GoldDetailsTab(isElite: isElite),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import 'cubits/elite_bonuses_tab/elite_bonuses_tab_cubit.dart';
import 'reguler_bonuses_screen.dart';
import 'widgets/elite_bonuses_tab.dart';
import 'widgets/elite_bonuses_top_widget.dart';

class EliteBonusesScreen extends StatelessWidget {
  const EliteBonusesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<EliteBonusesTabCubit>())
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
    return PopScope(
      canPop: false,
      onPopInvoked: (val)  {
        context.goNamed(AppRoutes.beranda);
      },
      child: BlocBuilder<EliteCubit, bool>(
        builder: (context, isElite) {
          return isElite
              ? Scaffold(
                  backgroundColor: isElite ? clrBlack080 : null,
                  body: Column(
                    children: [
                      EliteBonusesTopWidget(isElite: isElite),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            margin: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                EliteBonusesTab(isElite: isElite),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              : const RegulerBonusesScreen();
        },
      ),
    );
  }
}

class IsRegulerScreen extends StatelessWidget {
  const IsRegulerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Is Not Elite'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/widgets/main_button.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import 'widgets/elite_bonuses_top_widget.dart';

class RegulerBonusesScreen extends StatelessWidget {
  const RegulerBonusesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Content();
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
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: MainButton(
              label: 'Daftar Lakuemas Elite',
              onPressed: () {
                context.goNamed(
                  AppRoutes.elite,
                  extra: {'isElite': isElite.toString()},
                );
              },
            ),
          ),
          body: Column(
            children: [
              EliteBonusesTopWidget(isElite: isElite),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          width: 200,
                          height: 160,
                          margin: const EdgeInsets.only(top: 20),
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(imgPeopleHesitant),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Sepertinya kamu belum jadi member elite...\nYuk daftar Lakuemas Elite untuk mendapatkan beragam bonus yang menarik! ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: clrBackgroundBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import 'widgets/bonuses_history_top_widget.dart';

class EliteBonusHistoryScreen extends StatelessWidget {
  const EliteBonusHistoryScreen({super.key});

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
          body: Column(
            children: [
              BonusesHistoryTopWidget(isElite: isElite),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _listHistoryBonuses(
                          isElite: isElite,
                          itemLength: 17,
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

  Widget _listHistoryBonuses({bool isElite = false, int itemLength = 0}) {
    return Column(
      children: List.generate(
        itemLength,
        (index) => Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Transaksi Beli Emas',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                    ),
                    Text(
                      '01-01-2024',
                      style: TextStyle(
                        fontSize: 12,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                    ),
                  ],
                ),
                Text(
                  '-Rp 2.098 Poin',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: clrRed,
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
      ),
    );
  }
}

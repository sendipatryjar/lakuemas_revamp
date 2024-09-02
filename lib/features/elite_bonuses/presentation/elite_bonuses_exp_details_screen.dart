import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../cores/constants/img_assets.dart';
import '../../../cores/constants/app_color.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/widgets/main_back_button.dart';

class EliteBonusesExpDetailsScreen extends StatelessWidget {
  const EliteBonusesExpDetailsScreen({super.key});

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
          appBar: AppBar(
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: const Text(
              'Detail Kadaluarsa',
              style: TextStyle(
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
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Image.asset(icStar),
                    const SizedBox(width: 8),
                    Text(
                      'Tanggal Kadaluarsa',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Sebanyak 0 poin kamu akan berkurang dalam 3 bulan ke depan secara berangsur-angsur.',
                  style: TextStyle(
                    color: isElite
                        ? clrWhite.withOpacity(0.75)
                        : clrBackgroundBlack.withOpacity(0.75),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 16),
                  child: Divider(
                    thickness: 1,
                    color: clrNeutralGrey999.withOpacity(0.16),
                  ),
                ),
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Tanggal Kadaluarsa',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          ),
                          Text(
                            'Poin Kadaluarsa',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          ),
                          Text(
                            'Total Kadaluarsa',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ))
              ],
            ),
          ),
        );
      },
    );
  }
}

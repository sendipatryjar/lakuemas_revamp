import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/constants/img_assets.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/widgets/main_back_button.dart';
import 'widgets/elite_bonuses_faq_widget.dart';

class EliteBonusDetailsScreen extends StatelessWidget {
  final String? backScreen;
  const EliteBonusDetailsScreen({super.key, this.backScreen});

  @override
  Widget build(BuildContext context) {
    return _Content(
      backScreen: backScreen,
    );
  }
}

class _Content extends StatelessWidget {
  final String? backScreen;

  const _Content({
    Key? key,
    this.backScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          appBar: AppBar(
            backgroundColor: clrBlack101,
            centerTitle: true,
            title: Text(
              t.lblDetailBonuses,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            leading: MainBackButton(
              onPressed: () {
                if (backScreen != null) {
                  context.goNamed(
                    backScreen ?? AppRoutes.bonusElite,
                    extra: {
                      'isElite': isElite.toString(),
                      'eliteCubit': context.read<EliteCubit>()
                    },
                  );
                  return;
                }
                context.pop();
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(icStar),
                      const SizedBox(width: 8),
                      Text(
                        t.lblHowAddBonuses,
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
                    'Kamu akan mendapatkan sejumlah poin sesuai dengan campaign yang berjalan di aplikasi Lakuemas. Poin kamu bisa ditukarkan dengan berbagai macam reward.',
                    style: TextStyle(
                      color: isElite
                          ? clrWhite.withOpacity(0.75)
                          : clrBackgroundBlack.withOpacity(0.75),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    width: double.infinity,
                    height: 1,
                    color: clrNeutralGrey999.withOpacity(0.16),
                  ),
                  Row(
                    children: [
                      Image.asset(icWarningOrange),
                      const SizedBox(width: 8),
                      Text(
                        t.lblExpiredBonuses,
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
                    'Kamu akan mendapatkan sejumlah poin sesuai dengan campaign yang berjalan di aplikasi Lakuemas. Poin kamu bisa ditukarkan dengan berbagai macam reward.',
                    style: TextStyle(
                      color: isElite
                          ? clrWhite.withOpacity(0.75)
                          : clrBackgroundBlack.withOpacity(0.75),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ListView.builder(
                    itemCount: 4 + 1,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 32),
                          child: Text(
                            t.lblFrequentlyAsked,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          ),
                        );
                      }
                      return EliteBonusesFaqWidget(
                        title:
                            'Lorem ipsum dolor sit amet consectetur. Risusce volutpat aliquet commo?',
                        titleColor: isElite ? clrWhite : clrBackgroundBlack,
                        iconColor: isElite ? clrWhite : clrBackgroundBlack,
                        children: [
                          Text(
                            'Lakuemas adalah pionir layanan jual beli emas di Indonesia yang dapat diakses dari website, dan aplikasi mobile. Lakuemas didukung cabang-cabang di mal besar Indonesia, dimana nasabah dapat melakukan pembelian, penyimpanan, penjualan dan penarikan',
                            style: TextStyle(
                              color: (isElite ? clrWhite : clrBackgroundBlack)
                                  .withOpacity(0.75),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

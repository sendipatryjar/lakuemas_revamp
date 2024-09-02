import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../cores/constants/app_color.dart';
import '../../../cores/extensions/date_extension.dart';

import '../../../cores/services/cubits/helper_data/helper_data_cubit.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/widgets/get_bonus_banner.dart';
import '../../../cores/widgets/main_button.dart';
import '../domain/entities/elite_register_entity.dart';
import 'widgets/elite_card_list_widget.dart';

class EliteOrderSuccessScreen extends StatelessWidget {
  final EliteRegisterEntity eliteRegisterEntity;

  const EliteOrderSuccessScreen({
    super.key,
    required this.eliteRegisterEntity,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          bottomNavigationBar: _mainButton(context),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBonusBanner(
                  onBackBtnPressed: () {
                    context.goNamed(
                      AppRoutes.beranda,
                    );
                  },
                  isElite: isElite,
                ),
                const SizedBox(height: 20),
                // Container(
                //   margin: const EdgeInsets.all(20),
                //   padding: const EdgeInsets.all(20),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(30),
                //     border: Border.all(
                //       width: 2,
                //       color: clrGreen00B.withOpacity(0.2),
                //     ),
                //     gradient: LinearGradient(
                //       begin: Alignment.topLeft,
                //       end: Alignment.bottomRight,
                //       colors: [
                //         clrGreen00B.withOpacity(0.2),
                //         clrGreen00B.withOpacity(0.1),
                //       ],
                //     ),
                //   ),
                //   child: Column(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       _eliteItemTrx(
                //         isElite: isElite,
                //         title: successOrderTitle(t, 0),
                //         subTitle: successOrderSubTitle(t, 0),
                //       ),
                //       const SizedBox(height: 16),
                //       _eliteItemTrx(
                //         isElite: isElite,
                //         title: successOrderTitle(t, 1),
                //         subTitle: successOrderSubTitle(t, 1),
                //       ),
                //       const SizedBox(height: 16),
                //       _eliteItemTrx(
                //         isElite: isElite,
                //         title: successOrderTitle(t, 2),
                //         subTitle: successOrderSubTitle(t, 2),
                //       ),
                //       Divider(
                //         height: 32,
                //         thickness: 1,
                //         color: clrNeutralGrey999.withOpacity(0.16),
                //       ),
                //       _eliteItemTrx(
                //         isElite: isElite,
                //         title: successOrderTitle(t, 3),
                //         subTitle: successOrderSubTitle(t, 3),
                //       ),
                //       const SizedBox(height: 16),
                //       _eliteItemTrx(
                //         isElite: isElite,
                //         title: successOrderTitle(t, 4),
                //         subTitle: successOrderSubTitle(t, 4),
                //       ),
                //       const SizedBox(height: 16),
                //       _eliteItemTrx(
                //         isElite: isElite,
                //         title: successOrderTitle(t, 5),
                //         subTitle: successOrderSubTitle(t, 5),
                //       ),
                //       const SizedBox(height: 16),
                //       _eliteItemTrx(
                //         isElite: isElite,
                //         title: successOrderTitle(t, 6),
                //         subTitle: successOrderSubTitle(t, 6),
                //       ),
                //     ],
                //   ),
                // ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: EliteCardListWidget(
                    isElite: isElite,
                    itemLength: 7,
                    cardTitle: t.lblTransactionDone,
                    isUseDevider: false,
                    isSuccessTrx: true,
                    isShowSuccessIcon: true,
                    isShowCheckbox: false,
                    title: (index) => successOrderTitle(t, index),
                    subTitle: (index) => successOrderSubTitle(t, index),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Row _eliteItemTrx({
  //   required bool isElite,
  //   required String title,
  //   String? subTitle,
  // }) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: [
  //       Text(
  //         title,
  //         style: TextStyle(
  //           fontSize: 12,
  //           fontWeight: FontWeight.w500,
  //           color: isElite
  //               ? clrWhite.withOpacity(0.75)
  //               : clrBackgroundBlack.withOpacity(0.75),
  //         ),
  //       ),
  //       Text(
  //         subTitle ?? '-',
  //         style: TextStyle(
  //           fontSize: 12,
  //           fontWeight: FontWeight.w600,
  //           color: isElite ? clrWhite : clrBackgroundBlack,
  //         ),
  //       )
  //     ],
  //   );
  // }

  String successOrderTitle(AppLocalizations t, int index) {
    switch (index) {
      case 0:
        return t.lblPackageType;
      case 1:
        return t.lblCost;
      case 2:
        return t.lblActiveUntil;
      case 3:
        return 'No Pemesanan';
      case 4:
        return 'Tanggal Transaksi';
      case 5:
        return t.lblPaymentMethod;
      case 6:
        return t.lblMonthlyAutoDebet;
      default:
        return '-';
    }
  }

  String successOrderSubTitle(AppLocalizations t, int index) {
    switch (index) {
      case 0:
        return 'Lakuemas Elite ${eliteRegisterEntity.packageType}';
      case 1:
        return '${eliteRegisterEntity.grammationPrice} gram';
      case 2:
        return eliteRegisterEntity.subscriptionDateEnd.toDateLongMonthStr();
      case 3:
        return '${eliteRegisterEntity.transactionCode}';
      case 4:
        return eliteRegisterEntity.createdAt.toDateLongMonthStr();
      case 5:
        return 'Saldo Emas';
      case 6:
        return 'Saldo Emas';
      default:
        return '-';
    }
  }

  Container _mainButton(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: MainButton(
        label: t.lblBackToBeranda,
        onPressed: () {
          context.read<HelperDataCubit>().resetDataAfterTrx();
          context.goNamed(AppRoutes.beranda);
        },
      ),
    );
  }
}

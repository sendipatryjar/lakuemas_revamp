import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/extensions/currency_extension.dart';
import '../../../beranda/presentation/blocs/balance/balance_bloc.dart';

class ProfileTotalGoldWidget extends StatelessWidget {
  const ProfileTotalGoldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: clrWhite.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.lblYourTotalGold,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: clrWhite,
            ),
          ),
          const SizedBox(height: 2),
          BlocBuilder<BerandaBalancesBloc, BerandaBalancesState>(
            builder: (context, state) {
              String gold = '-';
              if (state is BerandaBalancesSuccessState) {
                gold = state.goldBalanceEntity?.gramationBalance ?? '-';
              }
              return RichText(
                text: TextSpan(
                  text: gold.isEmpty ? '0' : gold,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: clrYellow,
                  ),
                  children: const [
                    TextSpan(
                        text: ' gram',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        )),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          BlocBuilder<BerandaBalancesBloc, BerandaBalancesState>(
            builder: (context, state) {
              String goldNominal = '-';
              if (state is BerandaBalancesSuccessState) {
                goldNominal =
                    state.goldBalanceEntity?.nominalBalance?.toIdr() ?? '-';
              }
              return RichText(
                text: TextSpan(
                  text: t.lblWorth,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: clrWhite,
                  ),
                  children: [
                    TextSpan(
                        text:
                            ' Rp ${goldNominal.isNotEmpty ? goldNominal : '0'}'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

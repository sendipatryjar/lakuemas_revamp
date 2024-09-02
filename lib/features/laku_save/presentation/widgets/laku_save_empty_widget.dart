import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../beranda/presentation/blocs/balance/balance_bloc.dart';

class LakuSaveEmptyWidget extends StatelessWidget {
  final bool isElite;
  const LakuSaveEmptyWidget({
    super.key,
    this.isElite = false,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(imgLakuSaveEmpty),
          const SizedBox(height: 32),
          Text(
            t.lblEmptyLakuSaveDesc,
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isElite ? clrWhite : clrBackgroundBlack,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              context.goNamed(AppRoutes.aboutLakuSave, extra: {
                'berandaBalancesBloc': context.read<BerandaBalancesBloc>(),
              });
            },
            child: Text(
              '${t.lblLearnMore} >',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: clrBlue,
                decoration: TextDecoration.underline,
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/routes/app_routes.dart';
import '../../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_button.dart';

class RegisterEliteBanner extends StatelessWidget {
  final bool isElite;
  final bool isFromGrafik;
  const RegisterEliteBanner({
    Key? key,
    this.isElite = false,
    this.isFromGrafik = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double width = 180;
    final t = AppLocalizations.of(context)!;
    return LayoutBuilder(builder: (_, ctr) {
      double maxWidth = ctr.maxWidth - 128;
      if (ctr.maxWidth < 360) {
        maxWidth = 200;
      }
      return SafeArea(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(imgPeopleElite),
            const SizedBox(width: 8),
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Text(
                      isElite
                          ? t.lblSaveGoldDiligently
                          : "${t.lblJoin} Lakuemas Elite!",
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: isElite ? clrYellow : clrDarkBrown,
                      ),
                    ),
                  ),
                  Text(
                    isElite
                        ? t.lblGetLotsOfPrizes
                        : '${t.lblAnd} ${t.lblGetLowerPrice}!',
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: (isElite ? clrYellow : clrDarkBrown)
                          .withOpacity(0.75),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      MainButton(
                        label: isElite
                            ? t.lblStartSaving
                            : '${t.lblRegister} ${t.lblHere}',
                        labelStyle: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: isElite ? clrDarkBrown : clrWhite,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 4),
                        bgColor: isElite ? clrYellow : clrDarkBrown,
                        borderRadius: 30,
                        onPressed: isElite
                            ? () {
                                context.goNamed(
                                  AppRoutes.buyGold,
                                  extra: {
                                    'isElite': context
                                        .read<EliteCubit>()
                                        .state
                                        .toString(),
                                    'backScreenBuyGold': AppRoutes.elite,
                                  },
                                );
                              }
                            : () {
                                context.goNamed(
                                  AppRoutes.elite,
                                  extra: {
                                    'isFromGrafik': isFromGrafik,
                                  },
                                );
                              },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
          ],
        ),
      );
    });
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_color.dart';
import '../constants/img_assets.dart';
import '../routes/app_routes.dart';
import '../services/cubits/elite/elite_cubit.dart';
import '../utils/text_utils.dart';
import 'main_back_button.dart';
import 'main_button.dart';

class GetBonusBanner extends StatelessWidget {
  final Function()? onBackBtnPressed;
  final bool? isElite;
  final String? backScreen;
  final Map<String, dynamic>? extra;
  const GetBonusBanner({
    Key? key,
    this.onBackBtnPressed,
    this.isElite = false,
    this.backScreen,
    this.extra,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return LayoutBuilder(builder: (_, ctr) {
      // double maxWidth = ctr.maxWidth - 128;
      // if (ctr.maxWidth < 360) {
      //   maxWidth = 200;
      // }
      return Container(
        height: 192,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              imgBackgroundGold,
            ),
            fit: BoxFit.fill,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // const SizedBox(width: 20),
                    Image.asset(imgPeopleSip),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.lblGetBonus('10%'),
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: clrDarkBrown,
                          ),
                        ),
                        Text(
                          t.lblSaveGoldForFuture,
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: clrDarkBrown.withOpacity(0.75),
                          ),
                        ),
                        const SizedBox(height: 4),
                        MainButton(
                          label: '${t.lblStartSaving} ${t.lblGold}',
                          labelStyle: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: clrWhite,
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          bgColor: clrDarkBrown,
                          borderRadius: 30,
                          onPressed: () {
                            context.goNamed(
                              AppRoutes.buyGold,
                              extra: {
                                'isElite':
                                    context.read<EliteCubit>().state.toString(),
                                'backScreenBuyGold': backScreen,
                                'extra': extra,
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              MainBackButton(
                color: clrWhite,
                onPressed: onBackBtnPressed ??
                    () {
                      context.pop();
                    },
              )
            ],
          ),
        ),
      );
    });
  }
}

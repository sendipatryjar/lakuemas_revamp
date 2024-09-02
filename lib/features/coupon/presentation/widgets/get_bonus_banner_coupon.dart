import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/main_back_button.dart';

class GetBonusBannerCoupon extends StatelessWidget {
  final Function()? onBackBtnPressed;
  final bool? isElite;
  const GetBonusBannerCoupon({
    Key? key,
    this.onBackBtnPressed,
    this.isElite = false,
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

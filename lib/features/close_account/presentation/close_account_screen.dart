import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/card_list_widget.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';

class CloseAccountScreen extends StatelessWidget {
  const CloseAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrBlack101,
        centerTitle: true,
        title: Text(
          t.lblCloseAccount,
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: MainBackButton(
          onPressed: () {
            context.goNamed(AppRoutes.profile);
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MainButton(
          label: t.lblCloseMyAccount,
          onPressed: () {
            context.goNamed(AppRoutes.closeMyAccount);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              _section(
                context: context,
                t: t,
                title: '${t.lblQuestionAround} ${t.lblCloseAccount}',
                itemLength: 2,
                itemTitle: (index) => _questionItemTitle(t, index),
                itemSubTitle: null,
                onTap: (index) => _questionOnTap(context, index),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _questionItemTitle(AppLocalizations t, int index) {
    switch (index) {
      case 0:
        return t.lblHowLongCloseAccount;
      case 1:
        return t.lblWillGoldForfeitCloseAccount;
      default:
        return '-';
    }
  }

  void _questionOnTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.goNamed(AppRoutes.closeAccountHowLong);
        break;
      case 1:
        context.goNamed(AppRoutes.closeAccountGoldForfeit);
        break;
      default:
    }
  }

  Widget _section({
    required BuildContext context,
    required AppLocalizations t,
    required String title,
    required int itemLength,
    required String Function(int)? itemTitle,
    required String Function(int)? itemSubTitle,
    Widget? rightButton,
    TextDecoration? subTitleTextDecoration,
    Function(int)? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (rightButton != null) rightButton
          ],
        ),
        const SizedBox(height: 16),
        CardListWidget(
          isUseDevider: true,
          isUseRightArrow: true,
          itemLength: itemLength,
          title: itemTitle,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: clrBackgroundBlack,
          ),
          subTitle: itemSubTitle,
          subTitleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: clrBackgroundBlack,
            decoration: subTitleTextDecoration,
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}

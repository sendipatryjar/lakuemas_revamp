import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/extensions/currency_extension.dart';
import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/card_list_widget.dart';
import '../blocs/elite_blocs.dart';

class PaymentMethodWidget extends StatelessWidget {
  final bool isElite;
  final String? title;
  final Widget Function(int)? rightWidget;
  final int itemLength;
  final String Function(int)? menuName;
  final void Function(int)? menuOnTap;
  final Widget Function(int)? radioBtn;
  final Widget? optionalWidget;
  const PaymentMethodWidget({
    super.key,
    required this.isElite,
    this.title,
    this.rightWidget,
    this.itemLength = 0,
    this.menuName,
    this.menuOnTap,
    this.radioBtn,
    this.optionalWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isElite ? clrWhite : clrBackgroundBlack,
            ),
          ),
        if (title != null) const SizedBox(height: 16),
        CardListWidget(
          isElite: isElite,
          itemLength: itemLength,
          title: menuName,
          optionalWidget: optionalWidget,
          titleStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: clrNeutralGrey999.withOpacity(0.50),
          ),
          rightWidget: rightWidget,
          isUseRightArrow: false,
          radioBtn: radioBtn,
          onTap: menuOnTap,
        ),
      ],
    );
  }
}

class ChangePaymentWidgetItem extends StatelessWidget {
  final bool isElite;
  final dynamic Function()? onTap;
  const ChangePaymentWidgetItem({
    super.key,
    required this.isElite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: List.generate(
            1,
            (index) => Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isElite
                    ? clrGreyE5e.withOpacity(0.12)
                    : clrGreyE5e.withOpacity(0.25),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        t.lblGoldBalance,
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                      GestureDetector(
                        onTap: onTap,
                        child: Text(
                          'Ganti',
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Container(
                      height: 1,
                      width: double.infinity,
                      color: clrNeutralGrey999.withOpacity(0.16),
                    ),
                  ),
                  BlocBuilder<ElitePaymentMethodBloc, ElitePaymentMethodState>(
                    builder: (context, state) {
                      if (state is ElitePaymentMethodSuccessState) {
                        final data = state.elitePaymentMethodEntity[index];
                        return Text(
                          'Rp ${data.nominalBalance.toString().toIdr()} atau ${data.grammationBalance} gram saldo emas',
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 12,
                            color: isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.symmetric(
        //     vertical: 20,
        //     horizontal: 20,
        //   ),
        //   child: Text(
        //     t.lblMonthlyAutoDebet,
        //     style: TextStyle(
        //       fontWeight: FontWeight.w600,
        //       color: isElite ? clrWhite : clrBackgroundBlack,
        //     ),
        //   ),
        // ),
        // Container(
        //   height: 1,
        //   width: double.infinity,
        //   color: clrNeutralGrey999.withOpacity(0.16),
        // ),
      ],
    );
  }
}

class PaymentMethodItemWidget extends StatelessWidget {
  final bool isElite;
  final Widget Function(int)? radioBtn;
  final int itemLength;
  final String? balance;
  const PaymentMethodItemWidget({
    super.key,
    required this.isElite,
    this.radioBtn,
    this.itemLength = 0,
    this.balance,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Visibility(
      visible: true,
      replacement: Container(
        width: double.infinity,
        // padding: const EdgeInsets.symmetric(
        //   horizontal: 20,
        //   vertical: 18,
        // ),
        decoration: BoxDecoration(
          color: isElite
              ? clrGreyE5e.withOpacity(0.12)
              : clrGreyE5e.withOpacity(0.25),
          border: Border.all(
            width: 2,
            color: clrNeutralGrey999.withOpacity(0.16),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'data',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.transparent,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_right,
              size: 20,
              color: isElite ? clrWhite : null,
            )
          ],
        ),
      ),
      child: Container(
        width: double.infinity,
        // padding: const EdgeInsets.symmetric(
        //   horizontal: 20,
        // ),
        decoration: BoxDecoration(
          color: isElite
              ? clrGreyE5e.withOpacity(0.12)
              : clrGreyE5e.withOpacity(0.25),
          border: Border.all(
            width: 2,
            color: clrNeutralGrey999.withOpacity(0.16),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Theme(
          data: ThemeData().copyWith(
            dividerColor: Colors.transparent,
            colorScheme: ColorScheme.light(
              primary: clrYellow,
            ),
          ),
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              t.lblPaymentGuide,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isElite ? clrWhite : clrBackgroundBlack,
              ),
            ),
            tilePadding: const EdgeInsets.symmetric(horizontal: 20),
            // trailing: const SizedBox(),
            childrenPadding: const EdgeInsets.symmetric(
                // horizontal: 20,
                // vertical: 16,
                ),
            children: List.generate(
              itemLength,
              (index) => ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: isElite
                      ? clrWhite.withOpacity(0.20)
                      : clrWhite.withOpacity(0.50),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.lblGoldBalance,
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isElite ? clrWhite : clrBackgroundBlack,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                              ),
                              child: Container(
                                height: 1,
                                width: double.infinity,
                                color: clrNeutralGrey999.withOpacity(0.16),
                              ),
                            ),
                            BlocBuilder<ElitePaymentMethodBloc,
                                ElitePaymentMethodState>(
                              builder: (context, state) {
                                if (state is ElitePaymentMethodSuccessState) {
                                  final data =
                                      state.elitePaymentMethodEntity[index];
                                  return Text(
                                    'Rp ${data.nominalBalance.toString().toIdr()} atau ${data.grammationBalance} gram saldo emas',
                                    textScaler: TextScaler.linear(
                                        TextUtils.textScaleFactor(context)),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isElite
                                          ? clrWhite
                                          : clrBackgroundBlack,
                                    ),
                                  );
                                }
                                return const SizedBox();
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 30),
                        child: radioBtn!(index),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     ClipRRect(
    //       borderRadius: BorderRadius.circular(30),
    //       child: Container(
    //         decoration: BoxDecoration(
    //           border: Border.all(
    //             color: clrNeutralGrey999.withOpacity(0.16),
    //           ),
    //           borderRadius: BorderRadius.circular(30),
    //         ),
    //         child: ExpansionPanelList.radio(
    //           initialOpenPanelValue: 0,
    //           elevation: 0,
    //           expandedHeaderPadding: EdgeInsets.zero,
    //           children: [
    //             ExpansionPanelRadio(
    //               canTapOnHeader: true,
    //               backgroundColor: isElite
    //                   ? clrGreyE5e.withOpacity(0.12)
    //                   : clrGreyE5e.withOpacity(0.25),
    //               headerBuilder: (BuildContext context, bool isExpanded) {
    //                 return Container(
    //                   padding: const EdgeInsets.all(20),
    //                   child: Text(
    //                     '${t.lblSelect} ${t.lblPaymentMethods}',
    //                     style: TextStyle(
    //                       fontWeight: FontWeight.w500,
    //                       color: isElite ? clrWhite : clrBackgroundBlack,
    //                     ),
    //                   ),
    //                 );
    //               },
    //               body: Column(
    //                 children: List.generate(
    //                   itemLength,
    //                   (index) => ClipRRect(
    //                     borderRadius: const BorderRadius.only(
    //                       bottomLeft: Radius.circular(30),
    //                       bottomRight: Radius.circular(30),
    //                     ),
    //                     child: Container(
    //                       width: double.infinity,
    //                       padding: const EdgeInsets.all(20),
    //                       color: isElite
    //                           ? clrWhite.withOpacity(0.20)
    //                           : clrWhite.withOpacity(0.50),
    //                       child: Row(
    //                         children: [
    //                           Expanded(
    //                             child: Column(
    //                               crossAxisAlignment: CrossAxisAlignment.start,
    //                               children: [
    //                                 Text(
    //                                   t.lblGoldBalance,
    //                                   style: TextStyle(
    //                                     fontWeight: FontWeight.w500,
    //                                     color: isElite
    //                                         ? clrWhite
    //                                         : clrBackgroundBlack,
    //                                   ),
    //                                 ),
    //                                 Padding(
    //                                   padding: const EdgeInsets.symmetric(
    //                                     vertical: 10,
    //                                   ),
    //                                   child: Container(
    //                                     height: 1,
    //                                     width: double.infinity,
    //                                     color:
    //                                         clrNeutralGrey999.withOpacity(0.16),
    //                                   ),
    //                                 ),
    //                                 BlocBuilder<ElitePaymentMethodBloc,
    //                                     ElitePaymentMethodState>(
    //                                   builder: (context, state) {
    //                                     if (state
    //                                         is ElitePaymentMethodSuccessState) {
    //                                       final data = state
    //                                           .elitePaymentMethodEntity[index];
    //                                       return Text(
    //                                         'Rp ${data.nominalBalance.toString().toIdr()} atau ${data.grammationBalance} gram saldo emas',
    //                                         style: TextStyle(
    //                                           fontSize: 12,
    //                                           color: isElite
    //                                               ? clrWhite
    //                                               : clrBackgroundBlack,
    //                                         ),
    //                                       );
    //                                     }
    //                                     return const SizedBox();
    //                                   },
    //                                 ),
    //                               ],
    //                             ),
    //                           ),
    //                           Container(
    //                             padding: const EdgeInsets.only(left: 30),
    //                             child: radioBtn!(index),
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //               value: '',
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //     // Padding(
    //     //   padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
    //     //   child: Text(
    //     //     t.lblMonthlyAutoDebet,
    //     //     style: TextStyle(
    //     //       fontWeight: FontWeight.w600,
    //     //       color: isElite ? clrWhite : clrBackgroundBlack,
    //     //     ),
    //     //   ),
    //     // ),
    //     // Container(
    //     //   height: 1,
    //     //   width: double.infinity,
    //     //   color: clrNeutralGrey999.withOpacity(0.16),
    //     // ),
    //   ],
    // );
  }
}

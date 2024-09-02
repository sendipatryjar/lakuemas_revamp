import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../../../../cores/input_formater/uppercase_input_formater.dart';
import '../../../../cores/utils/dialog_utils.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/widgets/card_list_widget.dart';
import '../blocs/elite_blocs.dart';
import '../cubits/elite_cubits.dart';

class ActivationCodeWidget extends StatelessWidget {
  final bool isElite;
  final String? title;
  final Widget Function(int)? rightWidget;
  final int itemLength;
  final String Function(int)? menuName;
  final void Function(int)? menuOnTap;
  final Widget Function(int)? radioBtn;
  final Widget? optionalWidget;
  const ActivationCodeWidget({
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
    final t = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Row(
            children: [
              Text(
                title!,
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  DialogUtils.success(
                    context: context,
                    barrierDismissible: true,
                    isShowIcon: false,
                    firstDesc: t.lblExplanationActivationCodeTitle,
                    secondDesc: t.lblExplanationActivationCodeDesc,
                    btnText: t.lblBack,
                    btnOnPressed: () {
                      context.pop();
                    },
                  );
                },
                child: Image.asset(icQuestionMark),
              ),
            ],
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

class ActivationCodeItemWidget extends StatelessWidget {
  final bool isElite;
  final TextEditingController? activationCodeTec;
  final VoidCallback? onTap;
  const ActivationCodeItemWidget({
    super.key,
    required this.isElite,
    this.activationCodeTec,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteActivationCodeValidationCubit,
        EliteActivationCodeValidationState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: clrGreyE5e.withOpacity(0.25),
                        border: Border.all(
                          color: (state.isActivationCodeError == true)
                              ? clrRed.withOpacity(0.5)
                              : clrNeutralGrey999.withOpacity(0.16),
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          bottomLeft: Radius.circular(15),
                        ),
                        gradient: (state.isActivationCodeError == true)
                            ? LinearGradient(
                                colors: [
                                  clrRed,
                                  clrRed.withOpacity(0.9),
                                  clrRed.withOpacity(0.4),
                                  // clrRed.withOpacity(0.25),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                      ),
                      child: TextFormField(
                        controller: activationCodeTec,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                        textCapitalization: TextCapitalization.characters,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-zA-Z0-9]+$'),
                          ),
                          UpperCaseInputFormatter(),
                        ],
                        onChanged: (value) {
                          context
                              .read<EliteActivationCodeValidationCubit>()
                              .validate(
                                  t: t,
                                  activationCode:
                                      activationCodeTec?.text ?? '');
                        },
                        textAlign: TextAlign.start,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Masukkan kode aktivasi',
                          hintStyle: TextStyle(
                            color: clrNeutralGrey999.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: BlocBuilder<EliteActivationCodeBloc,
                        EliteActivationCodeState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () {
                            context
                                .read<EliteActivationCodeValidationCubit>()
                                .validate(
                                    t: t,
                                    activationCode:
                                        activationCodeTec?.text ?? '');
                            final isValid = context
                                .read<EliteActivationCodeValidationCubit>()
                                .isValid;
                            if (isValid) {
                              context
                                  .read<EliteActivationCodeBloc>()
                                  .add(EliteActivationCodeValidationEvent(
                                    activationCodeTec?.text,
                                    'elite',
                                  ));
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: clrYellow,
                              border: Border.all(
                                color: clrYellow,
                              ),
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(30),
                                bottomRight: Radius.circular(15),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                t.lblCheck,
                                textScaler: TextScaler.linear(
                                    TextUtils.textScaleFactor(context)),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            (state.isActivationCodeError == true)
                ? Container(
                    padding: const EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      state.activationCodeErrorMessage ?? '',
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        color: clrRed,
                        fontSize: 12,
                      ),
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Text(
                t.lblMonthlyAutoDebet,
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: clrBackgroundBlack.withOpacity(0.08),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../cores/constants/pin_type.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';
import '../cubits/cubit/pin_create_helper_cubit.dart';
import '../cubits/pin_typing/pin_typing_cubit.dart';
import 'pin_sphere_widget.dart';

class MainPinWidget extends StatelessWidget {
  final String errorText;
  final Color? errorTextColor;
  final bool isError;
  final Function()? onForgotPinPressed;
  const MainPinWidget({
    super.key,
    this.errorText = '',
    this.errorTextColor,
    this.isError = false,
    this.onForgotPinPressed,
  });

  @override
  Widget build(BuildContext context) {
    var t = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocBuilder<PinCreateHelperCubit, PinCreateHelperState>(
          builder: (context, state) {
            String title = '';
            if (state.pinType == PinType.create) {
              title = t.lblCreateNewPin;
            }
            if (state.pinType == PinType.createConfirmation) {
              title = t.lblCreateNewPinConfirmation;
            }
            return Text(
              title,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: clrWhite,
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        BlocBuilder<PinCreateHelperCubit, PinCreateHelperState>(
          builder: (context, state) {
            String subTitle = errorText;
            if (state.pinType == PinType.create) {
              subTitle = t.lblCreateNewPinDesc;
            }

            if (state.pinType == PinType.createConfirmation) {
              subTitle = t.lblCreateNewPinConfirmationDesc;
            }
            return Text(
              subTitle,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: errorTextColor ?? clrWhite.withOpacity(0.75),
              ),
            );
          },
        ),
        // const SizedBox(height: 16),
        BlocBuilder<PinTypingCubit, PinTypingState>(
          buildWhen: (previous, current) => previous != current,
          builder: (context, state) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                context.read<PinTypingCubit>().pinLength,
                (index) => PinSphereWidget(
                  input: index < state.pin.length,
                  isError: isError,
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        BlocBuilder<PinCreateHelperCubit, PinCreateHelperState>(
          builder: (context, state) {
            if (state.pinType == PinType.validate) {
              return InkWell(
                onTap: onForgotPinPressed,
                child: Text(
                  '${t.lblForgotYourPin}?',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: clrYellow,
                  ),
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }
}

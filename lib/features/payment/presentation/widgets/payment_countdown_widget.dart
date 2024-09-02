import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/services/cubits/countdown/countdown_cubit.dart';
import '../../../../cores/utils/text_utils.dart';

class PaymentCountdownWidget extends StatelessWidget {
  final String? text;
  final bool isRed;
  final int durationInSec;
  const PaymentCountdownWidget(
      {super.key, this.text, this.durationInSec = 60, this.isRed = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CountdownCubit()..startCountdown(durationInSec, true),
      child: _Content(isRed: isRed, text: text),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.isRed,
    required this.text,
  }) : super(key: key);

  final bool isRed;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (val) {
        context.read<CountdownCubit>().stopCountdown();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(
              color: isRed
                  ? clrRed.withOpacity(0.20)
                  : clrNeutralGrey999.withOpacity(0.16)),
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomLeft,
            colors: [
              clrRed.withOpacity(0.25),
              clrRed.withOpacity(0.20),
              clrRed.withOpacity(0.10),
              clrRed.withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            if (text != null)
              Text(
                text!,
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: isRed ? clrRed : clrBackgroundBlack,
                ),
              ),
            if (text != null) const SizedBox(height: 4),
            BlocBuilder<CountdownCubit, String?>(
              builder: (context, state) {
                return Text(
                  // '00:59:59',
                  state ?? '',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isRed ? clrRed : clrBackgroundBlack,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

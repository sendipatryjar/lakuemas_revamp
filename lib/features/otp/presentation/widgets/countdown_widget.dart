import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/otp_type.dart';
import '../../../../cores/services/cubits/countdown/countdown_cubit.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../../../cores/utils/validation_utils.dart';
import '../blocks/otp/otp_bloc.dart';

class CountdownWidget extends StatelessWidget {
  final String? parentScreenName;
  final String? username;
  final int? otpLocation;
  const CountdownWidget({
    super.key,
    this.parentScreenName,
    this.username,
    this.otpLocation,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    int countdownTime = 60;
    return BlocProvider(
      create: (context) => CountdownCubit()..startCountdown(countdownTime),
      child: BlocListener<OtpBloc, OtpState>(
        listener: (context, state) {
          if (state is OtpSuccess) {
            if (state.otp == Otp.resend) {
              context.read<CountdownCubit>().startCountdown(countdownTime);
            }
          }
        },
        child: Column(
          children: [
            Text(
              t.lblRemainingTime,
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: clrWhite,
              ),
            ),
            const SizedBox(height: 2),
            _Content(
              t: t,
              parentScreenName: parentScreenName,
              username: username,
              otpLocation: otpLocation,
            ),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final AppLocalizations t;
  final String? parentScreenName;
  final String? username;
  final int? otpLocation;
  const _Content({
    Key? key,
    required this.t,
    this.parentScreenName,
    this.username,
    this.otpLocation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountdownCubit, String?>(
      builder: (context, state) {
        return InkWell(
          onTap: state == null
              ? () {
                  context.read<OtpBloc>().add(OtpReSendPressed(
                        username: username ?? '',
                        otpType: ValidationUtils.email(username ?? '') ? 0 : 1,
                        otpLocation: otpLocation ?? OtpLocation.verify,
                      ));
                }
              : null,
          child: Text(
            state ?? t.lblResendOtp,
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: clrWhite,
              decoration: state == null ? TextDecoration.underline : null,
            ),
          ),
        );
      },
    );
  }
}

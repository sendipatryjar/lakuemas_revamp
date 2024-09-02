import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../../cores/input_formater/date_expired_input_formatter.dart';
import '../../../../cores/widgets/main_text_field.dart';
import '../cubits/payment/payment_cubit.dart';

class DebetDetailCardWidget extends StatelessWidget {
  const DebetDetailCardWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BlocBuilder<PaymentCubit, PaymentCbtState>(
              buildWhen: (previous, current) =>
                  (previous.paymentDebetEntity?.cardNumber !=
                      current.paymentDebetEntity?.cardNumber) ||
                  (previous.paymentDebetEntityErr?.cardNumber !=
                      current.paymentDebetEntityErr?.cardNumber),
              builder: (context, state) {
                return MainTextField(
                  title: 'Nomor Kartu Debit',
                  titleColor: clrBackgroundBlack.withOpacity(0.75),
                  initialValue: context
                      .read<PaymentCubit>()
                      .state
                      .paymentDebetEntity
                      ?.cardNumber,
                  hintText: 'Nomor Kartu Debitmu',
                  bgColor: clrNeutralGrey999.withOpacity(0.16),
                  textInputType: TextInputType.number,
                  isDarkMode: isElite,
                  onChange: (value) =>
                      context.read<PaymentCubit>().updateDebetCardNumber(
                            t: t,
                            cardNumber: value,
                          ),
                  errorText: state.paymentDebetEntityErr?.cardNumber,
                  isError: state.paymentDebetEntityErr?.cardNumber != null,
                  textInputFormatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*'))
                  ],
                );
              },
            ),
            const SizedBox(height: 18),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: BlocBuilder<PaymentCubit, PaymentCbtState>(
                    buildWhen: (previous, current) =>
                        (previous.paymentDebetEntity?.month !=
                            current.paymentDebetEntity?.month) ||
                        (previous.paymentDebetEntity?.year !=
                            current.paymentDebetEntity?.year) ||
                        (previous.paymentDebetEntityErr?.expDate !=
                            current.paymentDebetEntityErr?.expDate),
                    builder: (context, state) {
                      var month = context
                          .read<PaymentCubit>()
                          .state
                          .paymentDebetEntity
                          ?.month;
                      var year = context
                          .read<PaymentCubit>()
                          .state
                          .paymentDebetEntity
                          ?.year;
                      return MainTextField(
                        title: 'Masa Berlaku',
                        titleColor: clrBackgroundBlack.withOpacity(0.75),
                        initialValue: (month != null) && (year != null)
                            ? '$month/$year'
                            : null,
                        hintText: 'MM/YY',
                        bgColor: clrNeutralGrey999.withOpacity(0.16),
                        textInputType: TextInputType.number,
                        isDarkMode: isElite,
                        textInputFormatter: [
                          DateExpiredFormatter(),
                          LengthLimitingTextInputFormatter(5),
                          FilteringTextInputFormatter.allow(RegExp(r'^[0-9/]*'))
                        ],
                        onChange: (value) =>
                            context.read<PaymentCubit>().updateDebetExpDate(
                                  t: t,
                                  expDate: value,
                                ),
                        errorText: state.paymentDebetEntityErr?.expDate,
                        isError: state.paymentDebetEntityErr?.expDate != null,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: BlocBuilder<PaymentCubit, PaymentCbtState>(
                    buildWhen: (previous, current) =>
                        (previous.paymentDebetEntity?.cvv !=
                            current.paymentDebetEntity?.cvv) ||
                        (previous.paymentDebetEntityErr?.cvv !=
                            current.paymentDebetEntityErr?.cvv),
                    builder: (context, state) {
                      return MainTextField(
                        title: 'CVV',
                        titleColor: clrBackgroundBlack.withOpacity(0.75),
                        initialValue: context
                            .read<PaymentCubit>()
                            .state
                            .paymentDebetEntity
                            ?.cvv,
                        hintText: 'CVV',
                        bgColor: clrNeutralGrey999.withOpacity(0.16),
                        textInputType: TextInputType.number,
                        isDarkMode: isElite,
                        textInputFormatter: [
                          LengthLimitingTextInputFormatter(4),
                          FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*'))
                        ],
                        onChange: (value) =>
                            context.read<PaymentCubit>().updateDebetCvv(
                                  t: t,
                                  cvv: value,
                                ),
                        errorText: state.paymentDebetEntityErr?.cvv,
                        isError: state.paymentDebetEntityErr?.cvv != null,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

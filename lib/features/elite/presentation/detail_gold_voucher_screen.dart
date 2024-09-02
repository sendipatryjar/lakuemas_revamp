import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/constants/img_assets.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/depedencies_injection/depedency_injection.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';

class DetailGoldVoucherScreen extends StatelessWidget {
  const DetailGoldVoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<EliteCubit>()),
      ],
      child: BlocBuilder<EliteCubit, bool>(
        builder: (context, isElite) {
          return Scaffold(
            backgroundColor: clrBlack080,
            appBar: AppBar(
              backgroundColor: clrBackgroundBlack,
              centerTitle: true,
              title: Text(
                t.lblEliteGoldVoucher,
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              leading: MainBackButton(
                onPressed: () {
                  context.goNamed(
                    AppRoutes.listGoldVoucher,
                    extra: {
                      'isElite': isElite,
                      'eliteCubit': context.read<EliteCubit>()
                    },
                  );
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: _content(context),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _content(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Voucher Emas',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: clrWhite,
              ),
            ),
            Row(
              children: [
                Image.asset(icCheckOutline, width: 16),
                const SizedBox(width: 8),
                Text(
                  'Belum Digunakan',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: clrGreen00A,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        RichText(
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          text: TextSpan(
            text:
                'Selama periode 25 December 2022 - 24 January 2023, Anda telah berhasil merujuk',
            style: TextStyle(
              fontSize: 12,
              color: clrWhite.withOpacity(0.75),
            ),
            children: [
              TextSpan(
                text: '1 Orang.',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: clrWhite,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              width: 2,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
            color: clrGreyE5e.withOpacity(0.12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kode Voucher',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: clrWhite,
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        width: 2,
                        color: clrNeutralGrey999.withOpacity(0.16),
                      ),
                      color: clrGreyE5e.withOpacity(0.12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'referralCode',
                            textScaler: TextScaler.linear(
                                TextUtils.textScaleFactor(context)),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: clrWhite,
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                                    const ClipboardData(text: 'referralCode'))
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content:
                                      Text("Kode Referral berhasil disalin!"),
                                ),
                              );
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 9,
                              horizontal: 18,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                width: 2,
                                color: clrWhite.withOpacity(0.13),
                              ),
                              color: clrYellow,
                            ),
                            child: Text(
                              'Salin',
                              textScaler: TextScaler.linear(
                                  TextUtils.textScaleFactor(context)),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: clrBackgroundBlack,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
          color: clrNeutralGrey999.withOpacity(0.16),
          height: 32,
        ),
        Text(
          'Detail Voucher',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: clrWhite,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nominal Bonus',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 12,
                color: clrWhite.withOpacity(0.75),
              ),
            ),
            Text(
              'Rp 50.000',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: clrWhite.withOpacity(0.75),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pajak',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 12,
                color: clrWhite.withOpacity(0.75),
              ),
            ),
            Text(
              'Rp 1.250',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: clrWhite.withOpacity(0.75),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Voucher Yang Didapat',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: clrWhite,
              ),
            ),
            Text(
              'Rp 1.250',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: clrWhite,
              ),
            ),
          ],
        ),
        Divider(
          thickness: 1,
          color: clrNeutralGrey999.withOpacity(0.16),
          height: 32,
        ),
        Text(
          'Tanggal Kadaluarsa: 25 February 2023, 01:00 WIB',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: clrWhite.withOpacity(0.75),
          ),
        ),
        Divider(
          thickness: 1,
          color: clrNeutralGrey999.withOpacity(0.16),
          height: 32,
        ),
        Text(
          'Tukarkan voucher ini di aplikasi Lakuemas untuk saldo emas digital.',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 12,
            color: clrWhite.withOpacity(0.75),
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          text: TextSpan(
            text:
                'Jika ada pertanyaan, Anda bisa mengirim email kepada kami di ',
            style: TextStyle(
              fontSize: 12,
              color: clrWhite.withOpacity(0.75),
            ),
            children: [
              TextSpan(
                text: 'support@lakuemas.com',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: clrWhite,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

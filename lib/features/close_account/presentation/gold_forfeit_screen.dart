import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';

class GoldForfeitScreen extends StatelessWidget {
  const GoldForfeitScreen({super.key});

  _goToCloseAccount(BuildContext context) {
    context.goNamed(AppRoutes.closeAccount);
  }

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
            _goToCloseAccount(context);
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: MainButton(
          label: t.lblBack,
          onPressed: () {
            _goToCloseAccount(context);
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
              Text(
                t.lblHowLongCloseAccount,
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: clrDarkBlue,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Kami menyarankan agar kamu mengosongkan seluruh Saldo Emas dan Saldo Akun kamu (dalam kondisi Rp 0,-) sebelum mengajukan permintaan penutupan Akun Lakuemas.',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: clrBackgroundBlack.withOpacity(0.75),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

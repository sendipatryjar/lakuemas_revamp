import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/utils/text_utils.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: clrBlack101,
        centerTitle: true,
        title: Text(
          '${t.lblAbout} ${t.lblUs}',
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
          label: t.lblBack,
          onPressed: () {
            context.goNamed(AppRoutes.profile);
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
                '${t.lblAbout} Lakuemas',
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
                'Lakuemas adalah pionir layanan jual beli emas di Indonesia yang dapat diakses dari website, dan aplikasi mobile. Lakuemasdidukung cabang-cabang di mal besar Indonesia,dimana nasabah dapat melakukan pembelian, penyimpanan, penjualandan penarikan emas tanpa adanya biaya penyimpanan dan mendapatkankeuntungan tambahan.\n\nKami mendukung pertumbuhan ekonomikreatif di bidang industri emas dan perhiasan dengan mengembangkanUKM berpotensi dan membantu mengelola tabungan emas nasabah agar dapat memberikan hasil yang kompetitif.',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: clrBackgroundBlack.withOpacity(0.75),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../../cores/widgets/main_button.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/widgets/main_back_button.dart';

class PhysicalTradeFaqScreen extends StatelessWidget {
  const PhysicalTradeFaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Content();
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          appBar: _appBar(context),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: MainButton(
              label: 'Kembali',
              onPressed: () {
                context.pop();
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Apa itu Tukar Fisik?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tukar Fisik adalah layanan dimana Nasabah dapat melakukan pembelian Logam Mulai Antam Certieye menggunakan Saldo Digital (Emas Digital dan Saldo Akun), ataupun dengan Rupiah pada Toko Rekanan (Frank&Co, Mondial, dan The Palace) dan Butik Lakuemas',
                    style: TextStyle(
                      fontSize: 12,
                      color: isElite
                          ? clrWhite.withOpacity(0.75)
                          : clrBackgroundBlack.withOpacity(0.75),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Kenapa Pilih Tukar Fisik?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _faqCard(context, isElite: isElite),
                  _faqCard(context, isElite: isElite),
                  _faqCard(context, isElite: isElite),
                  Text(
                    'Persyaratan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Akun sudah terverifikasi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                  Text(
                    'Pastikan akun sudah melalui proses verifikasi terlebih dahulu.',
                    style: TextStyle(
                      fontSize: 12,
                      color: isElite
                          ? clrWhite.withOpacity(0.75)
                          : clrBackgroundBlack.withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _faqCard(BuildContext context, {required bool isElite}) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: clrNeutralGrey999.withOpacity(0.16),
        ),
        color: isElite
            ? clrGreyE5e.withOpacity(0.12)
            : clrGreyE5e.withOpacity(0.25),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Proses cepat dan mudah',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Nasabah dapat langsung memilih emas yang ingin ditarik, langsung dari aplikasi Lakuemas',
                  style: TextStyle(
                    fontSize: 10,
                    color: isElite
                        ? clrWhite.withOpacity(0.75)
                        : clrBackgroundBlack.withOpacity(0.75),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: clrBlack101,
      centerTitle: true,
      title: const Text(
        'Tukar Fisik',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: MainBackButton(
        onPressed: () {
          context.pop();
        },
      ),
    );
  }
}

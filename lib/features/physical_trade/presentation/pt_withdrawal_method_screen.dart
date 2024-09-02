import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../cores/constants/img_assets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../cores/constants/app_color.dart';
import '../../../cores/routes/app_routes.dart';
import '../../../cores/services/cubits/elite/elite_cubit.dart';
import '../../../cores/widgets/main_back_button.dart';
import '../../../cores/widgets/main_button.dart';

class PTWithdrawalMethodScreen extends StatelessWidget {
  const PTWithdrawalMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Content();
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return BlocBuilder<EliteCubit, bool>(
      builder: (context, isElite) {
        return Scaffold(
          backgroundColor: isElite ? clrBlack080 : null,
          appBar: _appBar(context, t: t),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: MainButton(
              label: t.lblContinue,
              onPressed: () {
                // context.goNamed(AppRoutes.ptWithdrawalMethod);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _pickupStore(context, isElite: isElite, t: t),
                  const SizedBox(height: 20),
                  _paymentMethod(context, isElite: isElite, t: t),
                  const SizedBox(height: 20),
                  _detailOrder(context, isElite: isElite, t: t)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _pickupStore(
    BuildContext context, {
    required bool isElite,
    required AppLocalizations t,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          t.lblPickupStore,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: () {
                  context.goNamed(
                    AppRoutes.pickupStore,
                    extra: {'isElite': isElite.toString()},
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      t.lblSelectStore,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: isElite
                          ? clrWhite.withOpacity(0.32)
                          : clrBackgroundBlack.withOpacity(0.32),
                      size: 15,
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                color: clrNeutralGrey999.withOpacity(0.16),
                height: 32,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    width: 1.5,
                    color: clrBlue006.withOpacity(0.2),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      clrBlue006.withOpacity(0.16),
                      clrBlue006.withOpacity(0.03),
                    ],
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      icInfo,
                      width: 16,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tukar Fisik diproses dalam 2 - 3 hari kerja setelah pemesanan. Lakuemas akan mengirimkan email jika emas kamu sudah siap diambil',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Lokasi Pengambilan Belum Dipilih',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pilih Lokasi Toko Pengambilan',
                style: TextStyle(
                  fontSize: 11,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _paymentMethod(
    BuildContext context, {
    required bool isElite,
    required AppLocalizations t,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          t.lblPaymentMethods,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
        ),
        const SizedBox(height: 16),
        Container(
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              _amoutWidget(
                title: t.lblAccountBalance,
                total: '922.000',
                isElite: isElite,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 1,
                  color: clrNeutralGrey999.withOpacity(0.16),
                  height: 32,
                ),
              ),
              _amoutWidget(
                title: '${t.lblGoldBalance} (2,0000 gr)',
                total: '2.000.000',
                isElite: isElite,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 1,
                  color: clrNeutralGrey999.withOpacity(0.16),
                  height: 32,
                ),
              ),
              _amoutWidget(
                title: 'Transfer VA BCA',
                total: '2.078.000',
                isElite: isElite,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _detailOrder(
    BuildContext context, {
    required bool isElite,
    required AppLocalizations t,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          t.lblDetailOrder,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
        ),
        const SizedBox(height: 16),
        Container(
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              _amoutWidget(
                title: 'LMAntam Certieye ',
                total: '5.000.000',
                subtitle: '1 gram x 1',
                isElite: isElite,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 1,
                  color: clrNeutralGrey999.withOpacity(0.16),
                  height: 32,
                ),
              ),
              _amoutWidget(
                title: 'LMAntam Certieye ',
                total: '922.000',
                subtitle: '1 gram x 1',
                isElite: isElite,
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  color: clrYellow.withOpacity(0.50),
                ),
                child: _amoutWidget(
                  title: '${t.lblTotal} ${t.lblPrice}',
                  total: '2.078.000',
                  isTotal: true,
                  isElite: isElite,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _appBar(
    BuildContext context, {
    required AppLocalizations t,
  }) {
    return AppBar(
      backgroundColor: clrBlack101,
      centerTitle: true,
      title: Text(
        t.lblWithdrawalMethod,
        style: const TextStyle(
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

  Widget _amoutWidget({
    required String title,
    required String total,
    String? subtitle,
    bool isElite = false,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: isTotal ? FontWeight.w600 : FontWeight.w500,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
              SizedBox(height: (subtitle ?? '').isEmpty ? 0 : 2),
              (subtitle ?? '').isEmpty
                  ? const SizedBox()
                  : Text(
                      subtitle ?? '',
                      style: TextStyle(
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                    ),
            ],
          ),
          RichText(
            text: TextSpan(
              text: 'Rp ',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isElite ? clrWhite : clrBackgroundBlack,
              ),
              children: [
                TextSpan(
                  text: total,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

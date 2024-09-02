import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/constants/img_assets.dart';
import '../cubits/qr_transfer/qr_transfer_cubit.dart';

class TabWidget extends StatelessWidget {
  const TabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.transparent,
        border: Border.all(
          width: 2,
          color: clrNeutralGrey999.withOpacity(0.16),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: BlocBuilder<QrTransferCubit, QrTransferState>(
                buildWhen: (previous, current) =>
                    previous.enQRTransfer != current.enQRTransfer,
                builder: (context, state) {
                  return _tab(
                    title: 'Scan QR',
                    icon: state.enQRTransfer == EnQRTransfer.scanQR
                        ? icScanActive
                        : icScanInactive,
                    isSelected: state.enQRTransfer == EnQRTransfer.scanQR,
                    onTap: () {
                      context
                          .read<QrTransferCubit>()
                          .changeTab(EnQRTransfer.scanQR);
                    },
                  );
                },
              ),
            ),
            Container(
              width: 2,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
            Expanded(
              child: BlocBuilder<QrTransferCubit, QrTransferState>(
                buildWhen: (previous, current) =>
                    previous.enQRTransfer != current.enQRTransfer,
                builder: (context, state) {
                  return _tab(
                    title: 'Kode QR Saya',
                    icon: state.enQRTransfer == EnQRTransfer.codeQR
                        ? icQRCodeActive
                        : icQRCodeInactive,
                    isSelected: state.enQRTransfer == EnQRTransfer.codeQR,
                    onTap: () {
                      context
                          .read<QrTransferCubit>()
                          .changeTab(EnQRTransfer.codeQR);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab({
    required String title,
    required String icon,
    bool isSelected = false,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            icon,
            width: 28,
            height: 28,
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected
                  ? clrYellow.withOpacity(0.75)
                  : clrNeutralGrey999.withOpacity(0.50),
            ),
          ),
        ],
      ),
    );
  }
}

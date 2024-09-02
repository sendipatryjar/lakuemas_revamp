import 'package:flutter/material.dart';
import '../../../../cores/constants/img_assets.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';

class TrxCardWidget extends StatefulWidget {
  final bool isElite;
  final String? typeLabel;
  final String? trxVal;
  final String? trxDate;
  final String? noTrxVal;
  final String? totTrxVal;
  final String? currGoldVal;
  final String? statusLabel;
  final int? status;
  const TrxCardWidget({
    super.key,
    required this.isElite,
    this.typeLabel,
    this.trxVal,
    this.trxDate,
    this.noTrxVal,
    this.totTrxVal,
    this.currGoldVal,
    this.statusLabel,
    this.status,
  });

  @override
  State<TrxCardWidget> createState() => _TrxCardWidgetState();
}

class _TrxCardWidgetState extends State<TrxCardWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    double trxValue = double.parse(widget.trxVal ?? '0');

    return Container(
      padding: const EdgeInsets.only(top: 16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: clrNeutralGrey999.withOpacity(0.16),
        ),
        color: widget.isElite
            ? clrGreyE5e.withOpacity(0.12)
            : clrGreyE5e.withOpacity(0.25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.typeLabel ?? '-',
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: widget.isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      width: 1,
                      color: _borderColor(widget.status),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: _bgGradient(widget.status),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        widget.statusLabel ?? '-',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: _statusColor(widget.status),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Image.asset(
                        icInfoDark,
                        color: _statusColor(widget.status),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '${trxValue.toStringAsFixed(4)} gram',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: widget.isElite ? clrWhite : clrBackgroundBlack,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.trxDate ?? '-',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: widget.isElite
                    ? clrWhite.withOpacity(0.75)
                    : clrBackgroundBlack.withOpacity(0.75),
              ),
            ),
          ),
          if (!isExpanded) const SizedBox(height: 16),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 1,
                color: clrNeutralGrey999.withOpacity(0.16),
                height: 32,
              ),
            ),
          if (isExpanded)
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nomor Transaksi',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 10,
                          color: widget.isElite
                              ? clrWhite.withOpacity(0.75)
                              : clrBackgroundBlack.withOpacity(0.75),
                        ),
                      ),
                      Text(
                        widget.noTrxVal ?? '-',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: widget.isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                    ],
                  ),
                  if (widget.typeLabel?.toLowerCase() == 'beli emas' ||
                      widget.typeLabel?.toLowerCase() == 'jual emas' ||
                      widget.typeLabel?.toLowerCase() == 'redeem voucher') ...[
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _dynamicTot(widget.typeLabel ?? ''),
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 10,
                            color: widget.isElite
                                ? clrWhite.withOpacity(0.75)
                                : clrBackgroundBlack.withOpacity(0.75),
                          ),
                        ),
                        Text(
                          _dynamicTotValue(widget.typeLabel ?? '-', trxValue),
                          textScaler: TextScaler.linear(
                              TextUtils.textScaleFactor(context)),
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color:
                                widget.isElite ? clrWhite : clrBackgroundBlack,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Saldo Emas Saat Ini',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 10,
                          color: widget.isElite
                              ? clrWhite.withOpacity(0.75)
                              : clrBackgroundBlack.withOpacity(0.75),
                        ),
                      ),
                      Text(
                        widget.currGoldVal ?? '-',
                        textScaler: TextScaler.linear(
                            TextUtils.textScaleFactor(context)),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: widget.isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: clrNeutralGrey999.withOpacity(0.08),
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${!isExpanded ? 'Buka' : 'Tutup'} Detail Transaksi',
                    textScaler:
                        TextScaler.linear(TextUtils.textScaleFactor(context)),
                    style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: clrNeutralGrey999),
                  ),
                  !isExpanded
                      ? Icon(
                          Icons.keyboard_arrow_down,
                          color: clrNeutralGrey999,
                        )
                      : Icon(
                          Icons.keyboard_arrow_up,
                          color: clrNeutralGrey999,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _dynamicTot(String typeLabel) {
    switch (typeLabel.toLowerCase()) {
      case 'beli emas':
        return 'Total Pembayaran';
      case 'jual emas':
        return 'Total Penjualan';
      case 'redeem voucher':
        return 'Nominal Voucher';
      case 'laku simpan':
        return 'Deposit';
      case 'laku tukar':
        return 'Penukaran';
      case 'transfer emas':
        return 'Transfer';
      case 'payment elite':
        return 'Emas Terpakai';
      default:
        return '-';
    }
  }

  String _dynamicTotValue(String typeLabel, double trxVal) {
    switch (typeLabel.toLowerCase()) {
      case 'beli emas':
        return 'Rp ${widget.totTrxVal ?? '-'}';
      case 'jual emas':
        return 'Rp ${widget.totTrxVal ?? '-'}';
      case 'redeem voucher':
        return 'Rp ${widget.totTrxVal ?? '-'}';
      case 'laku simpan':
        return 'Rp ${widget.totTrxVal ?? '-'}';
      case 'laku tukar':
        return 'Rp ${widget.totTrxVal ?? '-'}';
      case 'transfer emas':
        return 'Rp ${widget.totTrxVal ?? '-'}';
      case 'payment elite':
        return 'Rp ${widget.totTrxVal ?? '-'}';
      default:
        return '-';
    }
  }

  Color _statusColor(int? status) {
    switch (status) {
      case 0:
        return clrGrey75;
      case 1:
        return clrGreen00B;
      case -1:
        return clrRed;
      case 2:
        return clrRed;
      case 3:
        return clrGrey75;
      case 5:
        return clrGreen00B;
      default:
        return clrGrey75;
    }
  }

  Color _borderColor(int? status) {
    switch (status) {
      case 0:
        return clrGrey75.withOpacity(0.10);
      case 1:
        return clrGreen00B.withOpacity(0.10);
      case -1:
        return clrRed.withOpacity(0.10);
      case 2:
        return clrRed.withOpacity(0.10);
      case 3:
        return clrGrey75.withOpacity(0.10);
      case 5:
        return clrGreen00B.withOpacity(0.10);
      default:
        return clrGrey75.withOpacity(0.10);
    }
  }

  List<Color> _bgGradient(int? status) {
    switch (status) {
      case 0:
        return [clrGreyE5e.withOpacity(0.25), clrGreyE5e.withOpacity(0.12)];
      case 1:
        return [clrGreen00B.withOpacity(0.16), clrGreyE5e.withOpacity(0.03)];
      case -1:
        return [clrRed.withOpacity(0.25), clrRed.withOpacity(0.05)];
      case 2:
        return [clrRed.withOpacity(0.25), clrRed.withOpacity(0.05)];
      case 3:
        return [clrGreyE5e.withOpacity(0.25), clrGreyE5e.withOpacity(0.12)];
      case 5:
        return [clrGreen00B.withOpacity(0.16), clrGreyE5e.withOpacity(0.03)];
      default:
        return [clrGreyE5e.withOpacity(0.25), clrGreyE5e.withOpacity(0.12)];
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../cores/constants/app_color.dart';
import '../../../../cores/utils/text_utils.dart';
import '../../domain/entities/detail_transaction_entity.dart';
import '../../../../cores/extensions/currency_extension.dart';

String trxScsOneTitle(String type, AppLocalizations t, bool? isTransfered) {
  switch (type.toLowerCase()) {
    case 'beli emas':
      return t.lblPurchaseAmount;
    case 'jual emas':
      return t.lblSellingAmount;
    case 'transfer emas':
      return isTransfered == true ? 'Transfer dari' : t.lblTransferTo;
    case 'elite':
      return 'Paket Pembelian Elite';
    case 'lakuemas elite':
      return 'Paket Pembelian Elite';
    case 'laku tukar':
      return 'Jumlah gram yang ditukar';
    case 'redeem voucher':
      return 'Nominal Voucher';
    case 'laku simpan':
      return 'Berat Emas yang dititipkan';
    case 'convert gold':
      return 'Jumlah gram';
    case 'pembelian gatcha':
      return 'Harga Gatcha';
    default:
      return '-';
  }
}

String trxScsOneValue(String type, DetailTransactionEntity? detailTransaction) {
  switch (type.toLowerCase()) {
    case 'beli emas':
      return 'Rp ${double.tryParse(detailTransaction?.amount ?? '')?.toIdr() ?? '-'}';
    case 'jual emas':
      return 'Rp ${double.tryParse(detailTransaction?.amount ?? '')?.toIdr() ?? '-'}';
    case 'transfer emas':
      return '${detailTransaction?.accountNumber ?? ''} - ${detailTransaction?.accountName ?? ''}';
    case 'elite':
      return '${detailTransaction?.packageMonth ?? ''} Bulan';
    case 'lakuemas elite':
      return '${detailTransaction?.elite?.packageMonth ?? ''} Bulan';
    case 'laku tukar':
      return '${detailTransaction?.item?.weight ?? '-'} gram';
    case 'redeem voucher':
      return 'Rp ${detailTransaction?.amount.toIdr() ?? '-'}';
    case 'laku simpan':
      return '${detailTransaction?.goldAmount ?? '-'} gram';
    case 'convert gold':
      return '${detailTransaction?.goldAmount ?? '-'} gram';
    case 'pembelian gatcha':
      return '${detailTransaction?.goldAmount ?? '-'} gram';
    default:
      return '-';
  }
}

///
///

String trxScsTwoTitle(String type, AppLocalizations t,
    [DetailTransactionEntity? detailTransaction]) {
  switch (type.toLowerCase()) {
    case 'beli emas':
      return t.lblEqualsTo;
    case 'jual emas':
      return t.lblEqualsTo;
    case 'transfer emas':
      return t.lblTransferWorth;
    case 'elite':
      return 'Biaya';
    case 'lakuemas elite':
      return 'Biaya';
    case 'laku tukar':
      return 'Jenis Emas';
    case 'redeem voucher':
      return 'Harga 1 Gram + Pajak 0,45%';
    case 'laku simpan':
      return 'Sumber Dana';
    case 'pembelian gatcha':
      return t.lblEqualsTo;
    default:
      return '-';
  }
}

String trxScsTwoValue(String type, DetailTransactionEntity? detailTransaction) {
  switch (type.toLowerCase()) {
    case 'beli emas':
      return '${detailTransaction?.goldAmount ?? '-'} gram';
    case 'jual emas':
      return '${detailTransaction?.goldAmount ?? '-'} gram';
    case 'transfer emas':
      return '${double.tryParse(detailTransaction?.goldAmount ?? '0')?.toGold4Dec() ?? '-'} gram';
    case 'elite':
      return detailTransaction?.total ?? '-';
    case 'lakuemas elite':
      return '${detailTransaction?.elite?.grammationPrice ?? '-'} gram';
    case 'laku tukar':
      return detailTransaction?.item?.brand ?? '-';
    case 'redeem voucher':
      double? sellingPrice =
          double.tryParse(detailTransaction?.sellingPrice ?? '') ?? 0;
      double? nominalTax =
          double.tryParse(detailTransaction?.nominalTax ?? '') ?? 0;
      double? total = sellingPrice + nominalTax;
      return 'Rp ${total.toIdr()}';
    case 'laku simpan':
      return 'Akun Utama (${detailTransaction?.accountNumber ?? '-'})';
    case 'pembelian gatcha':
      return 'Rp ${detailTransaction?.amount.toIdr() ?? '-'}';
    default:
      return '-';
  }
}

///
///
///

String detailWording(String type, AppLocalizations t) {
  switch (type.toLowerCase()) {
    case 'redeem voucher':
      return 'Detail Redeem';
    default:
      return t.lblPaymentDetail;
  }
}

Widget trxDetailWidget(
  BuildContext context, {
  required AppLocalizations t,
  bool isElite = false,
  int? status,
  required String? type,
  required DetailTransactionEntity? data,
  required bool isNpwpFieldShowed,
  required Function()? onNpwpFieldCLicked,
}) {
  switch (type?.toLowerCase()) {
    case 'transfer emas':
      return _detailTransfer(
        context,
        t: t,
        transferChargeEntity: data,
        isElite: isElite,
        status: status,
      );
    case 'tarik fisik':
      return _detailTarikFisik(
        context,
        t: t,
        data: data,
        isElite: isElite,
        status: status,
      );
    case 'tarik tunai':
      return _detailWithdrawal(context, t: t, data: data, isElite: isElite);
    case 'elite':
      return const SizedBox();
    case 'lakuemas elite':
      return const SizedBox();
    case 'laku simpan':
      return const SizedBox();
    case 'redeem voucher':
      return _detailRedeem(context,
          t: t, data: data, isElite: isElite, status: status);
    case 'laku tukar':
      return _detailLakuTrade(context, t: t, data: data, isElite: isElite);
    case 'convert gold':
      return const SizedBox();
    case 'pembelian gatcha':
      return const SizedBox();
    default:
      return _detailPayment(
        context,
        t,
        isElite,
        status,
        data,
        isNpwpFieldShowed: isNpwpFieldShowed,
        onNpwpFieldCLicked: onNpwpFieldCLicked,
      );
  }
}

Widget _detailRedeem(
  BuildContext context, {
  required AppLocalizations t,
  bool isElite = false,
  int? status,
  required DetailTransactionEntity? data,
}) =>
    Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: status == 1
            ? clrGreen00B.withOpacity(0.16)
            : (status == 2 || status == -1)
                ? clrRed.withOpacity(0.1)
                : (isElite
                    ? clrGreyE5e.withOpacity(0.12)
                    : clrGreyE5e.withOpacity(0.25)),
        border: Border.all(
            color: status == 1
                ? clrGreen00B.withOpacity(0.2)
                : (status == 2 || status == -1)
                    ? clrRed.withOpacity(0.2)
                    : (isElite
                        ? clrNeutralGrey999.withOpacity(0.16)
                        : clrNeutralGrey999.withOpacity(0.16))),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    RichText(
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      text: TextSpan(
                        text: 'Rp ',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                        children: [
                          TextSpan(
                            text: data?.amount.toIdr() ?? '-',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      ' / ',
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                    ),
                    RichText(
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      text: TextSpan(
                        text: 'Rp ',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                        children: [
                          TextSpan(
                            text: data?.sellingPrice.toIdr() ?? '-',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isElite ? clrWhite : clrBackgroundBlack,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                RichText(
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  text: TextSpan(
                    text: data?.goldAmount ?? '-',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                    children: [
                      TextSpan(
                        text: ' gr',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: clrYellow.withOpacity(0.5),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total didapat',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
                RichText(
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  text: TextSpan(
                    text: data?.goldAmount ?? '-',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                    children: [
                      TextSpan(
                        text: ' gr',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

Widget _detailLakuTrade(
  BuildContext context, {
  required AppLocalizations t,
  required DetailTransactionEntity? data,
  required bool isElite,
}) {
  return Container(
    padding: const EdgeInsets.only(top: 20),
    decoration: BoxDecoration(
      color: data?.status == 1
          ? clrGreen00B.withOpacity(0.16)
          : (data?.status == 2 || data?.status == -1)
              ? clrRed.withOpacity(0.1)
              : (isElite
                  ? clrGreyE5e.withOpacity(0.12)
                  : clrGreyE5e.withOpacity(0.25)),
      border: Border.all(
          color: data?.status == 1
              ? clrGreen00B.withOpacity(0.2)
              : (data?.status == 2 || data?.status == -1)
                  ? clrRed.withOpacity(0.2)
                  : clrNeutralGrey999.withOpacity(0.16)),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labelWidgetLakuTrade(
          context,
          title: 'Nama Toko',
          subTitle: '${data?.item?.storeName}',
          isElite: isElite,
        ),
        Divider(
          color: clrNeutralGrey999.withOpacity(0.16),
          height: 37,
        ),
        _labelWidgetLakuTrade(
          context,
          title: t.lblAmountGram,
          amount: data?.goldAmount ?? '',
          currency: 'gram',
          isElite: isElite,
        ),
        const SizedBox(height: 22),
      ],
    ),
  );
}

Widget _labelWidgetLakuTrade(
  BuildContext context, {
  String? title,
  String? subTitle,
  String? amount,
  String? currency,
  bool isElite = false,
}) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title ?? '-',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isElite ? clrWhite : clrBackgroundBlack,
              ),
            ),
            if ((subTitle ?? '').isEmpty && (amount ?? '').isNotEmpty)
              RichText(
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                text: TextSpan(
                  text: amount ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                  children: [
                    TextSpan(
                      text: ' $currency',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      if ((subTitle ?? '').isNotEmpty) ...[
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subTitle ?? '-',
                textScaler:
                    TextScaler.linear(TextUtils.textScaleFactor(context)),
                style: TextStyle(
                  fontSize: 12,
                  color: isElite ? clrWhite : clrBackgroundBlack,
                ),
              ),
              if ((amount ?? '').isNotEmpty)
                RichText(
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  text: TextSpan(
                    text: amount ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                    children: [
                      TextSpan(
                        text: ' $currency',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ]
    ],
  );
}

Widget _detailWithdrawal(
  BuildContext context, {
  required AppLocalizations t,
  required DetailTransactionEntity? data,
  required bool isElite,
}) {
  return Container(
    padding: const EdgeInsets.only(top: 20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      color: data?.status == 1
          ? clrGreen00B.withOpacity(0.16)
          : (data?.status == 2 || data?.status == -1)
              ? clrRed.withOpacity(0.1)
              : (isElite
                  ? clrGreyE5e.withOpacity(0.12)
                  : clrGreyE5e.withOpacity(0.25)),
      border: Border.all(
          color: data?.status == 1
              ? clrGreen00B.withOpacity(0.2)
              : (data?.status == 2 || data?.status == -1)
                  ? clrRed.withOpacity(0.2)
                  : clrNeutralGrey999.withOpacity(0.16)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Image.network(
                    data?.bankLogo ?? '',
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Text('no image'),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  data?.bankName ?? '-',
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '${data?.accountName ?? ''} - ${data?.accountNumber ?? ''}',
            textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isElite ? clrWhite : clrBackgroundBlack,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Divider(
            height: 1,
            thickness: 1,
            color: clrNeutralGrey999.withOpacity(0.16),
          ),
        ),
        _amountWidget(
          context,
          title: 'Nominal Tarik Tunai',
          amount: data?.amount?.toIdr(),
          isElite: isElite,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Divider(
            height: 1,
            thickness: 1,
            color: clrNeutralGrey999.withOpacity(0.16),
          ),
        ),
        _amountWidget(
          context,
          title: t.lblFee,
          amount: data?.serviceFee?.toIdr(),
          isElite: isElite,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Divider(
            height: 1,
            thickness: 1,
            color: clrNeutralGrey999.withOpacity(0.16),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
          decoration: BoxDecoration(
            color: clrYellow.withOpacity(0.5),
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: _amountWidget(
            context,
            title: t.lblEarnedTotal,
            amount: data?.grossAmount?.toIdr(),
            isElite: isElite,
          ),
        ),
      ],
    ),
  );
}

Widget _detailTarikFisik(
  BuildContext context, {
  required AppLocalizations t,
  bool isElite = false,
  int? status,
  required DetailTransactionEntity? data,
}) =>
    Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: status == 5
            ? clrGreen00B.withOpacity(0.16)
            : (status == 2 || status == -1)
                ? clrRed.withOpacity(0.1)
                : (isElite
                    ? clrGreyE5e.withOpacity(0.12)
                    : clrGreyE5e.withOpacity(0.25)),
        border: Border.all(
            color: status == 5
                ? clrGreen00B.withOpacity(0.2)
                : (status == 2 || status == -1)
                    ? clrRed.withOpacity(0.2)
                    : (isElite
                        ? clrNeutralGrey999.withOpacity(0.16)
                        : clrNeutralGrey999.withOpacity(0.16))),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailsTransferWidget(
            context,
            title: t.lblPaymentMethod,
            subTitle: data?.payment?.name ?? '-',
            isElite: isElite,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 1,
              height: 33,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
          ),
          _amountWidget(
            context,
            title: 'Biaya Layanan',
            amount: double.tryParse(data?.serviceFee ?? '')?.toIdr() ?? '-',
            isElite: isElite,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 1,
              height: 33,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Biaya Sertifikat',
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isElite ? clrWhite : clrBackgroundBlack,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: List.generate(
                (data?.certificates?.length ?? 0),
                (index) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${data?.certificates?[index].goldBrand} - ${data?.certificates?[index].goldFragment} Gram',
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      style: TextStyle(
                        fontSize: 12,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                    ),
                    RichText(
                      textScaler:
                          TextScaler.linear(TextUtils.textScaleFactor(context)),
                      text: TextSpan(
                        text: 'Rp ',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                        children: [
                          TextSpan(
                            text: data?.certificates?[index].certificateCost
                                .toIdr(),
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
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: clrYellow.withOpacity(0.5),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.lblTotalPayment,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
                RichText(
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  text: TextSpan(
                    text: 'Rp ',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                    children: [
                      TextSpan(
                        text: data?.grossAmount.toIdr(),
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
          ),
        ],
      ),
    );

///
///

Widget _detailTransfer(
  BuildContext context, {
  required AppLocalizations t,
  bool isElite = false,
  int? status,
  required DetailTransactionEntity? transferChargeEntity,
}) =>
    Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: status == 1
            ? clrGreen00B.withOpacity(0.16)
            : (status == 2 || status == -1)
                ? clrRed.withOpacity(0.1)
                : (isElite
                    ? clrGreyE5e.withOpacity(0.12)
                    : clrGreyE5e.withOpacity(0.25)),
        border: Border.all(
            color: status == 1
                ? clrGreen00B.withOpacity(0.2)
                : (status == 2 || status == -1)
                    ? clrRed.withOpacity(0.2)
                    : (isElite
                        ? clrNeutralGrey999.withOpacity(0.16)
                        : clrNeutralGrey999.withOpacity(0.16))),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailsTransferWidget(
            context,
            title: transferChargeEntity?.isTransfered == true
                ? 'Pengirim'
                : 'Penerima',
            subTitle: transferChargeEntity?.accountName,
            isElite: isElite,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 1,
              height: 33,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
          ),
          _detailsTransferWidget(
            context,
            title: t.lblAccountNumber,
            subTitle: transferChargeEntity?.accountNumber,
            isElite: isElite,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              thickness: 1,
              height: 33,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
          ),
          _detailsTransferWidget(
            context,
            title: t.lblNews,
            subTitle: transferChargeEntity?.news ?? '-',
            isElite: isElite,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: clrYellow.withOpacity(0.5),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.lblTotalTransfer,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
                RichText(
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  text: TextSpan(
                    text:
                        double.tryParse(transferChargeEntity?.goldAmount ?? '0')
                            ?.toGold4Dec(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                    children: [
                      TextSpan(
                        text: ' gram',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isElite ? clrWhite : clrBackgroundBlack,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

Widget _detailsTransferWidget(BuildContext context,
    {String? title, String? subTitle, bool isElite = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '-',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 12,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subTitle ?? '-',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
        ),
      ],
    ),
  );
}

Widget _paymentMethodWidget(BuildContext context,
    {String? title, String? subTitle, bool isElite = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '-',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subTitle ?? '-',
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isElite ? clrWhite : clrBackgroundBlack,
          ),
        ),
      ],
    ),
  );
}

///
///

Widget _detailPayment(
  BuildContext context,
  AppLocalizations t,
  bool isElite,
  int? status,
  DetailTransactionEntity? detailTransaction, {
  required Function()? onNpwpFieldCLicked,
  bool isNpwpFieldShowed = false,
}) =>
    Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: status == 1
            ? clrGreen00B.withOpacity(0.16)
            : (status == 2 || status == -1)
                ? clrRed.withOpacity(0.1)
                : (isElite
                    ? clrGreyE5e.withOpacity(0.12)
                    : clrGreyE5e.withOpacity(0.25)),
        border: Border.all(
            color: status == 1
                ? clrGreen00B.withOpacity(0.2)
                : (status == 2 || status == -1)
                    ? clrRed.withOpacity(0.2)
                    : clrNeutralGrey999.withOpacity(0.16)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (detailTransaction?.type?.toLowerCase() != 'jual emas')
            _paymentMethodWidget(
              context,
              title: t.lblPaymentMethod,
              subTitle: detailTransaction?.payment?.name ?? '-',
              isElite: isElite,
            ),
          if (detailTransaction?.type?.toLowerCase() != 'jual emas')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 33,
                thickness: 1,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
            ),
          if (detailTransaction?.type?.toLowerCase() != 'jual emas')
            if (detailTransaction?.payment?.name?.toLowerCase() != 'saldo akun')
              _amountWidget(
                context,
                title: 'Biaya Layanan',
                amount: detailTransaction?.serviceFee.toIdr() ?? '-',
                isElite: isElite,
              ),
          if (detailTransaction?.type?.toLowerCase() != 'jual emas')
            if (detailTransaction?.payment?.name?.toLowerCase() != 'saldo akun')
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  height: 33,
                  thickness: 1,
                  color: clrNeutralGrey999.withOpacity(0.16),
                ),
              ),
          _amountWidget(
            context,
            titleWidget: RichText(
              textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
              text: TextSpan(
                  text: detailTransaction?.goldAmount,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                  children: [
                    const TextSpan(text: ' gr', style: TextStyle(fontSize: 10)),
                    const TextSpan(text: ' x', style: TextStyle(fontSize: 14)),
                    const TextSpan(text: ' Rp', style: TextStyle(fontSize: 10)),
                    (detailTransaction?.type?.toLowerCase() == 'jual emas')
                        ? TextSpan(
                            text:
                                ' ${double.tryParse(detailTransaction?.purchasePrice ?? '-')?.toIdr() ?? ''}')
                        : TextSpan(
                            text:
                                ' ${double.tryParse(detailTransaction?.sellingPrice ?? '-')?.toIdr() ?? ''}'),
                  ]),
            ),
            amount: double.tryParse(detailTransaction?.amount ?? '')?.toIdr(),
            isElite: isElite,
          ),
          if (detailTransaction?.type?.toLowerCase() != 'jual emas')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 33,
                thickness: 1,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
            ),
          // if (detailTransaction?.type?.toLowerCase() != 'jual emas')
          //   _amountWidget(
          //     title:
          //         '${t.lblTaxRateClause22},  (${detailTransaction?.percentageTax ?? '-'}%)',
          //     amount: double.tryParse(detailTransaction?.nominalTax ?? '')
          //             ?.toIdr() ??
          //         '-',
          //     isElite: isElite,
          //   ),
          // if (detailTransaction?.type?.toLowerCase() != 'jual emas')
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 20),
          //     child: Divider(
          //       height: 33,
          //       thickness: 1,
          //       color: clrNeutralGrey999.withOpacity(0.16),
          //     ),
          //   ),
          if (detailTransaction?.type?.toLowerCase() != 'jual emas')
            _amountWidget(
              context,
              title: t.lblTotalDiscount,
              amount:
                  double.tryParse(detailTransaction?.discount ?? '')?.toIdr() ??
                      '-',
              isElite: isElite,
            ),
          if (detailTransaction?.type?.toLowerCase() == 'beli emas')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                height: 33,
                thickness: 1,
                color: clrNeutralGrey999.withOpacity(0.16),
              ),
            ),
          if (detailTransaction?.type?.toLowerCase() == 'beli emas')
            _amountWidget(
              context,
              title: 'Pembulatan (Masuk Saldo Akun)',
              amount:
                  double.tryParse(detailTransaction?.rounding ?? '')?.toIdr() ??
                      '-',
              isElite: isElite,
            ),
          const SizedBox(height: 16),
          // if (detailTransaction?.type?.toLowerCase() != 'jual emas' &&
          //     isNpwpFieldShowed == true)
          //   GestureDetector(
          //     onTap: onNpwpFieldCLicked,
          //     child: Container(
          //       padding: const EdgeInsets.symmetric(
          //         horizontal: 20,
          //         vertical: 16,
          //       ),
          //       decoration: BoxDecoration(
          //         color: clrYellow.withOpacity(0.16),
          //       ),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Expanded(
          //               child: Text(
          //             t.lblFillYourNpwp('0.45%'),
          //             style: TextStyle(
          //               fontSize: 11,
          //               fontWeight: FontWeight.w500,
          //               color: isElite ? clrWhite : clrBackgroundBlack,
          //             ),
          //           )),
          //           Icon(
          //             Icons.keyboard_arrow_right,
          //             color: isElite ? clrWhite : null,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: clrYellow.withOpacity(0.5),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.lblTotalPayment,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
                RichText(
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  text: TextSpan(
                      text: 'Rp',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isElite ? clrWhite : clrBackgroundBlack,
                      ),
                      children: [
                        TextSpan(
                          text:
                              ' ${double.tryParse(detailTransaction?.grossAmount ?? '')?.toIdr() ?? '-'}',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );

Widget _detailElitePayment(
        BuildContext context,
        AppLocalizations t,
        bool isElite,
        int? status,
        DetailTransactionEntity? detailTransaction) =>
    Container(
      padding: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        color: status == 1
            ? clrGreen00B.withOpacity(0.16)
            : (status == 2 || status == -1)
                ? clrRed.withOpacity(0.1)
                : (isElite
                    ? clrGreyE5e.withOpacity(0.12)
                    : clrGreyE5e.withOpacity(0.25)),
        border: Border.all(
            color: status == 1
                ? clrGreen00B.withOpacity(0.2)
                : (status == 2 || status == -1)
                    ? clrRed.withOpacity(0.2)
                    : clrNeutralGrey999.withOpacity(0.16)),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _paymentMethodWidget(
            context,
            title: t.lblPaymentMethod,
            subTitle: detailTransaction?.paymentMethod ??
                detailTransaction?.elite?.paymentMethod,
            isElite: isElite,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(
              height: 33,
              thickness: 1,
              color: clrNeutralGrey999.withOpacity(0.16),
            ),
          ),
          _amountWidget(
            context,
            title: 'Biaya Layanan',
            amount: detailTransaction?.serviceFee.toIdr() ?? '-',
            isElite: isElite,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: clrYellow.withOpacity(0.5),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.lblTotalPayment,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                ),
                RichText(
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  text: TextSpan(
                    text: detailTransaction?.total ??
                        '${detailTransaction?.elite?.grammationPrice} gram',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isElite ? clrWhite : clrBackgroundBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
Widget _amountWidget(
  BuildContext context, {
  String? title,
  Widget? titleWidget,
  String? amount,
  bool isGram = false,
  bool isElite = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Row(
      children: [
        Expanded(
          child: title != null
              ? Text(
                  title,
                  textScaler:
                      TextScaler.linear(TextUtils.textScaleFactor(context)),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isElite ? clrWhite : clrBackgroundBlack,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: (titleWidget ?? const SizedBox()),
                ),
        ),
        RichText(
          textScaler: TextScaler.linear(TextUtils.textScaleFactor(context)),
          text: TextSpan(
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isElite ? clrWhite : clrBackgroundBlack,
              ),
              children: [
                if (isGram == false)
                  const TextSpan(
                    text: 'Rp ',
                    style: TextStyle(fontSize: 10),
                  ),
                TextSpan(
                  text: (amount ?? ''),
                  style: const TextStyle(fontSize: 14),
                ),
                if (isGram == true)
                  const TextSpan(
                    text: ' gr',
                    style: TextStyle(fontSize: 10),
                  ),
              ]),
        ),
      ],
    ),
  );
}

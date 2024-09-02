import 'package:equatable/equatable.dart';

import 'certificates_entity.dart';
import 'deposit_entity.dart';
import 'detail_payment_method_entity.dart';
import 'detail_transaction_item_entity.dart';
import 'elite_subs_entity.dart';
import 'shipment_entity.dart';

class DetailTransactionEntity extends Equatable {
  final bool? isTransfered;
  final int? id;
  final int? status;
  final double? expirationTime;
  final String? amount;
  final String? grossAmount;
  final String? discount;
  final String? rounding;
  final String? sellingPrice;
  final String? purchasePrice;
  final String? nominalTax;
  final String? goldAmount;
  final String? percentageTax;
  final String? serviceFee;
  final String? code;
  final String? type;
  final String? statusLabel;
  final String? accountName;
  final String? accountNumber;
  final String? news;
  final String? createdAt;
  final DetailPaymentMethodEntity? payment;
  final List<CertificatesEntity>? certificates;
  final ShipmentEntity? shipment;
  //
  final String? bankName;
  final String? bankLogo;
  //
  final int? packageMonth;
  final String? validUntil;
  final int? nominal;
  final String? total;
  final String? paymentMethod;
  final String? autoRenewalPaymentMethod;
  final String? statusName;
  final String? paymentExpiredAt;
  final DetailTransactionItemEntity? item;
  //
  final EliteSubsEntity? elite;
  //
  final DepositEntity? deposit;

  const DetailTransactionEntity({
    this.isTransfered,
    this.id,
    this.status,
    this.expirationTime,
    this.amount,
    this.grossAmount,
    this.discount,
    this.rounding,
    this.sellingPrice,
    this.purchasePrice,
    this.nominalTax,
    this.goldAmount,
    this.percentageTax,
    this.serviceFee,
    this.code,
    this.type,
    this.statusLabel,
    this.accountName,
    this.accountNumber,
    this.news,
    this.createdAt,
    this.payment,
    this.certificates,
    this.shipment,
    //
    this.bankName,
    this.bankLogo,
    //
    this.packageMonth,
    this.validUntil,
    this.nominal,
    this.total,
    this.paymentMethod,
    this.autoRenewalPaymentMethod,
    this.statusName,
    this.paymentExpiredAt,
    this.item,
    //
    this.elite,
    //
    this.deposit,
  });

  @override
  List<Object?> get props => [
        isTransfered,
        id,
        status,
        expirationTime,
        amount,
        discount,
        rounding,
        sellingPrice,
        purchasePrice,
        nominalTax,
        goldAmount,
        percentageTax,
        serviceFee,
        code,
        type,
        statusLabel,
        accountName,
        accountNumber,
        news,
        createdAt,
        payment,
        certificates,
        shipment,
        //
        bankName,
        bankLogo,
        //
        packageMonth,
        validUntil,
        nominal,
        total,
        paymentMethod,
        autoRenewalPaymentMethod,
        statusName,
        paymentExpiredAt,
        item,
        elite,
        //
        deposit,
      ];
}

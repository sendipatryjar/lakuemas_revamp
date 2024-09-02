import 'package:equatable/equatable.dart';

class EliteMeEntity extends Equatable {
  final bool? isAutoRenewal;
  final bool? isRequestCancel;
  final String? validUntil;
  final String? referralCode;
  final ReferralEntity? referral;
  final DiscountEntity? discount;

  const EliteMeEntity({
    this.isAutoRenewal,
    this.isRequestCancel,
    this.validUntil,
    this.referralCode,
    this.referral,
    this.discount,
  });

  @override
  List<Object?> get props => [
        isAutoRenewal,
        isRequestCancel,
        validUntil,
        referralCode,
        referral,
        discount,
      ];
}

class DiscountEntity extends Equatable {
  final GoldPurchaseEntity? goldPurchase;
  final GoldPurchaseEntity? referralVoucher;
  final int? total;

  const DiscountEntity({
    this.goldPurchase,
    this.referralVoucher,
    this.total,
  });

  @override
  List<Object?> get props => [goldPurchase, referralVoucher, total];
}

class GoldPurchaseEntity extends Equatable {
  final String? label;
  final int? qty;
  final int? total;

  const GoldPurchaseEntity({
    this.label,
    this.qty,
    this.total,
  });

  @override
  List<Object?> get props => [label, qty, total];
}

class ReferralEntity extends Equatable {
  final String? endDate;
  final List<ListReferralEntity>? list;
  final String? startDate;
  final String? text;
  final int? total;

  const ReferralEntity({
    this.endDate,
    this.list,
    this.startDate,
    this.text,
    this.total,
  });

  @override
  List<Object?> get props => [
        endDate,
        list,
        startDate,
        text,
        total,
      ];
}

class ListReferralEntity extends Equatable {
  final String? joinDate;
  final String? name;
  final int? nominal;
  final String? validUntil;
  //
  final String? createdAt;
  final int? isActive;

  const ListReferralEntity({
    this.joinDate,
    this.name,
    this.nominal,
    this.validUntil,
    //
    this.createdAt,
    this.isActive,
  });

  @override
  List<Object?> get props => [
        joinDate,
        name,
        nominal,
        validUntil,
        //
        createdAt,
        isActive,
      ];
}

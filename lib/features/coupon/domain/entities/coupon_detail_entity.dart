import 'package:equatable/equatable.dart';

class CouponDetailEntity extends Equatable {
  final String? couponName;
  final String? couponCode;
  final String? description;
  final String? tnc;
  final String? expiredDate;
  final String? imageUrl;
  final String? minimumAmount;
  final String? maximumDiscountNominal;
  final String? discountNominal;
  final String? discountPercentage;
  final String? discountGramation;

  const CouponDetailEntity({
    this.couponName,
    this.couponCode,
    this.description,
    this.tnc,
    this.expiredDate,
    this.imageUrl,
    this.minimumAmount,
    this.maximumDiscountNominal,
    this.discountNominal,
    this.discountPercentage,
    this.discountGramation,
  });

  @override
  List<Object?> get props => [
        couponName,
        couponCode,
        description,
        tnc,
        expiredDate,
        imageUrl,
        minimumAmount,
        maximumDiscountNominal,
        discountNominal,
        discountPercentage,
        discountGramation,
      ];
}

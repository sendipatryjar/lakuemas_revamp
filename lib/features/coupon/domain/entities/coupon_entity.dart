import 'package:equatable/equatable.dart';

class CouponEntity extends Equatable {
  final String? couponName;
  final String? couponCode;
  final String? couponNominal;
  final String? couponPercentage;
  final String? expiredDate;
  final String? imageUrl;

  const CouponEntity(
      {this.couponName,
      this.couponCode,
      this.couponNominal,
      this.couponPercentage,
      this.expiredDate,
      this.imageUrl});

  @override
  List<Object?> get props => [
        couponName,
        couponCode,
        couponNominal,
        couponPercentage,
        expiredDate,
        imageUrl
      ];
}

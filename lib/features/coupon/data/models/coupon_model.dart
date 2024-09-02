import '../../domain/entities/coupon_entity.dart';

class CouponModel extends CouponEntity {
  const CouponModel({
    String? couponName,
    String? couponCode,
    String? couponNominal,
    String? couponPercentage,
    String? expiredDate,
    String? imageUrl,
  }) : super(
          couponName: couponName,
          couponCode: couponCode,
          couponNominal: couponNominal,
          couponPercentage: couponPercentage,
          expiredDate: expiredDate,
          imageUrl: imageUrl,
        );

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
        couponName: json['coupon_name'],
        couponCode: json['coupon_code'],
        couponNominal: json['coupon_nominal'],
        couponPercentage: json['coupon_percentage'],
        expiredDate: json['expired_date'],
        imageUrl: json['image_url'],
      );

  Map<String, dynamic> toJson() => {
        'coupon_name': couponName,
        'coupon_code': couponCode,
        'coupon_nominal': couponNominal,
        'coupon_percentage': couponPercentage,
        'expired_date': expiredDate,
        'image_url': imageUrl,
      };
}

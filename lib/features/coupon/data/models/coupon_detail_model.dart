import '../../domain/entities/coupon_detail_entity.dart';

class CouponDetailModel extends CouponDetailEntity {
  const CouponDetailModel({
    String? couponName,
    String? couponCode,
    String? description,
    String? tnc,
    String? expiredDate,
    String? imageUrl,
    String? minimumAmount,
    String? maximumDiscountNominal,
    String? discountNominal,
    String? discountPercentage,
    String? discountGramation,
  }) : super(
          couponName: couponName,
          couponCode: couponCode,
          description: description,
          tnc: tnc,
          expiredDate: expiredDate,
          imageUrl: imageUrl,
          minimumAmount: minimumAmount,
          maximumDiscountNominal: maximumDiscountNominal,
          discountNominal: discountNominal,
          discountPercentage: discountPercentage,
          discountGramation: discountGramation,
        );

  factory CouponDetailModel.fromJson(Map<String, dynamic> json) =>
      CouponDetailModel(
        couponName: json['coupon_name'],
        couponCode: json['coupon_code'],
        description: json['description'],
        tnc: json['tnc'],
        expiredDate: json['expired_date'],
        imageUrl: json['image_url'],
        minimumAmount: json['minimum_amount'],
        maximumDiscountNominal: json['maximum_discount_nominal'],
        discountNominal: json['discount_nominal'],
        discountPercentage: json['discount_percentage'],
        discountGramation: json['discount_grammation'],
      );

  Map<String, dynamic> toJson() => {
        'coupon_name': couponName,
        'coupon_code': couponCode,
        'description': description,
        'tnc': tnc,
        'expired_date': expiredDate,
        'image_url': imageUrl,
        'minimum_amount': minimumAmount,
        'maximum_discount_nominal': maximumDiscountNominal,
        'discount_nominal': discountNominal,
        'discount_percentage': discountPercentage,
        'discount_grammation': discountGramation,
      };
}

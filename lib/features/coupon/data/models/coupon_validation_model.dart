import 'package:equatable/equatable.dart';

import 'coupon_detail_model.dart';

class CouponValidationModel extends Equatable {
  final bool? isValid;
  final CouponDetailModel? couponDetailModel;

  const CouponValidationModel({this.isValid, this.couponDetailModel});

  @override
  List<Object?> get props => [isValid, couponDetailModel];

  factory CouponValidationModel.fromJson(Map<String, dynamic> json) =>
      CouponValidationModel(
        isValid: json['is_valid'],
        couponDetailModel: json['coupon_detail'] != null
            ? CouponDetailModel.fromJson(json['coupon_detail'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'is_valid': isValid,
        'coupon_detail': couponDetailModel?.toJson(),
      };
}

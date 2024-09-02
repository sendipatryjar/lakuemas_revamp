import '../../domain/entities/voucher_referral_entity.dart';

class VoucherReferralModel extends VoucherReferralEntity {
  const VoucherReferralModel({
    String? validUntil,
    String? createdAt,
    String? voucherCode,
    String? status,
    String? bonusReferral,
  }) : super(
          validUntil: validUntil,
          createdAt: createdAt,
          voucherCode: voucherCode,
          status: status,
          bonusReferral: bonusReferral,
        );

  static VoucherReferralModel fromJson(Map<String, dynamic> json) =>
      VoucherReferralModel(
        validUntil: json["valid_until"],
        createdAt: json["created_at"],
        voucherCode: json["voucher_code"],
        status: json["status"],
        bonusReferral: json["bonus_referral"],
      );

  Map<String, dynamic> toJson() => {
        "valid_until": validUntil,
        "created_at": createdAt,
        "voucher_code": voucherCode,
        "status": status,
        "bonus_referral": bonusReferral,
      };
}

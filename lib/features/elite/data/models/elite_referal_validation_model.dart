import '../../domain/entities/elite_referal_validation_entity.dart';

class EliteReferalValidationModel extends EliteReferalValidaitonEntity {
  const EliteReferalValidationModel({
    bool? isValid,
    String? referalCode,
    String? referalName,
  }) : super(
          isValid: isValid,
          referalCode: referalCode,
          referalName: referalName,
        );

  static EliteReferalValidationModel fromJson(Map<String, dynamic> json) =>
      EliteReferalValidationModel(
        isValid: json["is_valid"],
        referalCode: json["referral_code"],
        referalName: json["referral_name"],
      );

  Map<String, dynamic> toJson() => {
        "is_valid": isValid,
        "referral_code": referalCode,
        "referral_name": referalName,
      };
}

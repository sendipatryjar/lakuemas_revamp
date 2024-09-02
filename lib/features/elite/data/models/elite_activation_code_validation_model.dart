import '../../domain/entities/elite_activation_code_validation_entity.dart';

class EliteActivationCodeValidationModel
    extends EliteActivationCodeValidationEntity {
  const EliteActivationCodeValidationModel({
    bool? isValid,
    int? extendPeriod,
    int? voucherId,
    int? nominal,
    double? grammation,
    String? voucherCode,
  }) : super(
          isValid: isValid,
          extendPeriod: extendPeriod,
          voucherId: voucherId,
          nominal: nominal,
          grammation: grammation,
          voucherCode: voucherCode,
        );

  static EliteActivationCodeValidationModel fromJson(
          Map<String, dynamic> json) =>
      EliteActivationCodeValidationModel(
        isValid: json["is_valid"],
        extendPeriod: json["extend_period"],
        voucherId: json["voucher_id"],
        nominal: json["nominal"],
        grammation: json["grammation"]?.toDouble(),
        voucherCode: json["voucher_code"],
      );

  Map<String, dynamic> toJson() => {
        "is_valid": isValid,
        "extend_period": extendPeriod,
        "voucher_id": voucherId,
        "nominal": nominal,
        "grammation": grammation,
        "voucher_code": voucherCode,
      };
}

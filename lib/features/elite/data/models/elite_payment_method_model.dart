import '../../domain/entities/elite_payment_method_entity.dart';

class ElitePaymentMethodModel extends ElitePaymentMethodEntity {
  const ElitePaymentMethodModel({
    int? id,
    double? nominalBalance,
    double? grammationBalance,
    double? nominalServiceFee,
    double? percentageServiceFee,
    String? label,
  }) : super(
          id: id,
          nominalBalance: nominalBalance,
          grammationBalance: grammationBalance,
          nominalServiceFee: nominalServiceFee,
          percentageServiceFee: percentageServiceFee,
          label: label,
        );

  static ElitePaymentMethodModel fromJson(Map<String, dynamic> json) {
    return ElitePaymentMethodModel(
      id: json["id"],
      nominalBalance: json["nominal_balance"].toDouble(),
      grammationBalance: json["grammation_balance"].toDouble(),
      nominalServiceFee: json["nominal_service_fee"].toDouble(),
      percentageServiceFee: json["percentage_service_fee"].toDouble(),
      label: json["label"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nominal_balance": nominalBalance,
        "grammation_balance": grammationBalance,
        "nominal_service_fee": nominalServiceFee,
        "percentage_service_fee": percentageServiceFee,
        "label": label,
      };
}

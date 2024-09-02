import '../../domain/entities/payment_method_entity.dart';

class PaymentMethodModel extends PaymentMethodEntity {
  const PaymentMethodModel({
    int? id,
    int? nominalServiceFee,
    double? percentageServiceFee,
    String? name,
    String? type,
    String? imageUrl,
  }) : super(
          id: id,
          nominalServiceFee: nominalServiceFee,
          percentageServiceFee: percentageServiceFee,
          name: name,
          type: type,
          imageUrl: imageUrl,
        );

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      PaymentMethodModel(
        id: json['id'],
        nominalServiceFee: json['nominal_service_fee'],
        percentageServiceFee: (json['percentage_service_fee'] is int)
            ? (json['percentage_service_fee'] as int).toDouble()
            : json['percentage_service_fee'],
        name: json['name'],
        type: json['type'],
        imageUrl: json['image_url'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nominal_service_fee': nominalServiceFee,
        'percentage_service_fee': percentageServiceFee,
        'name': name,
        'type': type,
        'image_url': imageUrl,
      };
}

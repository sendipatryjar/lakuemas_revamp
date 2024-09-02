import '../../domain/entities/detail_payment_method_entity.dart';

class DetailPaymentMethodActionModel extends DetailPaymentMethodActionEntity {
  const DetailPaymentMethodActionModel({
    String? name,
    String? method,
    String? url,
  }) : super(
          name: name,
          method: method,
          url: url,
        );

  factory DetailPaymentMethodActionModel.fromJson(Map<String, dynamic> json) =>
      DetailPaymentMethodActionModel(
          name: json['name'], method: json['method'], url: json['url']);

  Map<String, dynamic> toJson() => {
        'name': name,
        'method': method,
        'url': url,
      };
}

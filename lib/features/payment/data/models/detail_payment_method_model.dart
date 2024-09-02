import '../../domain/entities/detail_payment_method_entity.dart';
import 'detail_payment_method_action_model.dart';

class DetailPaymentMethodModel extends DetailPaymentMethodEntity {
  const DetailPaymentMethodModel({
    int? id,
    String? name,
    String? imageUrl,
    String? vaNo,
    String? billerCode,
    String? paymentCode,
    String? instruction,
    List<DetailPaymentMethodActionEntity>? actions,
  }) : super(
          id: id,
          name: name,
          imageUrl: imageUrl,
          vaNo: vaNo,
          billerCode: billerCode,
          paymentCode: paymentCode,
          instruction: instruction,
          actions: actions ?? const [],
        );

  factory DetailPaymentMethodModel.fromJson(Map<String, dynamic> json) =>
      DetailPaymentMethodModel(
        id: json['id'],
        name: json['name'],
        imageUrl: json['image_url'],
        vaNo: json['va_no'],
        billerCode: json['biller_code'],
        paymentCode: json['payment_code'],
        instruction: json['instruction'],
        actions: json['actions'] != null
            ? List<DetailPaymentMethodActionModel>.from(json['actions']
                .cast<Map<String, dynamic>>()
                .map((itemsJson) =>
                    DetailPaymentMethodActionModel.fromJson(itemsJson)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image_url': imageUrl,
        'va_no': vaNo,
        'biller_code': billerCode,
        'payment_code': paymentCode,
        'instruction': instruction,
        'actions': actions.map((e) => DetailPaymentMethodActionModel(
              name: e.name,
              method: e.method,
              url: e.url,
            ).toJson()),
      };
}

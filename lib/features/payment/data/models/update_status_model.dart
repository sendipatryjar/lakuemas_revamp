import '../../domain/entities/update_status_entity.dart';

class UpdateStatusModel extends UpdateStatusEntity {
  const UpdateStatusModel({
    int? id,
    int? customerId,
    int? status,
    String? code,
    String? type,
    String? statusLabel,
  }) : super(
          id: id,
          customerId: customerId,
          status: status,
          code: code,
          type: type,
          statusLabel: statusLabel,
        );

  factory UpdateStatusModel.fromJson(Map<String, dynamic> json) =>
      UpdateStatusModel(
        id: json['id'],
        customerId: json['customer_id'],
        status: json['status'],
        code: json['code'],
        type: json['type'],
        statusLabel: json['status_label'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'customer_id': customerId,
        'status': status,
        'code': code,
        'type': type,
        'status_label': statusLabel,
      };
}

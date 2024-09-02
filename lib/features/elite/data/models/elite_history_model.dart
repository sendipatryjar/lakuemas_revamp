import '../../domain/entities/elite_history_entity.dart';

class EliteHistoryModel extends EliteHistoryEntity {
  const EliteHistoryModel({
    int? packageMonth,
    int? status,
    String? code,
    String? createdAt,
    String? nominal,
    String? paymentMethod,
  }) : super(
          packageMonth: packageMonth,
          status: status,
          code: code,
          createdAt: createdAt,
          nominal: nominal,
          paymentMethod: paymentMethod,
        );

  static EliteHistoryModel fromJson(Map<String, dynamic> json) =>
      EliteHistoryModel(
        packageMonth: json["package_month"],
        status: json["status"],
        code: json["code"],
        createdAt: json["created_at"],
        nominal: json["nominal"],
        paymentMethod: json["payment_method"],
      );

  Map<String, dynamic> toJson() => {
        "package_month": packageMonth,
        "status": status,
        "code": code,
        "created_at": createdAt,
        "nominal": nominal,
        "payment_method": paymentMethod,
      };
}

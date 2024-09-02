import '../../domain/entities/store_brand_entity.dart';

class StoreBrandModel extends StoreBrandEntity {
  const StoreBrandModel({
    int? id,
    int? customerId,
    String? brand,
    String? createdAt,
    String? updatedAt,
  }) : super(
          id: id,
          customerId: customerId,
          brand: brand,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  static StoreBrandModel fromJson(Map<String, dynamic> json) {
    return StoreBrandModel(
      id: json["id"],
      customerId: json["customer_id"],
      brand: json["brand"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "brand": brand,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

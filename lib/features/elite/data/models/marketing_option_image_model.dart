import '../../domain/entities/marketing_option_image_entity.dart';

class MarketingOptionImageModel extends MarketingOptionImageEntity {
  const MarketingOptionImageModel({
    int? isActive,
    int? id,
    int? eliteMarketingConfigId,
    int? sequence,
    String? image,
    String? createdAt,
    String? updatedAt,
  }) : super(
          isActive: isActive,
          id: id,
          eliteMarketingConfigId: eliteMarketingConfigId,
          sequence: sequence,
          image: image,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  static MarketingOptionImageModel fromJson(Map<String, dynamic> json) {
    return MarketingOptionImageModel(
      isActive: json["is_active"],
      id: json["id"],
      eliteMarketingConfigId: json["elite_marketing_config_id"],
      sequence: json["sequence"],
      image: json["image"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }

  Map<String, dynamic> toJson() => {
        "is_active": isActive,
        "id": id,
        "elite_marketing_config_id": eliteMarketingConfigId,
        "sequence": sequence,
        "image": image,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

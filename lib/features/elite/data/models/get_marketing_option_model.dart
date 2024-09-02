import '../../domain/entities/get_marketing_option_entity.dart';
import 'marketing_option_image_model.dart';

class GetMarketingOptionModel extends GetMarketingOptionEntity {
  const GetMarketingOptionModel({
    int? id,
    String? name,
    String? description,
    String? type,
    List<MarketingOptionImageModel>? marketingOptionImageModel,
  }) : super(
          id: id,
          name: name,
          description: description,
          type: type,
          marketingOptionImageEntity: marketingOptionImageModel,
        );

  static GetMarketingOptionModel fromJson(Map<String, dynamic> json) {
    List<MarketingOptionImageModel>? marketingOptionImageEntity;
    if (json['elite_marketing_config_image'] != null) {
      marketingOptionImageEntity = <MarketingOptionImageModel>[];
      json['elite_marketing_config_image'].forEach((v) {
        marketingOptionImageEntity!.add(MarketingOptionImageModel.fromJson(v));
      });
    }

    return GetMarketingOptionModel(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      type: json["type"],
      marketingOptionImageModel: marketingOptionImageEntity,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["description"] = description;
    data["type"] = type;
    if (marketingOptionImageEntity != null) {
      data["elite_marketing_config_image"] = marketingOptionImageEntity!.map(
        (v) => MarketingOptionImageModel(
          isActive: v.isActive,
          id: v.id,
          eliteMarketingConfigId: v.eliteMarketingConfigId,
          sequence: v.sequence,
          image: v.image,
          createdAt: v.createdAt,
          updatedAt: v.updatedAt,
        ),
      );
    }

    return data;
  }
}

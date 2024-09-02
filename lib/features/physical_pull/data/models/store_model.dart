import 'store_brand_model.dart';

import '../../domain/entities/store_entity.dart';

class StoreModel extends StoreEntity {
  const StoreModel({
    int? id,
    int? storeBrandId,
    int? provinceId,
    int? locationCityId,
    int? isActive,
    int? isButikemas,
    int? storeAutoSell,
    String? name,
    String? storeCode,
    String? long,
    String? lat,
    String? address,
    String? createdAt,
    String? updatedAt,
    StoreBrandModel? storeBrand,
  }) : super(
          id: id,
          storeBrandId: storeBrandId,
          provinceId: provinceId,
          locationCityId: locationCityId,
          isActive: isActive,
          isButikemas: isButikemas,
          storeAutoSell: storeAutoSell,
          name: name,
          storeCode: storeCode,
          long: long,
          lat: lat,
          address: address,
          createdAt: createdAt,
          updatedAt: updatedAt,
          storeBrand: storeBrand,
        );

  static StoreModel fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json["id"],
      storeBrandId: json["store_brand_id"],
      provinceId: json["province_id"],
      locationCityId: json["location_city_id"],
      isActive: json["is_active"],
      isButikemas: json["is_butikemas"],
      storeAutoSell: json["store_auto_sell"],
      name: json["name"],
      storeCode: json["store_code"],
      long: json["long"],
      lat: json["lat"],
      address: json["address"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      storeBrand: json["store_brand"] == null
          ? null
          : StoreBrandModel.fromJson(json["store_brand"]),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["store_brand_id"] = storeBrandId;
    data["province_id"] = provinceId;
    data["location_city_id"] = locationCityId;
    data["is_active"] = isActive;
    data["is_butikemas"] = isButikemas;
    data["store_auto_sell"] = storeAutoSell;
    data["name"] = name;
    data["store_code"] = storeCode;
    data["long"] = long;
    data["lat"] = lat;
    data["address"] = address;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["store_brand"] = storeBrand;

    return data;
  }
}

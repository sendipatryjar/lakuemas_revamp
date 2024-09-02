import '../../../../features/profile/data/models/get_province_model.dart';

import '../../domain/entities/city_entity.dart';

class GetCityModel extends CityEntity {
  const GetCityModel({
    int? id,
    String? city,
    String? name,
    int? provinceId,
    String? createdAt,
    String? updatedAt,
    GetProvinceModel? province,
  }) : super(
          id: id,
          city: city,
          name: name,
          provinceId: provinceId,
          province: province,
        );

  static GetCityModel fromJson(Map<String, dynamic> json) => GetCityModel(
        id: json['id'],
        city: json['city'],
        name: json['name'],
        provinceId: json['province_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        province: json["province"] == null
            ? null
            : GetProvinceModel.fromJson(json["province"]),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["city"] = city;
    data["name"] = name;
    data["province_id"] = provinceId;
    data["province"] = province;
    // 'id': id,
    // 'city': city,
    // 'province_id': provinceId,
    // // 'created_at': createdAt,
    // // 'updated_at': updatedAt,
    // 'province': province

    return data;
  }
}

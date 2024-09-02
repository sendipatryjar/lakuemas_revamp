import '../../../../features/profile/domain/entities/detail_district_entity.dart';

import 'get_city_model.dart';

class DetailDistrictModel extends DetailDistrictEntity {
  const DetailDistrictModel({
    int? id,
    String? name,
    int? cityId,
    GetCityModel? city,
  }) : super(
          id: id,
          name: name,
          cityId: cityId,
          city: city,
        );

  static DetailDistrictModel fromJson(Map<String, dynamic> json) =>
      DetailDistrictModel(
        id: json["id"],
        name: json["name"],
        cityId: json["city_id"],
        city: json["city"] == null ? null : GetCityModel.fromJson(json["city"]),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["name"] = name;
    data["city_id"] = cityId;
    data["city"] = city;

    return data;
  }
}

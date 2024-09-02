import '../../domain/entities/district_entity.dart';

class GetDistrictModel extends DistrictEntity {
  const GetDistrictModel({
    int? id,
    String? name,
    int? cityId,
    String? createdAt,
    String? updatedAt,
  }) : super(
          id: id,
          name: name,
          cityId: cityId,
        );

  static GetDistrictModel fromJson(Map<String, dynamic> json) =>
      GetDistrictModel(
        id: json['id'],
        name: json['name'],
        cityId: json['city_id'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'city_id': cityId,
        // 'created_at': createdAt,
        // 'updated_at': updatedAt,
      };
}

import '../../domain/entities/province_entity.dart';

class GetProvinceModel extends ProvinceEntity {
  const GetProvinceModel({
    int? id,
    String? name,
    String? createdAt,
    String? updatedAt,
  }) : super(
          id: id,
          name: name,
        );

  static GetProvinceModel fromJson(Map<String, dynamic> json) =>
      GetProvinceModel(
        id: json['id'],
        name: json['name'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        // 'created_at': createdAt,
        // 'updated_at': updatedAt,
      };
}

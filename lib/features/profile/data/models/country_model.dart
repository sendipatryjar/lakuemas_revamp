import '../../domain/entities/country_entity.dart';

class CountryModel extends CountryEntity {
  const CountryModel({
    int? id,
    String? code,
    String? name,
  }) : super(
          id: id,
          code: code,
          name: name,
        );

  static CountryModel fromJson(Map<String, dynamic> json) => CountryModel(
        id: json['id'],
        code: json['city'],
        name: json['name'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["code"] = code;
    data["name"] = name;

    return data;
  }
}

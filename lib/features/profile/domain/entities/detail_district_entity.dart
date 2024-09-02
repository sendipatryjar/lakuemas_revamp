import 'package:equatable/equatable.dart';

import 'city_entity.dart';
import 'province_entity.dart';

class DetailDistrictEntity extends Equatable {
  final int? id;
  final String? name;
  final int? cityId;
  final CityEntity? city;
  final ProvinceEntity? province;

  const DetailDistrictEntity({
    this.id,
    this.name,
    this.cityId,
    this.city,
    this.province,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        cityId,
        city,
        province,
      ];
}

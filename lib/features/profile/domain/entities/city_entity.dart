import 'package:equatable/equatable.dart';
import '../../../../features/profile/domain/entities/province_entity.dart';

class CityEntity extends Equatable {
  final int? id;
  final String? city;
  final String? name;
  final int? provinceId;
  final ProvinceEntity? province;

  const CityEntity({
    this.id,
    this.city,
    this.name,
    this.provinceId,
    this.province,
  });

  @override
  List<Object?> get props => [id, city, name, provinceId, province];
}

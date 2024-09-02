import 'package:equatable/equatable.dart';
import '../../../../features/physical_pull/domain/entities/store_brand_entity.dart';

class StoreEntity extends Equatable {
  final int? id;
  final int? storeBrandId;
  final int? provinceId;
  final int? locationCityId;
  final int? isActive;
  final int? isButikemas;
  final int? storeAutoSell;
  final String? name;
  final String? storeCode;
  final String? long;
  final String? lat;
  final String? address;
  final String? createdAt;
  final String? updatedAt;
  final StoreBrandEntity? storeBrand;

  const StoreEntity({
    this.id,
    this.storeBrandId,
    this.provinceId,
    this.locationCityId,
    this.isActive,
    this.isButikemas,
    this.storeAutoSell,
    this.name,
    this.storeCode,
    this.long,
    this.lat,
    this.address,
    this.createdAt,
    this.updatedAt,
    this.storeBrand,
  });

  @override
  List<Object?> get props => [
        [
          id,
          storeBrandId,
          provinceId,
          locationCityId,
          isActive,
          isButikemas,
          storeAutoSell,
          name,
          storeCode,
          long,
          lat,
          address,
          createdAt,
          updatedAt,
          storeBrand,
        ],
      ];
}

import 'package:equatable/equatable.dart';

import 'marketing_option_image_entity.dart';

class GetMarketingOptionEntity extends Equatable {
  final int? id;
  final String? name;
  final String? description;
  final String? type;
  final List<MarketingOptionImageEntity>? marketingOptionImageEntity;

  const GetMarketingOptionEntity({
    this.id,
    this.name,
    this.description,
    this.type,
    this.marketingOptionImageEntity,
  });

  @override
  List<Object> get props => [
        [id, name, description, type, marketingOptionImageEntity]
      ];
}

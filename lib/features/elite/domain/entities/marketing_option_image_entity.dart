import 'package:equatable/equatable.dart';

class MarketingOptionImageEntity extends Equatable {
  final int? isActive;
  final int? id;
  final int? eliteMarketingConfigId;
  final int? sequence;
  final String? image;
  final String? createdAt;
  final String? updatedAt;

  const MarketingOptionImageEntity({
    this.isActive,
    this.id,
    this.eliteMarketingConfigId,
    this.sequence,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object> get props => [
        [
          isActive,
          id,
          eliteMarketingConfigId,
          sequence,
          image,
          createdAt,
          updatedAt,
        ]
      ];
}

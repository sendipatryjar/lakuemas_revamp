import 'package:equatable/equatable.dart';

class SubscriptionPackagesEntity extends Equatable {
  final int? id;
  final double? nominalPrice;
  final double? grammationPrice;
  final double? nominalPriceDisc;
  final double? grammationPriceDisc;
  final String? packageType;

  const SubscriptionPackagesEntity({
    this.id,
    this.nominalPrice,
    this.grammationPrice,
    this.nominalPriceDisc,
    this.grammationPriceDisc,
    this.packageType,
  });

  @override
  List<Object> get props => [
        [
          id,
          nominalPrice,
          grammationPrice,
          nominalPriceDisc,
          grammationPriceDisc,
          packageType,
        ]
      ];
}

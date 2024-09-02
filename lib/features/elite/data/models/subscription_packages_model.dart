import '../../domain/entities/subscription_packages_entity.dart';

class SubscriptionPackagesModel extends SubscriptionPackagesEntity {
  const SubscriptionPackagesModel({
    int? id,
    double? nominalPrice,
    double? grammationPrice,
    double? nominalPriceDisc,
    double? grammationPriceDisc,
    String? packageType,
  }) : super(
          id: id,
          nominalPrice: nominalPrice,
          grammationPrice: grammationPrice,
          nominalPriceDisc: nominalPriceDisc,
          grammationPriceDisc: grammationPriceDisc,
          packageType: packageType,
        );

  static SubscriptionPackagesModel fromJson(Map<String, dynamic> json) {
    return SubscriptionPackagesModel(
      id: json["id"],
      nominalPrice: json["nominal_price"].toDouble(),
      grammationPrice: json["grammation_price"].toDouble(),
      nominalPriceDisc: json["nominal_price_discount"].toDouble(),
      grammationPriceDisc: json["grammation_price_discount"].toDouble(),
      packageType: json["package_type"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nominal_price": nominalPrice,
        "grammation_price": grammationPrice,
        "nominal_price_discount": nominalPriceDisc,
        "grammation_price_discount": grammationPriceDisc,
        "package_type": packageType,
      };
}

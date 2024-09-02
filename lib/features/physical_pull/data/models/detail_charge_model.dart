import '../../../../features/physical_pull/domain/entities/detail_charge_entity.dart';

class DetailChargeModel extends DetailChargeEntity {
  const DetailChargeModel({
    double? goldFragment,
    int? qty,
    String? goldBrand,
    String? totalCertificateCost,
  }) : super(
          goldFragment: goldFragment,
          qty: qty,
          goldBrand: goldBrand,
          totalCertificateCost: totalCertificateCost,
        );

  static DetailChargeModel fromJson(Map<String, dynamic> json) {
    return DetailChargeModel(
      goldFragment: json["gold_fragment"].toDouble(),
      qty: json["qty"],
      goldBrand: json["gold_brand"],
      totalCertificateCost: json["total_certificate_cost"],
    );
  }

  Map<String, dynamic> toJson() => {
        "gold_fragment": goldFragment,
        "qty": qty,
        "gold_brand": goldBrand,
        "total_certificate_cost": totalCertificateCost,
      };
}

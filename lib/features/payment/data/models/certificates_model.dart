import '../../domain/entities/certificates_entity.dart';

class CertificatesModel extends CertificatesEntity {
  const CertificatesModel({
    int? goldFragment,
    String? goldBrand,
    String? certificateCost,
  }) : super(
          goldFragment: goldFragment,
          goldBrand: goldBrand,
          certificateCost: certificateCost,
        );

  factory CertificatesModel.fromJson(Map<String, dynamic> json) =>
      CertificatesModel(
        goldFragment: json["gold_fragment"],
        goldBrand: json["gold_brand"],
        certificateCost: json["certificate_cost"],
      );

  Map<String, dynamic> toJson() => {
        "gold_fragment": goldFragment,
        "gold_brand": goldBrand,
        "certificate_cost": certificateCost,
      };
}

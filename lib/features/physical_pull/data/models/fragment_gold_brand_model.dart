import '../../domain/entities/fragment_entity.dart';

class FragmentGoldBrandModel extends FragmentEntity {
  const FragmentGoldBrandModel({
    int? id,
    int? goldBrandId,
    double? fragment,
    int? certificatePrice,
  }) : super(
          id: id,
          goldBrandId: goldBrandId,
          fragment: fragment,
          certificatePrice: certificatePrice,
        );

  static FragmentGoldBrandModel fromJson(Map<String, dynamic> json) {
    return FragmentGoldBrandModel(
      id: json["id"],
      goldBrandId: json["gold_brand_id"],
      fragment: json["fragment"].toDouble(),
      certificatePrice: json["certificate_price"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "gold_brand_id": goldBrandId,
        "fragment": fragment,
        "certificate_price": certificatePrice,
      };
}

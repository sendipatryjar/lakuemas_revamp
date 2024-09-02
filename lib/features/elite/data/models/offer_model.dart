import '../../domain/entities/offer_entity.dart';

class OfferModel extends OfferEntity {
  const OfferModel({
    int? id,
    String? image,
    String? title,
    //
    String? redeemDate,
    String? validUntil,
  }) : super(
          id: id,
          image: image,
          title: title,
          redeemDate: redeemDate,
          validUntil: validUntil,
        );

  static OfferModel fromJson(Map<String, dynamic> json) => OfferModel(
        id: json["id"],
        image: json["image"],
        title: json["title"],
        //
        redeemDate: json["redeem_date"],
        validUntil: json["valid_until"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "title": title,
        //
        "redeem_date": redeemDate,
        "valid_until": validUntil,
      };
}

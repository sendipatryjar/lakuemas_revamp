import '../../domain/entities/detail_offer_entity.dart';

class DetailOfferModel extends DetailOfferEntity {
  const DetailOfferModel({
    int? id,
    String? image,
    String? title,
    String? description,
    bool? isAllowedRedeem,
    String? voucherCode,
    String? refreshTime,
    String? dailyRefresh,
    int? voucherAvailable,
    //
    String? redeemDate,
    String? validUntil,
  }) : super(
          id: id,
          image: image,
          title: title,
          description: description,
          isAllowedRedeem: isAllowedRedeem,
          voucherCode: voucherCode,
          refreshTime: refreshTime,
          dailyRefresh: dailyRefresh,
          voucherAvailable: voucherAvailable,
          //
          redeemDate: redeemDate,
          validUntil: validUntil,
        );

  static DetailOfferModel fromJson(Map<String, dynamic> json) =>
      DetailOfferModel(
        id: json["id"],
        image: json["image"],
        title: json["title"],
        description: json["description"],
        isAllowedRedeem: json["is_allowed_redeem"],
        voucherCode: json["voucher_code"],
        refreshTime: json["refresh_time"],
        dailyRefresh: json["daily_refresh"],
        voucherAvailable: json["voucher_available"],
        //
        redeemDate: json["redeem_date"],
        validUntil: json["valid_until"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "title": title,
        "description": description,
        "is_allowed_redeem": isAllowedRedeem,
        "voucher_code": voucherCode,
        "refresh_time": refreshTime,
        "daily_refresh": dailyRefresh,
        "voucher_available": voucherAvailable,
        //
        "redeem_date": redeemDate,
        "valid_until": validUntil
      };
}

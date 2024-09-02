import '../../domain/entities/elite_me_entity.dart';

class EliteMeModel extends EliteMeEntity {
  const EliteMeModel({
    bool? isAutoRenewal,
    bool? isRequestCancel,
    String? validUntil,
    String? referralCode,
    Referral? referral,
    Discount? discount,
  }) : super(
          isAutoRenewal: isAutoRenewal,
          isRequestCancel: isRequestCancel,
          validUntil: validUntil,
          referralCode: referralCode,
          referral: referral,
          discount: discount,
        );

  static EliteMeModel fromJson(Map<String, dynamic> json) => EliteMeModel(
        isAutoRenewal: json["is_auto_renewal"],
        isRequestCancel: json["is_request_cancel"],
        validUntil: json["valid_until"],
        referralCode: json["referral_code"],
        referral: json["referral"] == null
            ? null
            : Referral.fromJson(json["referral"]),
        discount: json["discount"] == null
            ? null
            : Discount.fromJson(json["discount"]),
      );

  Map<String, dynamic> toJson() => {
        "is_auto_renewal": isAutoRenewal,
        "is_request_cancel": isRequestCancel,
        "valid_until": validUntil,
        "referral_code": referralCode,
        "referral": referral,
        "discount": discount,
      };
}

class Discount extends DiscountEntity {
  const Discount({
    GoldPurchase? goldPurchase,
    GoldPurchase? referralVoucher,
    int? total,
  }) : super(
          goldPurchase: goldPurchase,
          referralVoucher: referralVoucher,
          total: total,
        );

  static Discount fromJson(Map<String, dynamic> json) => Discount(
        goldPurchase: json["gold_purchase"] == null
            ? null
            : GoldPurchase.fromJson(json["gold_purchase"]),
        referralVoucher: json["referral_voucher"] == null
            ? null
            : GoldPurchase.fromJson(json["referral_voucher"]),
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "gold_purchase": goldPurchase,
        "referral_voucher": referralVoucher,
        "total": total,
      };
}

class GoldPurchase extends GoldPurchaseEntity {
  const GoldPurchase({
    String? label,
    int? qty,
    int? total,
  }) : super(
          label: label,
          qty: qty,
          total: total,
        );

  static GoldPurchase fromJson(Map<String, dynamic> json) => GoldPurchase(
        label: json["label"],
        qty: json["qty"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "label": label,
        "qty": qty,
        "total": total,
      };
}

class Referral extends ReferralEntity {
  const Referral({
    String? endDate,
    List<ListReferralEntity>? list,
    String? startDate,
    String? text,
    int? total,
  }) : super(
          endDate: endDate,
          list: list,
          startDate: startDate,
          text: text,
          total: total,
        );

  static Referral fromJson(Map<String, dynamic> json) => Referral(
        endDate: json["end_date"],
        list: json["list"] == null
            ? []
            : List<ListReferral>.from(
                json["list"]!.map((x) => ListReferral.fromJson(x))),
        startDate: json["start_date"],
        text: json["text"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "end_date": endDate,
        "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x)),
        "start_date": startDate,
        "text": text,
        "total": total,
      };
}

class ListReferral extends ListReferralEntity {
  const ListReferral({
    String? joinDate,
    String? name,
    int? nominal,
    String? validUntil,
    //
    String? createdAt,
    int? isActive,
  }) : super(
          joinDate: joinDate,
          name: name,
          nominal: nominal,
          validUntil: validUntil,
          //
          createdAt: createdAt,
          isActive: isActive,
        );

  static ListReferral fromJson(Map<String, dynamic> json) => ListReferral(
        joinDate: json["join_date"],
        name: json["name"],
        nominal: json["nominal"],
        validUntil: json["valid_until"],
        //
        createdAt: json["created_at"],
        isActive: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "join_date": joinDate,
        "name": name,
        "nominal": nominal,
        "valid_until": validUntil,
        //
        "created_at": createdAt,
        "is_active": isActive,
      };
}

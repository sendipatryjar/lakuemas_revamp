import '../../domain/entities/elite_register_entity.dart';

class EliteRegisterModel extends EliteRegisterEntity {
  const EliteRegisterModel({
    int? packageMonth,
    double? grammationPrice,
    String? transactionCode,
    String? packageType,
    String? subscriptionDateEnd,
    String? paymentMethod,
    String? autoRenewalPaymentMethod,
    String? createdAt,
  }) : super(
          packageMonth: packageMonth,
          grammationPrice: grammationPrice,
          transactionCode: transactionCode,
          packageType: packageType,
          subscriptionDateEnd: subscriptionDateEnd,
          paymentMethod: paymentMethod,
          autoRenewalPaymentMethod: autoRenewalPaymentMethod,
          createdAt: createdAt,
        );

  static EliteRegisterModel fromJson(Map<String, dynamic> json) =>
      EliteRegisterModel(
          packageMonth: json["package_month"],
          grammationPrice: json["grammation_price"]?.toDouble(),
          transactionCode: json["transaction_code"],
          packageType: json["package_type"],
          subscriptionDateEnd: json["subscription_date_end"],
          paymentMethod: json["payment_method"],
          autoRenewalPaymentMethod: json["auto_renewal_payment_method"],
          createdAt: json["created_at"]);

  Map<String, dynamic> toJson() => {
        "package_month": packageMonth,
        "grammation_price": grammationPrice,
        "transaction_code": transactionCode,
        "package_type": packageType,
        "subscription_date_end": subscriptionDateEnd,
        "payment_method": paymentMethod,
        "auto_renewal_payment_method": autoRenewalPaymentMethod,
        "created_at": createdAt,
      };
}

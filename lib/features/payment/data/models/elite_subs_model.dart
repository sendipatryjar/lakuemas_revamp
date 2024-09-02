import '../../domain/entities/elite_subs_entity.dart';

class EliteSubsModel extends EliteSubsEntity {
  const EliteSubsModel({
    String? packageMonth,
    String? grammationPrice,
    String? packageType,
    String? subscriptionDateEnd,
    String? paymentMethod,
    String? autoRenewalPaymentMethod,
  }) : super(
          packageMonth: packageMonth,
          grammationPrice: grammationPrice,
          packageType: packageType,
          subscriptionDateEnd: subscriptionDateEnd,
          paymentMethod: paymentMethod,
          autoRenewalPaymentMethod: autoRenewalPaymentMethod,
        );

  static EliteSubsModel fromJson(Map<String, dynamic> json) => EliteSubsModel(
        packageMonth: json["package_month"],
        grammationPrice: json["grammation_price"],
        packageType: json["package_type"],
        subscriptionDateEnd: json["subscription_date_end"],
        paymentMethod: json["payment_method"],
        autoRenewalPaymentMethod: json["auto_renewal_payment_method"],
      );

  Map<String, dynamic> toJson() => {
        "package_month": packageMonth,
        "grammation_price": grammationPrice,
        "package_type": packageType,
        "subscription_date_end": subscriptionDateEnd,
        "payment_method": paymentMethod,
        "auto_renewal_payment_method": autoRenewalPaymentMethod,
      };
}

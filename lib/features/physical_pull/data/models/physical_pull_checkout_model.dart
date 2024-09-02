import '../../../../features/physical_pull/domain/entities/physical_pull_checkout_entity.dart';

class PhysicalPullCheckoutModel extends PhysicalPullCheckoutEntity {
  const PhysicalPullCheckoutModel({
    int? transactionId,
    int? status,
    String? transactionCode,
    String? grossAmount,
    String? amount,
    String? serviceFee,
    String? deliveryFee,
    String? insuranceFee,
  }) : super(
          transactionId: transactionId,
          status: status,
          transactionCode: transactionCode,
          grossAmount: grossAmount,
          amount: amount,
          serviceFee: serviceFee,
          deliveryFee: deliveryFee,
          insuranceFee: insuranceFee,
        );

  static PhysicalPullCheckoutModel fromJson(Map<String, dynamic> json) {
    return PhysicalPullCheckoutModel(
      transactionId: json["transaction_id"],
      status: json["status"],
      transactionCode: json["transaction_code"],
      grossAmount: json["gross_amount"],
      amount: json["amount"],
      serviceFee: json["service_fee"],
      deliveryFee: json["delivery_fee"],
      insuranceFee: json["insurance_fee"],
    );
  }

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "status": status,
        "transaction_code": transactionCode,
        "gross_amount": grossAmount,
        "amount": amount,
        "service_fee": serviceFee,
        "delivery_fee": deliveryFee,
        "insurance_fee": insuranceFee,
      };
}

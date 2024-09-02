import '../../domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    int? transactionId,
    String? transactionCode,
  }) : super(
          transactionId: transactionId,
          transactionCode: transactionCode,
        );

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        transactionId: json['transaction_id'],
        transactionCode: json['transaction_code'],
      );

  Map<String, dynamic> toJson() => {
        'transaction_id': transactionId,
        'transaction_code': transactionCode,
      };
}

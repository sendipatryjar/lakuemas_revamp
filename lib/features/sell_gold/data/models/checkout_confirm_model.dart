import '../../domain/entities/checkout_confirm_entity.dart';

class CheckoutConfirmModel extends CheckoutConfirmEntity {
  const CheckoutConfirmModel({
    int? transactionId,
    String? transactionCode,
  }) : super(
          transactionId: transactionId,
          transactionCode: transactionCode,
        );

  factory CheckoutConfirmModel.fromJson(Map<String, dynamic> json) =>
      CheckoutConfirmModel(
        transactionId: json['transaction_id'],
        transactionCode: json['transaction_code'],
      );

  Map<String, dynamic> toJson() => {
        'transaction_id': transactionId,
        'transaction_code': transactionCode,
      };
}

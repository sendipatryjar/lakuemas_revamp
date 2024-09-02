import '../../domain/entities/transfer_checkout_entity.dart';

class TransferCheckoutModel extends TransferCheckoutEntity {
  const TransferCheckoutModel({String? transactionCode})
      : super(transactionCode: transactionCode);

  factory TransferCheckoutModel.fromJson(Map<String, dynamic> json) =>
      TransferCheckoutModel(
        transactionCode: json['transaction_code'],
      );

  Map<String, dynamic> toJson() => {
        'transaction_code': transactionCode,
      };
}

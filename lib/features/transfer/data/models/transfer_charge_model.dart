import '../../domain/entities/transfer_charge_entity.dart';

class TransferChargeModel extends TransferChargeEntity {
  const TransferChargeModel({
    String? accountName,
    String? accountNumber,
    String? goldWeight,
    String? transactionKey,
  }) : super(
          accountName: accountName,
          accountNumber: accountNumber,
          goldWeight: goldWeight,
          transactionKey: transactionKey,
        );

  factory TransferChargeModel.fromJson(Map<String, dynamic> json) =>
      TransferChargeModel(
        accountName: json['account_name'],
        accountNumber: json['account_number'],
        goldWeight: json['gold_weight'],
        transactionKey: json['transaction_key'],
      );

  Map<String, dynamic> toJson() => {
        'account_name': accountName,
        'account_number': accountNumber,
        'gold_weight': goldWeight,
        'transaction_key': transactionKey,
      };
}

import '../../domain/entities/voucher_redeemed_entity.dart';

class VoucherRedeemedModel extends VoucherRedeemedEntity {
  const VoucherRedeemedModel({
    int? transactionId,
    int? status,
    String? statusLabel,
    String? transactionCode,
    String? goldRedeemed,
  }) : super(
          transactionId: transactionId,
          status: status,
          statusLabel: statusLabel,
          transactionCode: transactionCode,
          goldRedeemed: goldRedeemed,
        );

  factory VoucherRedeemedModel.fromJson(Map<String, dynamic> json) =>
      VoucherRedeemedModel(
        transactionId: json['transaction_id'],
        status: json['status'],
        statusLabel: json['status_label'],
        transactionCode: json['transaction_code'],
        goldRedeemed: json['gold_redeemed'],
      );

  Map<String, dynamic> toJson() => {
        'transaction_id': transactionId,
        'status': status,
        'status_label': statusLabel,
        'transaction_code': transactionCode,
        'gold_redeemed': goldRedeemed,
      };
}

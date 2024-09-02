import '../../domain/entities/withdrawal_entity.dart';

class WithdrawalModel extends WithdrawalEntity {
  const WithdrawalModel({
    int? transactionId,
    int? status,
    String? amount,
    String? grossAmount,
    String? serviceFee,
    String? transactionCode,
  }) : super(
          transactionId: transactionId,
          status: status,
          amount: amount,
          grossAmount: grossAmount,
          serviceFee: serviceFee,
          transactionCode: transactionCode,
        );

  factory WithdrawalModel.fromJson(Map<String, dynamic> json) =>
      WithdrawalModel(
        transactionId: json['transaction_id'],
        status: json['status'],
        amount: json['amount'],
        grossAmount: json['gross_amount'],
        serviceFee: json['service_fee'],
        transactionCode: json['transaction_code'],
      );

  Map<String, dynamic> toJson() => {
        'transaction_id': transactionId,
        'status': status,
        'amount': amount,
        'gross_amount': grossAmount,
        'service_fee': serviceFee,
        'transaction_code': transactionCode,
      };
}

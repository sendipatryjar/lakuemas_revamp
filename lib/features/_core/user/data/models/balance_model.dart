import '../../domain/entities/balance_entity.dart';

class BalanceModel extends BalanceEntity {
  const BalanceModel({
    int? customerId,
    int? paymentMethodId,
    int? transactionStatus,
    double? nominalBalance,
    String? gramationBalance,
    String? accountNumber,
    String? transactionCode,
    String? type,
  }) : super(
          customerId: customerId,
          paymentMethodId: paymentMethodId,
          transactionStatus: transactionStatus,
          nominalBalance: nominalBalance,
          gramationBalance: gramationBalance,
          accountNumber: accountNumber,
          transactionCode: transactionCode,
          type: type,
        );

  factory BalanceModel.fromJson(Map<String, dynamic> json) {
    return BalanceModel(
      customerId: json['customer_id'],
      paymentMethodId: json['payment_method_id'],
      transactionStatus: json['transaction_status'],
      nominalBalance: (json['nominal_balance'] is int)
          ? (json['nominal_balance'] as int).toDouble()
          : json['nominal_balance'],
      gramationBalance: json['grammation_balance'],
      accountNumber: json['account_number'],
      transactionCode: json['transaction_code'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_id'] = customerId;
    data['payment_method_id'] = paymentMethodId;
    data['transaction_status'] = transactionStatus;
    data['nominal_balance'] = nominalBalance;
    data['grammation_balance'] = gramationBalance;
    data['account_number'] = accountNumber;
    data['transaction_code'] = transactionCode;
    data['type'] = type;
    return data;
  }
}

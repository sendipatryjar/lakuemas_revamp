import '../../domain/entities/mutation_entity.dart';

class MutationModel extends MutationEntity {
  const MutationModel({
    int? status,
    int? customerId,
    int? walletId,
    int? transactionId,
    String? code,
    String? type,
    String? mutationType,
    String? amount,
    String? balance,
    String? transactionDate,
  }) : super(
          status: status,
          customerId: customerId,
          walletId: walletId,
          transactionId: transactionId,
          code: code,
          type: type,
          mutationType: mutationType,
          amount: amount,
          balance: balance,
          transactionDate: transactionDate,
        );

  factory MutationModel.fromJson(Map<String, dynamic> json) => MutationModel(
        status: json['status'],
        customerId: json['customer_id'],
        walletId: json['wallet_id'],
        transactionId: json['transaction_id'],
        code: json['code'],
        type: json['type'],
        mutationType: json['mutation_type'],
        amount: json['amount'],
        balance: json['balance'],
        transactionDate: json['transaction_date'],
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'customer_id': customerId,
        'wallet_id': walletId,
        'transaction_id': transactionId,
        'code': code,
        'type': type,
        'mutation_type': mutationType,
        'amount': amount,
        'balance': balance,
        'transaction_date': transactionDate,
      };
}

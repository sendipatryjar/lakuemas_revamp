import 'package:equatable/equatable.dart';

class MutationEntity extends Equatable {
  final int? status;
  final int? customerId;
  final int? walletId;
  final int? transactionId;
  final String? code;
  final String? type;
  final String? mutationType;
  final String? amount;
  final String? balance;
  final String? transactionDate;

  const MutationEntity({
    this.status,
    this.customerId,
    this.walletId,
    this.transactionId,
    this.code,
    this.type,
    this.mutationType,
    this.amount,
    this.balance,
    this.transactionDate,
  });

  @override
  List<Object?> get props => [
        status,
        customerId,
        walletId,
        transactionId,
        code,
        type,
        mutationType,
        amount,
        balance,
        transactionDate,
      ];
}

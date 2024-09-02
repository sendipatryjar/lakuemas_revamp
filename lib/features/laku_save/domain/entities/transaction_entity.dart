import 'package:equatable/equatable.dart';

import 'deposit_entity.dart';

class TransactionEntity extends Equatable {
  final int? id;
  final int? status;
  final String? goldWeight;
  final String? typeLabel;
  final String? statusLabel;
  final String? code;
  final String? createdAt;
  final String? updatedAt;
  final DepositEntity? depositEntity;

  const TransactionEntity({
    this.id,
    this.status,
    this.goldWeight,
    this.typeLabel,
    this.statusLabel,
    this.code,
    this.createdAt,
    this.updatedAt,
    this.depositEntity,
  });

  @override
  List<Object?> get props => [
        id,
        status,
        goldWeight,
        typeLabel,
        statusLabel,
        code,
        createdAt,
        updatedAt,
        depositEntity,
      ];
}

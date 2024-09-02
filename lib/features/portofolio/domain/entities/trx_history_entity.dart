import 'package:equatable/equatable.dart';

import 'deposit_entity.dart';

class TrxHistoryEntity extends Equatable {
  final int? id;
  final int? status;
  final String? goldWeight;
  final String? grossAmount;
  final String? goldBalance;
  final String? typeLabel;
  final String? statusLabel;
  final String? code;
  final String? createdAt;
  final String? updatedAt;
  final DepositEntity? deposit;

  const TrxHistoryEntity({
    this.id,
    this.status,
    this.goldWeight,
    this.grossAmount,
    this.goldBalance,
    this.typeLabel,
    this.statusLabel,
    this.code,
    this.createdAt,
    this.updatedAt,
    this.deposit,
  });

  @override
  List<Object?> get props => [
        [
          id,
          status,
          goldWeight,
          grossAmount,
          goldBalance,
          typeLabel,
          statusLabel,
          code,
          createdAt,
          updatedAt,
          deposit,
        ],
      ];
}

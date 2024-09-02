import '../../domain/entities/transaction_entity.dart';
import 'deposit_model.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    int? id,
    int? status,
    String? goldWeight,
    String? typeLabel,
    String? statusLabel,
    String? code,
    String? createdAt,
    String? updatedAt,
    DepositModel? depositEntity,
  }) : super(
          id: id,
          status: status,
          goldWeight: goldWeight,
          typeLabel: typeLabel,
          statusLabel: statusLabel,
          code: code,
          createdAt: createdAt,
          updatedAt: updatedAt,
          depositEntity: depositEntity,
        );

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json['id'],
        status: json['status'],
        goldWeight: json['gold_weight'],
        typeLabel: json['type_label'],
        statusLabel: json['status_label'],
        code: json['code'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        depositEntity: json['deposit'] != null
            ? DepositModel.fromJson(json['deposit'])
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'status': status,
        'gold_weight': goldWeight,
        'type_label': typeLabel,
        'status_label': statusLabel,
        'code': code,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'deposit': depositEntity != null
            ? DepositModel(
                accountNumber: depositEntity?.accountNumber,
                interest: depositEntity?.interest,
                duration: depositEntity?.duration,
                durationType: depositEntity?.durationType,
                extendLabel: depositEntity?.extendLabel,
                startDate: depositEntity?.startDate,
                endDate: depositEntity?.endDate,
              ).toJson()
            : null,
      };
}

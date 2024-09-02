import '../../domain/entities/trx_history_entity.dart';
import 'deposit_model.dart';

class TrxHistoryModel extends TrxHistoryEntity {
  const TrxHistoryModel({
    int? id,
    int? status,
    String? goldWeight,
    String? grossAmount,
    String? goldBalance,
    String? typeLabel,
    String? statusLabel,
    String? code,
    String? createdAt,
    String? updatedAt,
    DepositModel? deposit,
  }) : super(
          id: id,
          status: status,
          goldWeight: goldWeight,
          grossAmount: grossAmount,
          goldBalance: goldBalance,
          typeLabel: typeLabel,
          statusLabel: statusLabel,
          code: code,
          createdAt: createdAt,
          updatedAt: updatedAt,
          deposit: deposit,
        );

  static TrxHistoryModel fromJson(Map<String, dynamic> json) => TrxHistoryModel(
        id: json["id"],
        status: json["status"],
        goldWeight: json["gold_weight"],
        grossAmount: json['gross_amount'],
        goldBalance: json['gold_balance'],
        typeLabel: json["type_label"],
        statusLabel: json["status_label"],
        code: json["code"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deposit: json["deposit"] == null
            ? null
            : DepositModel.fromJson(json["deposit"]),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["status"] = status;
    data["gold_weight"] = goldWeight;
    data["gross_amount"] = grossAmount;
    data["gold_balance"] = goldBalance;
    data["type_label"] = typeLabel;
    data["status_label"] = statusLabel;
    data["code"] = code;
    data["created_at"] = createdAt;
    data["updated_at"] = updatedAt;
    data["deposit"] = deposit;

    return data;
  }
}

import '../../domain/entities/lakusave_interest_entity.dart';

class LakusaveInterestModel extends LakusaveInterestEntity {
  const LakusaveInterestModel({
    int? id,
    int? depositDurationId,
    int? customerTypeId,
    double? interest,
    double? tax,
    double? minimumBalance,
    double? eliteMinimumBalance,
    double? maximumBalance,
    String? createdAt,
    String? updatedAt,
  }) : super(
          id: id,
          depositDurationId: depositDurationId,
          customerTypeId: customerTypeId,
          interest: interest,
          tax: tax,
          minimumBalance: minimumBalance,
          eliteMinimumBalance: eliteMinimumBalance,
          maximumBalance: maximumBalance,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  factory LakusaveInterestModel.fromJson(Map<String, dynamic> json) =>
      LakusaveInterestModel(
        id: json['id'],
        depositDurationId: json['deposit_duration_id'],
        customerTypeId: json['customer_type_id'],
        interest: json['interest'] is int
            ? (json['interest'] as int).toDouble()
            : json['interest'],
        tax: json['tax'] is int ? (json['tax'] as int).toDouble() : json['tax'],
        minimumBalance: json['minimum_balance'] is int
            ? (json['minimum_balance'] as int).toDouble()
            : json['minimum_balance'],
        eliteMinimumBalance: json['elite_minimum_balance'] is int
            ? (json['elite_minimum_balance'] as int).toDouble()
            : json['elite_minimum_balance'],
        maximumBalance: json['maximum_balance'] is int
            ? (json['maximum_balance'] as int).toDouble()
            : json['maximum_balance'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'deposit_duration_id': depositDurationId,
        'customer_type_id': customerTypeId,
        'interest': interest,
        'tax': tax,
        'minimum_balance': minimumBalance,
        'elite_minimum_balance': eliteMinimumBalance,
        'maximum_balance': maximumBalance,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

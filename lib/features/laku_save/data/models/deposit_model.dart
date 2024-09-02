import '../../domain/entities/deposit_entity.dart';

class DepositModel extends DepositEntity {
  const DepositModel({
    bool? isEnableUpdateExtend,
    String? accountNumber,
    String? interest,
    String? duration,
    String? durationType,
    String? extendLabel,
    String? startDate,
    String? endDate,
  }) : super(
          isEnableUpdateExtend: isEnableUpdateExtend,
          accountNumber: accountNumber,
          interest: interest,
          duration: duration,
          durationType: durationType,
          extendLabel: extendLabel,
          startDate: startDate,
          endDate: endDate,
        );

  factory DepositModel.fromJson(Map<String, dynamic> json) => DepositModel(
        isEnableUpdateExtend: json['is_enable_update_extend'],
        accountNumber: json['account_number'],
        interest: json['interest'],
        duration: json['duration'],
        durationType: json['duration_type'],
        extendLabel: json['extend_label'],
        startDate: json['start_date'],
        endDate: json['end_date'],
      );

  Map<String, dynamic> toJson() => {
        'is_enable_update_extend': isEnableUpdateExtend,
        'account_number': accountNumber,
        'interest': interest,
        'duration': duration,
        'duration_type': durationType,
        'extend_label': extendLabel,
        'start_date': startDate,
        'end_date': endDate,
      };
}

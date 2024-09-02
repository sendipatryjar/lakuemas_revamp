import 'package:equatable/equatable.dart';

class DepositEntity extends Equatable {
  final bool? isEnableUpdateExtend;
  final String? accountNumber;
  final String? interest;
  final String? duration;
  final String? durationType;
  final String? extendLabel;
  final String? startDate;
  final String? endDate;

  const DepositEntity({
    this.isEnableUpdateExtend,
    this.accountNumber,
    this.interest,
    this.duration,
    this.durationType,
    this.extendLabel,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
        isEnableUpdateExtend,
        accountNumber,
        interest,
        duration,
        durationType,
        extendLabel,
        startDate,
        endDate,
      ];
}

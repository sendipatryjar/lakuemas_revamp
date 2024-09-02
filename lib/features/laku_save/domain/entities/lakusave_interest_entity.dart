import 'package:equatable/equatable.dart';

class LakusaveInterestEntity extends Equatable {
  final int? id;
  final int? depositDurationId;
  final int? customerTypeId;
  final double? interest;
  final double? tax;
  final double? minimumBalance;
  final double? eliteMinimumBalance;
  final double? maximumBalance;
  final String? createdAt;
  final String? updatedAt;

  const LakusaveInterestEntity({
    this.id,
    this.depositDurationId,
    this.customerTypeId,
    this.interest,
    this.tax,
    this.minimumBalance,
    this.eliteMinimumBalance,
    this.maximumBalance,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        depositDurationId,
        customerTypeId,
        interest,
        tax,
        minimumBalance,
        eliteMinimumBalance,
        maximumBalance,
        createdAt,
        updatedAt,
      ];
}

import 'package:equatable/equatable.dart';

class ElitePaymentMethodEntity extends Equatable {
  final int? id;
  final double? nominalBalance;
  final double? grammationBalance;
  final double? nominalServiceFee;
  final double? percentageServiceFee;
  final String? label;

  const ElitePaymentMethodEntity({
    this.id,
    this.nominalBalance,
    this.grammationBalance,
    this.nominalServiceFee,
    this.percentageServiceFee,
    this.label,
  });

  @override
  List<Object> get props => [
        [
          id,
          nominalBalance,
          grammationBalance,
          nominalServiceFee,
          percentageServiceFee,
          label,
        ]
      ];
}

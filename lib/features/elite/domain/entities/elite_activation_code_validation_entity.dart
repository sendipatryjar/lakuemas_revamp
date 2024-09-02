import 'package:equatable/equatable.dart';

class EliteActivationCodeValidationEntity extends Equatable {
  final bool? isValid;
  final int? extendPeriod;
  final int? voucherId;
  final int? nominal;
  final double? grammation;
  final String? voucherCode;

  const EliteActivationCodeValidationEntity({
    this.isValid,
    this.extendPeriod,
    this.voucherId,
    this.nominal,
    this.grammation,
    this.voucherCode,
  });

  @override
  List<Object?> get props => [
        [
          isValid,
          extendPeriod,
          voucherId,
          nominal,
          grammation,
          voucherCode,
        ]
      ];
}

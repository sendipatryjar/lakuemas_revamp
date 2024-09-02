import 'package:equatable/equatable.dart';

import '../../../../physical_pull/domain/entities/detail_charge_entity.dart';

class CheckoutEntity extends Equatable {
  final String? goldAmount;
  final String? grossAmount;
  final String? rounding;
  final String? amount;
  final String? nominalTax;
  final String? percentageTax;
  final String? goldPrice;
  final String? transactionKey;
  final List<DetailChargeEntity>? detail;

  const CheckoutEntity({
    this.goldAmount,
    this.grossAmount,
    this.rounding,
    this.amount,
    this.nominalTax,
    this.percentageTax,
    this.goldPrice,
    this.transactionKey,
    this.detail,
  });

  @override
  List<Object?> get props => [
        goldAmount,
        grossAmount,
        rounding,
        amount,
        nominalTax,
        nominalTax,
        goldPrice,
        transactionKey,
        detail,
      ];
}

import 'package:equatable/equatable.dart';

class PaymentMethodEntity extends Equatable {
  final int? id;
  final int? nominalServiceFee;
  final double? percentageServiceFee;
  final String? name;
  final String? type;
  final String? imageUrl;
  //
  final double? accountBalance;

  const PaymentMethodEntity({
    this.id,
    this.nominalServiceFee,
    this.percentageServiceFee,
    this.name,
    this.type,
    this.imageUrl,
    this.accountBalance,
  });

  @override
  List<Object?> get props => [
        id,
        nominalServiceFee,
        percentageServiceFee,
        name,
        type,
        imageUrl,
        accountBalance,
      ];
}

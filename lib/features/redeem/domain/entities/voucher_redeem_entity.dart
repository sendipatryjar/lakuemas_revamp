import 'package:equatable/equatable.dart';

class VoucherRedeemEntity extends Equatable {
  final String? name;
  final String? code;
  final String? amount;
  final String? goldAmount;
  final String? sellingPrice;
  final String? purchasePrice;
  final String? tax;
  final String? goldRedeemed;

  const VoucherRedeemEntity({
    this.name,
    this.code,
    this.amount,
    this.goldAmount,
    this.sellingPrice,
    this.purchasePrice,
    this.tax,
    this.goldRedeemed,
  });

  @override
  List<Object?> get props => [
        name,
        code,
        amount,
        goldAmount,
        sellingPrice,
        purchasePrice,
        tax,
        goldRedeemed,
      ];
}

import '../../domain/entities/voucher_redeem_entity.dart';

class VoucherRedeemModel extends VoucherRedeemEntity {
  const VoucherRedeemModel({
    String? name,
    String? code,
    String? amount,
    String? goldAmount,
    String? sellingPrice,
    String? purchasePrice,
    String? tax,
    String? goldRedeemed,
  }) : super(
          name: name,
          code: code,
          amount: amount,
          goldAmount: goldAmount,
          sellingPrice: sellingPrice,
          purchasePrice: purchasePrice,
          tax: tax,
          goldRedeemed: goldRedeemed,
        );

  factory VoucherRedeemModel.fromJson(Map<String, dynamic> json) =>
      VoucherRedeemModel(
        name: json['name'],
        code: json['code'],
        amount: json['amount'],
        goldAmount: json['gold_amount'],
        sellingPrice: json['selling_price'],
        purchasePrice: json['purchase_price'],
        tax: json['tax'],
        goldRedeemed: json['gold_redeemed'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'code': code,
        'amount': amount,
        'gold_amount': goldAmount,
        'selling_price': sellingPrice,
        'purchase_price': purchasePrice,
        'tax': tax,
        'gold_redeemed': goldRedeemed,
      };
}

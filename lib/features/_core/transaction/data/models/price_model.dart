import '../../domain/entities/price_entity.dart';

class PriceModel extends PriceEntity {
  const PriceModel({
    String? price,
    String? sellingPrice,
    String? eliteSellingPrice,
    String? purchasePrice,
    String? elitePurchasePrice,
    String? taxPercentage,
    String? taxNominal,
    String? minimumNominal,
    String? minimumGrammation,
    List<dynamic>? placeholderNominal,
    List<dynamic>? placeholderGrammation,
    String? gatchaPrice,
    String? redeemElitePrice,
  }) : super(
          price: price,
          sellingPrice: sellingPrice,
          eliteSellingPrice: eliteSellingPrice,
          purchasePrice: purchasePrice,
          elitePurchasePrice: elitePurchasePrice,
          taxPercentage: taxPercentage,
          taxNominal: taxNominal,
          minimumNominal: minimumNominal,
          minimumGrammation: minimumGrammation,
          placeholderNominal: placeholderNominal,
          placeholderGrammation: placeholderGrammation,
          gatchaPrice: gatchaPrice,
          redeemElitePrice: redeemElitePrice,
        );

  factory PriceModel.fromJson(Map<String, dynamic> json) => PriceModel(
        price: json['price'],
        sellingPrice: json['selling_price'],
        eliteSellingPrice: json['elite_selling_price'],
        purchasePrice: json['purchase_price'],
        elitePurchasePrice: json['elite_purchase_price'],
        taxPercentage: json['tax_percentage'],
        taxNominal: json['tax_nominal'],
        minimumNominal: json['minimum_nominal'],
        minimumGrammation: json['minimum_grammation'],
        placeholderNominal: json['placeholder_nominal'],
        placeholderGrammation: json['placeholder_grammation'],
        gatchaPrice: json['gacha_price'],
        redeemElitePrice: json['redeem_elite_price'],
      );

  Map<String, dynamic> toJson() => {
        'price': price,
        'selling_price': sellingPrice,
        'elite_selling_price': eliteSellingPrice,
        'purchase_price': purchasePrice,
        'elite_purchase_price': elitePurchasePrice,
        'tax_percentage': taxPercentage,
        'tax_nominal': taxNominal,
        'minimum_nominal': minimumNominal,
        'minimum_grammation': minimumGrammation,
        'placeholder_nominal': placeholderNominal,
        'placeholder_grammation': placeholderGrammation,
        'gacha_price': gatchaPrice,
        'redeem_elite_price': redeemElitePrice,
      };
}

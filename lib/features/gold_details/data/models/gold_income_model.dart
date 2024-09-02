import '../../domain/entities/gold_income_entity.dart';

class GoldIncomeModel extends GoldIncomeEntity {
  const GoldIncomeModel({
    String? avgPurchasePrice,
    String? goldValue,
    String? purchasePrice,
    String? marketPrice,
    String? incomeValue,
    String? incomePercentage,
  }) : super(
          avgPurchasePrice: avgPurchasePrice,
          goldValue: goldValue,
          purchasePrice: purchasePrice,
          marketPrice: marketPrice,
          incomeValue: incomeValue,
          incomePercentage: incomePercentage,
        );

  factory GoldIncomeModel.fromJson(Map<String, dynamic> json) {
    return GoldIncomeModel(
        avgPurchasePrice: json['average_purchase_price'],
        goldValue: json['gold_value'],
        purchasePrice: json['purchase_price'],
        marketPrice: json['market_price'],
        incomeValue: json['income_value'],
        incomePercentage: json['income_percentage']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['average_purchase_price'] = avgPurchasePrice;
    data['gold_value'] = goldValue;
    data['purchase_price'] = purchasePrice;
    data['market_price'] = marketPrice;
    data['income_value'] = incomeValue;
    data['income_percentage'] = incomePercentage;
    return data;
  }
}

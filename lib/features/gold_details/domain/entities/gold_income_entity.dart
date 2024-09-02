import 'package:equatable/equatable.dart';

class GoldIncomeEntity extends Equatable {
  final String? avgPurchasePrice;
  final String? goldValue;
  final String? purchasePrice;
  final String? marketPrice;
  final String? incomeValue;
  final String? incomePercentage;

  const GoldIncomeEntity({
    this.avgPurchasePrice,
    this.goldValue,
    this.purchasePrice,
    this.marketPrice,
    this.incomeValue,
    this.incomePercentage,
  });

  @override
  List<Object?> get props => [
        avgPurchasePrice,
        goldValue,
        purchasePrice,
        marketPrice,
        incomeValue,
        incomePercentage,
      ];
}

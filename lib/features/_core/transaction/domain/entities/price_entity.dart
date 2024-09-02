import 'package:equatable/equatable.dart';

class PriceEntity extends Equatable {
  final String? price;
  final String? sellingPrice;
  final String? eliteSellingPrice;
  final String? purchasePrice;
  final String? elitePurchasePrice;
  final String? taxPercentage;
  final String? taxNominal;
  final String? minimumNominal;
  final String? minimumGrammation;
  final List<dynamic>? placeholderNominal;
  final List<dynamic>? placeholderGrammation;
  final String? gatchaPrice;
  final String? redeemElitePrice;

  const PriceEntity({
    this.price,
    this.sellingPrice,
    this.eliteSellingPrice,
    this.purchasePrice,
    this.elitePurchasePrice,
    this.taxPercentage,
    this.taxNominal,
    this.minimumNominal,
    this.minimumGrammation,
    this.placeholderNominal,
    this.placeholderGrammation,
    this.gatchaPrice,
    this.redeemElitePrice,
  });

  @override
  List<Object?> get props => [
        price,
        sellingPrice,
        eliteSellingPrice,
        purchasePrice,
        elitePurchasePrice,
        taxPercentage,
        taxNominal,
        minimumNominal,
        minimumGrammation,
        placeholderNominal,
        placeholderGrammation,
        gatchaPrice,
        redeemElitePrice,
      ];
}

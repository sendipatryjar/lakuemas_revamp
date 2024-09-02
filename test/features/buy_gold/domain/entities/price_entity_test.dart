import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/_core/transaction/domain/entities/price_entity.dart';

void main() {
  test(
    'price entity',
    () {
      const result = PriceEntity(
        price: '990000',
        sellingPrice: '990000',
        eliteSellingPrice: '990000',
        purchasePrice: '990000',
        elitePurchasePrice: '990000',
        taxPercentage: '3',
        taxNominal: '3000',
        minimumNominal: '50000',
        minimumGrammation: "0.05",
        placeholderNominal: ['100000', '200000'],
        placeholderGrammation: ["1.00", "2.00"],
      );

      expect(result, isNotNull);
      expect(result.price, equals('990000'));
      expect(result.sellingPrice, equals('990000'));
      expect(result.eliteSellingPrice, equals('990000'));
      expect(result.purchasePrice, equals('990000'));
      expect(result.elitePurchasePrice, equals('990000'));
      expect(result.taxPercentage, equals('3'));
      expect(result.taxNominal, equals('3000'));
      expect(result.minimumNominal, equals('50000'));
      expect(result.minimumGrammation, equals('0.05'));
      expect(result.placeholderNominal, equals(['100000', '200000']));
      expect(result.placeholderGrammation, equals(['1.00', '2.00']));
    },
  );
}

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lakuemas/features/_core/transaction/domain/entities/price_entity.dart';
import 'package:lakuemas/features/_core/user/domain/entities/balance_entity.dart';
import 'package:lakuemas/features/buy_gold/presentation/cubits/buy_gold/buy_gold_cubit.dart';
import 'package:lakuemas/features/coupon/domain/entities/coupon_detail_entity.dart';

void main() {
  late BuyGoldCubit buyGoldCubit;

  setUp(() {
    buyGoldCubit = BuyGoldCubit();
  });

  tearDown(() {
    buyGoldCubit.close();
  });

  group('BuyGoldCubit', () {
    const couponDetailEntity = CouponDetailEntity(
      couponCode: 'code',
      couponName: 'cName',
      description: 'desc',
      discountGramation: '10',
      discountNominal: '10',
      discountPercentage: '10',
      expiredDate: '11',
      imageUrl: 'url',
      maximumDiscountNominal: '10',
      minimumAmount: '10',
      tnc: 'tnc',
    );

    const balanceEntity = BalanceEntity(
      accountNumber: '111111',
      customerId: 1,
      gramationBalance: '100',
      nominalBalance: 1000000.0,
      paymentMethodId: 24,
      transactionCode: 'PREPKey',
      transactionStatus: 3,
      type: 'type',
    );

    const pEntity = PriceEntity(
      elitePurchasePrice: '100000',
      eliteSellingPrice: '90000',
      minimumGrammation: '1',
      minimumNominal: '50000',
      placeholderGrammation: [],
      placeholderNominal: [],
      price: '100000',
      purchasePrice: '100000',
      sellingPrice: '90000',
      taxNominal: '25000',
      taxPercentage: '2',
    );

    blocTest<BuyGoldCubit, BuyGoldState>(
      'changes state when changeCoupon is called',
      build: () => buyGoldCubit,
      act: (cubit) =>
          cubit.changeCoupon(value: couponDetailEntity, isNullify: false),
      expect: () => [
        const BuyGoldState(
          enBuyGoldOn: EnBuyGoldOn.nominal,
          couponDetailEntity: couponDetailEntity,
        ),
      ],
    );

    blocTest<BuyGoldCubit, BuyGoldState>(
      'changes state when changeBalance is called',
      build: () => buyGoldCubit,
      act: (cubit) => cubit.changeBalance(balanceEntity),
      expect: () => [
        const BuyGoldState(
          enBuyGoldOn: EnBuyGoldOn.nominal,
          balanceEntity: balanceEntity,
        ),
      ],
    );

    blocTest<BuyGoldCubit, BuyGoldState>(
      'changes state when changePricing is called',
      build: () => buyGoldCubit,
      act: (cubit) => cubit.changePricing(pEntity),
      expect: () => [
        const BuyGoldState(
          enBuyGoldOn: EnBuyGoldOn.nominal,
          priceEntity: pEntity,
        ),
      ],
    );

    blocTest<BuyGoldCubit, BuyGoldState>(
      'changes state when changeTab is called',
      build: () => buyGoldCubit,
      act: (cubit) => cubit.changeTab(
        EnBuyGoldOn.gram,
      ),
      expect: () => [
        const BuyGoldState(
          enBuyGoldOn: EnBuyGoldOn.gram,
        ),
      ],
    );
  });
}

part of 'buy_gold_cubit.dart';

enum EnBuyGoldOn { nominal, gram }

class BuyGoldState extends Equatable {
  final EnBuyGoldOn enBuyGoldOn;
  final bool isError;
  final double? denom;
  final double? equalsTo;
  final double? price;
  final double? truePrice;
  final double? totalPrice;
  final double? rounding;
  final BalanceEntity? balanceEntity;
  final PriceEntity? priceEntity;
  final CouponDetailEntity? couponDetailEntity;
  const BuyGoldState({
    required this.enBuyGoldOn,
    this.isError = false,
    this.denom,
    this.equalsTo,
    this.price,
    this.truePrice,
    this.totalPrice,
    this.rounding,
    this.balanceEntity,
    this.priceEntity,
    this.couponDetailEntity,
  });

  BuyGoldState copyWith({
    EnBuyGoldOn? enBuyGoldOn,
    bool? isError,
    double? denom,
    double? equalsTo,
    double? price,
    double? truePrice,
    double? totalPrice,
    double? rounding,
    BalanceEntity? balanceEntity,
    PriceEntity? priceEntity,
    CouponDetailEntity? couponDetailEntity,
    bool? isNullifyCoupon,
  }) =>
      BuyGoldState(
        enBuyGoldOn: enBuyGoldOn ?? this.enBuyGoldOn,
        isError: isError ?? this.isError,
        denom: denom ?? this.denom,
        equalsTo: equalsTo ?? this.equalsTo,
        price: price ?? this.price,
        truePrice: truePrice ?? this.truePrice,
        totalPrice: totalPrice ?? this.totalPrice,
        rounding: rounding ?? this.rounding,
        balanceEntity: balanceEntity ?? this.balanceEntity,
        priceEntity: priceEntity ?? this.priceEntity,
        couponDetailEntity: isNullifyCoupon == true
            ? null
            : (couponDetailEntity ?? this.couponDetailEntity),
      );

  @override
  List<Object> get props => [
        enBuyGoldOn,
        isError,
        [
          denom,
          equalsTo,
          price,
          truePrice,
          totalPrice,
          rounding,
          balanceEntity,
          priceEntity,
          couponDetailEntity
        ]
      ];
}

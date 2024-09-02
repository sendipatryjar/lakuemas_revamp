part of 'sell_gold_cubit.dart';

enum EnSellGoldOn { nominal, gram }

class SellGoldState extends Equatable {
  final EnSellGoldOn enSellGoldOn;
  final bool isError;
  final double? denom;
  final double? equalsTo;
  final double? price;
  final double? totalPrice;
  final BalanceEntity? balanceEntity;
  final PriceEntity? priceEntity;
  const SellGoldState({
    required this.enSellGoldOn,
    this.isError = false,
    this.denom,
    this.equalsTo,
    this.price,
    this.totalPrice,
    this.balanceEntity,
    this.priceEntity,
  });

  SellGoldState copyWith({
    EnSellGoldOn? enSellGoldOn,
    bool? isError,
    double? denom,
    double? equalsTo,
    double? price,
    double? totalPrice,
    BalanceEntity? balanceEntity,
    PriceEntity? priceEntity,
  }) =>
      SellGoldState(
        enSellGoldOn: enSellGoldOn ?? this.enSellGoldOn,
        isError: isError ?? this.isError,
        denom: denom ?? this.denom,
        equalsTo: equalsTo ?? this.equalsTo,
        price: price ?? this.price,
        totalPrice: totalPrice ?? this.totalPrice,
        balanceEntity: balanceEntity ?? this.balanceEntity,
        priceEntity: priceEntity ?? this.priceEntity,
      );

  @override
  List<Object> get props => [
        enSellGoldOn,
        isError,
        [denom, equalsTo, price, totalPrice, balanceEntity, priceEntity]
      ];
}

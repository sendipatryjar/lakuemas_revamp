import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../cores/extensions/currency_extension.dart';

import '../../../../../cores/utils/app_utils.dart';
import '../../../../_core/transaction/domain/entities/price_entity.dart';
import '../../../../_core/user/domain/entities/balance_entity.dart';
import '../../../../coupon/domain/entities/coupon_detail_entity.dart';

part 'buy_gold_state.dart';

class BuyGoldCubit extends Cubit<BuyGoldState> {
  BuyGoldCubit()
      : super(const BuyGoldState(
          enBuyGoldOn: EnBuyGoldOn.nominal,
          isError: false,
        ));

  double get denomMin {
    switch (state.enBuyGoldOn) {
      case EnBuyGoldOn.gram:
        return double.tryParse(state.priceEntity?.minimumGrammation ?? '') ??
            0.05;
      default:
        return double.parse((state.priceEntity?.minimumNominal ?? '50000'));
    }
  }

  double get taxNominal {
    return (double.parse((state.priceEntity?.taxPercentage ?? '').isNotEmpty
                ? state.priceEntity!.taxPercentage!
                : '0') /
            100) *
        (double.tryParse(state.priceEntity?.price ?? '') ?? 0);
    // switch (state.enSellGoldOn) {
    //   case EnSellGoldOn.gram:
    //     return double.tryParse(state.priceEntity?.minimumGrammation ?? '') ??
    //         0.0122;
    //   default:
    //     return (state.priceEntity?.minimumNominal ?? 10000).toDouble();
    // }
  }

  void changeCoupon({bool isNullify = false, CouponDetailEntity? value}) {
    final aaa =
        state.copyWith(isNullifyCoupon: isNullify, couponDetailEntity: value);
    emit(aaa);
  }

  void changeBalance(BalanceEntity? balance) =>
      emit(state.copyWith(balanceEntity: balance));

  void changePricing(PriceEntity? price) =>
      emit(state.copyWith(priceEntity: price));

  void changeTab(EnBuyGoldOn enBuyGoldOn) =>
      emit(state.copyWith(enBuyGoldOn: enBuyGoldOn, isError: false));

  void validateDenom(String denom) {
    double? dblDenom = double.tryParse(denom) ?? 0.0;
    if (state.enBuyGoldOn == EnBuyGoldOn.nominal) {
      dblDenom = double.tryParse(denom.replaceAll('.', '')) ?? 0.0;
    }
    bool isNotValid = dblDenom < denomMin;
    emit(state.copyWith(isError: isNotValid, denom: dblDenom));
    _calculatePrice(dblDenom);
  }

  void _calculatePrice(double denom) {
    double? equalsTo =
        denom * (double.tryParse(state.priceEntity?.price ?? '') ?? 0);
    double? price =
        denom * (double.tryParse(state.priceEntity?.price ?? '') ?? 0);
    double? truePrice = 0;
    double? rounding = 0;
    if (state.enBuyGoldOn == EnBuyGoldOn.nominal) {
      equalsTo = denom / (double.tryParse(state.priceEntity?.price ?? '') ?? 0);
      appPrint('equalsTo: $equalsTo');
      // String? equalsToStr = equalsTo.toStringAsFixed(4);
      String? equalsToStr = equalsTo.toGold4Dec();
      equalsTo = double.tryParse(equalsToStr);
      // price = ((equalsTo ?? 0) *
      //         (double.tryParse(state.priceEntity?.price ?? '') ?? 0))
      //     .ceilToDouble();
      truePrice = ((equalsTo ?? 0) *
              (double.tryParse(state.priceEntity?.price ?? '') ?? 0))
          .ceilToDouble();
      rounding = denom - truePrice;
    }
    double taxPriceNominal = denom *
        (double.tryParse(state.priceEntity?.taxPercentage ?? '') ?? 0) /
        100;
    double? totalPriceNominal = denom + taxPriceNominal;

    if (state.enBuyGoldOn == EnBuyGoldOn.nominal) {
      emit(state.copyWith(
        equalsTo: equalsTo,
        price: denom,
        truePrice: truePrice,
        totalPrice: totalPriceNominal,
        rounding: rounding,
      ));
      return;
    }

    double taxPrice = price *
        (double.tryParse(state.priceEntity?.taxPercentage ?? '') ?? 0) /
        100;
    double? totalPrice = price + taxPrice;
    emit(state.copyWith(
      equalsTo: equalsTo,
      price: price,
      truePrice: price,
      totalPrice: totalPrice,
      rounding: rounding,
    ));
  }
}

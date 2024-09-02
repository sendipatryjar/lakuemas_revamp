import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../cores/extensions/currency_extension.dart';

import '../../../../../cores/utils/app_utils.dart';
import '../../../../_core/transaction/domain/entities/price_entity.dart';
import '../../../../_core/user/domain/entities/balance_entity.dart';

part 'sell_gold_state.dart';

class SellGoldCubit extends Cubit<SellGoldState> {
  SellGoldCubit()
      : super(const SellGoldState(
          enSellGoldOn: EnSellGoldOn.nominal,
          isError: false,
        ));

  double get denomMin {
    return double.parse((state.priceEntity?.minimumNominal ?? '50000'));
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

  void changeBalance(BalanceEntity? balance) =>
      emit(state.copyWith(balanceEntity: balance));

  void changePricing(PriceEntity? price) =>
      emit(state.copyWith(priceEntity: price));

  void changeTab(EnSellGoldOn enBuyGoldOn) =>
      emit(state.copyWith(enSellGoldOn: enBuyGoldOn, isError: false));

  void validateDenom(String denom) {
    double? dblDenom = double.tryParse(denom) ?? 0.0;
    if (state.enSellGoldOn == EnSellGoldOn.nominal) {
      dblDenom = double.tryParse(denom.replaceAll('.', '')) ?? 0.0;
    }
    emit(state.copyWith(denom: dblDenom));
    _calculatePrice(dblDenom);
  }

  void _calculatePrice(double denom) {
    double? equalsTo =
        denom * (double.tryParse(state.priceEntity?.price ?? '') ?? 0);
    double? price =
        denom * (double.tryParse(state.priceEntity?.price ?? '') ?? 0);
    if (state.enSellGoldOn == EnSellGoldOn.nominal) {
      equalsTo = denom / (double.tryParse(state.priceEntity?.price ?? '') ?? 0);
      appPrint('equalsTo: $equalsTo');
      String? equalsToStr = equalsTo.toGold4Dec();
      equalsTo = double.tryParse(equalsToStr);
      price = ((equalsTo ?? 0) *
              (double.tryParse(state.priceEntity?.price ?? '') ?? 0))
          .ceilToDouble();
    }
    double taxPrice = price *
        ((double.tryParse(state.priceEntity?.taxPercentage ?? '') ?? 0) / 100);
    double? totalPrice = price + taxPrice;

    bool isNotValid = totalPrice < denomMin;
    emit(state.copyWith(
        isError: isNotValid,
        equalsTo: equalsTo,
        price: price,
        totalPrice: totalPrice));
  }
}

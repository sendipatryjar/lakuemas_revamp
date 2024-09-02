import 'package:equatable/equatable.dart';

import 'laku_trade_cashback_entity.dart';
import 'laku_trade_item_entity.dart';
import 'laku_trade_payment_entity.dart';
import 'laku_trade_store_entity.dart';

class LakuTradeQrDataEntity extends Equatable {
  final String? qrCode;
  final LakuTradeStoreEntity? storeEntity;
  final LakuTradePaymentEntity? paymentEntity;
  final LakuTradeItemEntity? itemEntity;
  final LakuTradeCashbackEntity? cashbackEntity;

  const LakuTradeQrDataEntity({
    this.qrCode,
    this.storeEntity,
    this.paymentEntity,
    this.itemEntity,
    this.cashbackEntity,
  });

  @override
  List<Object?> get props => [
        qrCode,
        storeEntity,
        paymentEntity,
        itemEntity,
        cashbackEntity,
      ];
}

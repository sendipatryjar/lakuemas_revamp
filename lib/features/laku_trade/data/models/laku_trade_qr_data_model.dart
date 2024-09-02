import '../../domain/entities/laku_trade_qr_data_entity.dart';
import 'laku_trade_cashback_model.dart';
import 'laku_trade_item_model.dart';
import 'laku_trade_payment_model.dart';
import 'laku_trade_store_model.dart';

class LakuTradeQrDataModel extends LakuTradeQrDataEntity {
  const LakuTradeQrDataModel({
    String? qrCode,
    LakuTradeStoreModel? storeEntity,
    LakuTradePaymentModel? paymentEntity,
    LakuTradeItemModel? itemEntity,
    LakuTradeCashbackModel? cashbackEntity,
  }) : super(
          qrCode: qrCode,
          storeEntity: storeEntity,
          paymentEntity: paymentEntity,
          itemEntity: itemEntity,
          cashbackEntity: cashbackEntity,
        );

  factory LakuTradeQrDataModel.fromJson(Map<String, dynamic> json) =>
      LakuTradeQrDataModel(
        qrCode: json['qrcode'],
        storeEntity: json['store'] != null
            ? LakuTradeStoreModel.fromJson(json['store'])
            : null,
        paymentEntity: json['payment'] != null
            ? LakuTradePaymentModel.fromJson(json['payment'])
            : null,
        itemEntity: json['item'] != null
            ? LakuTradeItemModel.fromJson(json['item'])
            : null,
        cashbackEntity: json['cashback'] != null
            ? LakuTradeCashbackModel.fromJson(json['cashback'])
            : null,
      );

  // Map<String, dynamic> toJson() => {
  //       'store': nominal,
  //       'payment': rate,
  //       'item': remark,
  //       'cashback': cash
  //     };
}

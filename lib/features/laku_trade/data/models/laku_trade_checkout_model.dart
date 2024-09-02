import '../../domain/entities/laku_trade_checkout_entity.dart';

class LakuTradeCheckoutModel extends LakuTradeCheckoutEntity {
  const LakuTradeCheckoutModel({
    final String? tid,
    final String? transactionCode,
    final String? traceNo,
  }) : super(
          tid: tid,
          transactionCode: transactionCode,
          traceNo: traceNo,
        );

  factory LakuTradeCheckoutModel.fromJson(Map<String, dynamic> json) =>
      LakuTradeCheckoutModel(
        tid: json['tid'],
        transactionCode: json['transaction_code'],
        traceNo: json['traceNo'],
      );

  Map<String, dynamic> toJson() => {
        'tid': tid,
        'transaction_code': transactionCode,
        'trace_no': traceNo,
      };
}

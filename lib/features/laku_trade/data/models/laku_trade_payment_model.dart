import '../../domain/entities/laku_trade_payment_entity.dart';

class LakuTradePaymentModel extends LakuTradePaymentEntity {
  const LakuTradePaymentModel({
    String? type,
    String? gold,
    String? cash,
    String? tax,
    String? convert,
    String? total,
    String? totalCash,
  }) : super(
          type: type,
          gold: gold,
          cash: cash,
          tax: tax,
          convert: convert,
          total: total,
          totalCash: totalCash,
        );

  factory LakuTradePaymentModel.fromJson(Map<String, dynamic> json) =>
      LakuTradePaymentModel(
        type: json['type'],
        gold: json['gold'],
        cash: json['cash'],
        tax: json['tax'],
        convert: json['convert'],
        total: json['total'],
        totalCash: json['total_cash'],
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'gold': gold,
        'cash': cash,
        'tax': tax,
        'convert': convert,
        'total': total,
        'total_cash': totalCash,
      };
}

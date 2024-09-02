import '../../domain/entities/laku_trade_cashback_entity.dart';

class LakuTradeCashbackModel extends LakuTradeCashbackEntity {
  const LakuTradeCashbackModel({
    String? nominal,
    String? rate,
    String? remark,
  }) : super(
          nominal: nominal,
          rate: rate,
          remark: remark,
        );

  factory LakuTradeCashbackModel.fromJson(Map<String, dynamic> json) =>
      LakuTradeCashbackModel(
        nominal: json['nominal'],
        rate: json['rate'],
        remark: json['remark'],
      );

  Map<String, dynamic> toJson() => {
        'nominal': nominal,
        'rate': rate,
        'remark': remark,
      };
}
